import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/screens/edit_user.dart';
import 'package:loginpage/widgets/getuserdetails.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final user = FirebaseAuth.instance.currentUser!;

  List<String> docIDs = [];

  /// get DocIDs
  Future<List<String>> getDocIDs() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').get();
    List<String> docIDs = [];
    snapshot.docs.forEach((document) {
      String docID = document.reference.id;
      if (!docIDs.contains(docID)) {
        docIDs.add(docID);
      }
    });
    return docIDs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName ?? ''),
              accountEmail: Text(user.email ?? ''),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Tài khoản'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Giỏ hàng'),
              onTap: () {
                // Xử lý khi nhấn vào Giỏ hàng
              },
            ),
            ListTile(
              leading: Icon(Icons.inventory),
              title: Text('Mặt hàng'),
              onTap: () {
                // Xử lý khi nhấn vào Mặt hàng
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Đăng xuất'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context); // Đóng Drawer
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Signed In as " + user.email!),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.deepPurpleAccent[200],
              child: Text(
                "Đăng xuất",
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
        Expanded(
          child: FutureBuilder<List<String>>(
            future: getDocIDs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Đã xảy ra lỗi');
              } else {
                List<String> docIDs = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: GetUserName(documentId: docIDs[index]),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
        ),
      ),
    );
  }
}
