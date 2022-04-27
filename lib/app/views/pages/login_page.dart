import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginPage extends StatelessWidget {
  final authC = AuthController.to;

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    print(MediaQuery.of(context).padding.top);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: Size().height * 0.25)),
              Container(
                child: Image.asset(
                  "assets/cat.gif",
                  width: Size().width * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(padding: EdgeInsets.only(top: Size().height * 0.05)),
              fontM("SNS 로그인", fonts: "NotoB"),
              Padding(padding: EdgeInsets.only(top: Size().height * 0.03)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child: Image.asset(
                      "assets/kakao-btn.png",
                      width: Size().width * 0.18,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      // print("kakao login");
                      // Get.offAllNamed(Routes.Nav);
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: Size().height * 0.03)),
                  InkWell(
                    child: Image.asset(
                      "assets/google-btn.png",
                      width: Size().width * 0.18,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      authC.login();
                    },
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: Size().height * 0.12)),
              fontM("ⓒ Hoho Crop.", color: 0xff707070),
            ],
          ),
        ),
      ),
    );
  }
}
