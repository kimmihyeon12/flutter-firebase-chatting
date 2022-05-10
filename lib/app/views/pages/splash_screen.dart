import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
        child: Stack(
          children: [
            Image.asset(
              "assets/background.jpg",
              fit: BoxFit.fill,
              width: Get.width + 20,
              height: Get.height,
            ),
            Center(
              child: Image.asset(
                "assets/chatlogo.png",
                width: Get.width * 0.2,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: Get.height * 0.9),
                child: Image.asset(
                  "assets/hohologo.png",
                  width: Get.width * 0.3,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
