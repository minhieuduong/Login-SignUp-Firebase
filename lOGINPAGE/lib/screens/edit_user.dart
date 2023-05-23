import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/getuserdetails.dart';
import 'package:flutter/foundation.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _fullNameController = TextEditingController();
  late String _currentUserId;
  late String _currentFullName;

  @override
  void initState() {
    super.initState();
    _currentUserId = '';
    _getCurrentUserData();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _currentUserId = user.uid;
        _currentFullName = userData.get('full name') ?? '';
        _fullNameController.text = _currentFullName;
      });
    }
  }

  Future<void> _updateFullName() async {
    final newFullName = _fullNameController.text.trim();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUserId)
        .update({'full name': newFullName});

    setState(() {
      _currentFullName = newFullName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tên đã được cập nhật thành công.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên hiện tại:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            SizedBox(height: 16),
            Text(
              'Tên mới:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nhập tên mới',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateFullName,
              child: Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
