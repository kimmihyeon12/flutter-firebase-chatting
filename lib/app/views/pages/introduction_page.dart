import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class IntroductionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "새로운 친구를 만들어보세요",
            body: "친구를 사귀어 채팅해보세요. 당신이 이 앱을 사용한다면 하루를 즐겁게 보낼수 있습니다",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/loading.json"),
              ),
            ),
          ),
          PageViewModel(
            title: "무료로 즐겨보세요",
            body: "걱정하지 마세요, 이 앱은 무료입니다",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/loading.json"),
              ),
            ),
          ),
          PageViewModel(
            title: "뭐라고하지",
            body: "우리 중 한 명이 되라고 등록하세요. 우리는 1000명의 다른 친구들과 연결될 것이다.",
            image: Container(
              width: Get.width * 0.6,
              height: Get.width * 0.6,
              child: Center(
                child: Lottie.asset("assets/loading.json"),
              ),
            ),
          ),
        ],
        onDone: () => Get.offAllNamed(Routes.LOGIN),
        showSkipButton: true,
        skip: Text("Skip"),
        next: Text(
          "Next",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        done: const Text(
          "로그인",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
