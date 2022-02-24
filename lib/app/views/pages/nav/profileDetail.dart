import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/camera.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class ProfileDetail extends StatelessWidget {
  var argument = Get.arguments;
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    print(authC.user.value.backgroundImgUrl);
    return Scaffold(
        backgroundColor: Color(0xffE8E1E1),
        body: Container(
          child: Obx(
            () => Stack(
              children: [
                argument.backgroundImgUrl == null
                    ? Container()
                    : Image.network(
                        "${argument.backgroundImgUrl}",
                        fit: BoxFit.fill,
                        width: Get.width + 20,
                        height: Get.height,
                      ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Icon(Icons.cancel_outlined),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: Get.height * 0.7)),
                      authC.user.value.email == argument.email
                          ? profileImage(Get.width * 0.3,
                              round: 60.0,
                              image:
                                  "${authC.user.value.photoUrl ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}")
                          : profileImage(Get.width * 0.3,
                              round: 60.0,
                              image:
                                  "${argument.photoUrl ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}"),
                      Padding(padding: EdgeInsets.only(top: Get.height * 0.02)),
                      fontM("${argument.name}", fonts: "NeoB"),
                      fontS("${argument.email}")
                    ],
                  ),
                ),
                authC.user.value.email == argument.email
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: Get.height * 0.8, left: Get.width * 0.58),
                        child: Camera(Get.width * 0.07, context),
                      )
                    : Container(),
                authC.user.value.email == argument.email
                    ? Padding(
                        padding: EdgeInsets.only(
                            bottom: Get.height * 0.02, right: Get.width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Camera(Get.width * 0.08, context,
                                    background: true)
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ));
  }
}
