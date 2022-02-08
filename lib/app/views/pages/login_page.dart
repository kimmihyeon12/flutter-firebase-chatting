import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/routers/app_routes.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: Get.height * 0.25)),
              Container(
                child: Image.asset(
                  "assets/cat.gif",
                  width: Get.width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Get.height * 0.05)),
              fontM("SNS 로그인", fonts: "NotoB"),
              Padding(padding: EdgeInsets.only(top: Get.height * 0.03)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Image.asset(
                      "assets/kakao-btn.png",
                      width: Get.width * 0.18,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      print("kakao login");
                      Get.offAllNamed(Routes.Nav);
                    },
                  ),
                  Padding(padding: EdgeInsets.only(right: Get.height * 0.03)),
                  InkWell(
                    child: Image.asset(
                      "assets/google-btn.png",
                      width: Get.width * 0.18,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      print("google login");
                      Get.offAllNamed(Routes.Nav);
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: Get.height * 0.12)),
              fontM("ⓒ Hoho Crop.", color: 0xff707070),
            ],
          ),
        ),
      ),
    );
  }
}
