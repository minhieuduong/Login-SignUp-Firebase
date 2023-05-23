import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emaiController = TextEditingController();


  //giải phóng bộ điều khiển _emaiController để tránh lỗi và tiêu tốn tài nguyên không cần thiết
  @override
  void dispose() {
    _emaiController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emaiController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text('Đã gửi mật khẩu khôi phục! Hãy kiểm tra hòm thư của bạn'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(e.message.toString()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0 ,
      ),
      body: Column (
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              "Nhập email của bạn và chúng tôi sẽ gửi cho bạn một liên kết để bạn cập nhật lại mật khẩu",
              style: TextStyle (
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emaiController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Nhập email khôi phục',
                fillColor: Colors.white, //Đổi màu Textfield
                filled: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(Icons.lock, color: Colors.deepPurple),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            onPressed: passwordReset,
            child: Text(
              'Xác nhận',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            color: Colors.deepPurple,
            //Tạo hình dạng cho MaterialButton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.white),
            ),
          ),
        ],
      )
    );
  }
}
