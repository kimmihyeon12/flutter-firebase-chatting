import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/ChatController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreview extends GetView<ChatController> {
  final authC = AuthController.to;
  var argument = Get.arguments as Map<String, dynamic>;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context); //뒤로가기
                },
                color: Colors.grey,
                icon: Icon(Icons.arrow_back_ios)),
            centerTitle: false,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: Get.width * 0.05),
                child: Center(
                    child: InkWell(
                        onTap: () async {
                          await controller.createChat(
                            authC.user.value.email!,
                            argument,
                            img: argument["img"],
                          );
                          Get.back();
                        },
                        child: fontM("전송"))),
              )
            ],
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(argument["img"]), //File Image를 삽입
                    fit: BoxFit.contain)),
          ))),
    );
  }
}
