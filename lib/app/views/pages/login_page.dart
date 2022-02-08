import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatelessWidget {
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                child: Image.asset(
                  "assets/cat.gif",
                  width: Get.width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
              fontM("SNS 로그인", fonts: "NotoB"),
              fontM("ⓒ Hoho Crop.", color: 0xff707070),
            ],
          ),
        ),
      ),
    );
  }
}
