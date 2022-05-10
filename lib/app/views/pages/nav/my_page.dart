import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';

class Mypage extends StatelessWidget {
  final authC = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Row(
        children: [
          InkWell(
              onTap: () {
                authC.logout();
              },
              child: fontS("로그아웃")),
          InkWell(
              onTap: () {
                authC.withdrawal(authC.user.value.email);
              },
              child: fontS("회원탈퇴")),
        ],
      ),
    );
  }
}
