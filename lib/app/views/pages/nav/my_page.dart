import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends StatelessWidget {
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AvatarGlow(
          endRadius: 60,
          glowColor: Colors.black,
          duration: Duration(seconds: 2),
          child: Container(
            margin: EdgeInsets.all(15),
            width: Get.width * 0.25,
            height: Get.width * 0.25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35),
              child: authC.user.value.photoUrl! == "noimage"
                  ? Image.asset(
                      "assets/logo/noimage.png",
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      authC.user.value.photoUrl!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        fontM("${authC.user.value.name}"),
        fontM("${authC.user.value.email}"),
      ],
    ));
  }
}
