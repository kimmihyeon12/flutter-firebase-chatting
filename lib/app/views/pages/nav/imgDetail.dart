import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/ChatController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImageDetail extends GetView<ChatController> {
  final authC = AuthController.to;

  var img = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
                color: Colors.white,
                disabledColor: Colors.white,
                focusColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context); //뒤로가기
                },
                icon: Icon(Icons.arrow_back_ios)),
            centerTitle: false,
            actions: [
              Padding(
                padding: EdgeInsets.only(right: authC.width * 0.05),
                child: Center(
                    child: InkWell(
                        onTap: () async {
                          controller.setIsLoading();
                          await GallerySaver.saveImage(img! + ".jpg")
                              .then((value) => {
                                    print('>>>> save value= $value'),
                                    controller.setIsLoading()
                                  })
                              .catchError((err) {
                            print('error :( $err');
                          });
                        },
                        child: SvgPicture.asset("assets/arrow-down-regular.svg",
                            height: authC.height * 0.03, color: Colors.white))),
              )
            ],
            elevation: 0,
          ),
          body: Obx(() => Stack(
                children: [
                  Container(
                    child: Center(
                        child: Image.network(
                      img,
                      width: Get.width,
                      fit: BoxFit.fitWidth,
                    )),
                  ),
                  controller.isLoading.value
                      ? Container(
                          height: Get.height,
                          width: Get.width,
                          child: Center(
                              child:
                                  Center(child: CircularProgressIndicator())))
                      : Container()
                ],
              ))),
    );
  }
}
