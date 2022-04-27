import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/addFriendBtn.dart';
import 'package:chatting_app/app/views/widgets/camera.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class ProfileDetail extends StatelessWidget {
  var user = Get.arguments["user"];
  var friendRecommend = Get.arguments["friendRecommend"] == null ? false : true;
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE8E1E1),
        body: SingleChildScrollView(
          child: Container(
            child: Obx(
              () => Stack(
                children: [
                  user.backgroundImgUrl == null
                      ? Container()
                      : Image.network(
                          "${user.backgroundImgUrl}",
                          fit: BoxFit.fill,
                          width: authC.width + 20,
                          height: authC.height,
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
                        Padding(
                            padding: EdgeInsets.only(top: authC.height * 0.7)),
                        authC.user.value.email == user.email
                            ? profileImage(authC.width * 0.3,
                                round: 60.0,
                                image:
                                    "${authC.user.value.photoUrl ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}")
                            : profileImage(authC.width * 0.3,
                                round: 60.0,
                                image:
                                    "${user.photoUrl ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}"),
                        Padding(
                            padding: EdgeInsets.only(top: authC.height * 0.02)),
                        fontM("${user.name}", fonts: "NeoB"),
                        fontS("${user.email}"),
                        Padding(
                            padding: EdgeInsets.only(top: authC.height * 0.01)),
                        friendRecommend
                            ? AddFreindBtn(user.email)
                            : Container(),
                        authC.user.value.email == user.email
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: authC.width * 0.5,
                                    height: authC.height * 0.035,
                                    child: TextFormField(
                                      autocorrect: false,
                                      textAlign: TextAlign.center,
                                      controller: authC.textC,
                                      decoration: new InputDecoration(
                                        hintText: "상태메세지",
                                        fillColor: Colors.white,
                                      ),
                                      validator: (val) {},
                                      style: TextStyle(
                                        fontFamily: "NeoL",
                                        fontSize: 15,
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        await authC.profileStatusUpdate(
                                            authC.textC.text);
                                      },
                                      child: Image.asset("assets/pen.png"))
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                  authC.user.value.email == user.email
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: authC.height * 0.8,
                              left: authC.width * 0.58),
                          child: Camera(authC.width * 0.07, context),
                        )
                      : Container(),
                  // authC.user.value.email == user.email
                  //     ? Padding(
                  //         padding: EdgeInsets.only(
                  //             bottom: authC.height * 0.02,
                  //             right: authC.width * 0.05),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: [
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.end,
                  //               children: [
                  //                 Camera(authC.width * 0.08, context,
                  //                     background: true)
                  //               ],
                  //             ),
                  //           ],
                  //         ),
                  //       )
                  //     : Container()
                ],
              ),
            ),
          ),
        ));
  }
}
