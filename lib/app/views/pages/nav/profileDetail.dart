import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/addFriendBtn.dart';
import 'package:chatting_app/app/views/widgets/camera.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/avd.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileDetail extends StatelessWidget {
  var user = Get.arguments["user"];
  var friendRecommend = Get.arguments["friendRecommend"] == null ? false : true;
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            user.backgroundImgUrl == null ? Colors.grey : Colors.black,
        body: SingleChildScrollView(
          child: Container(
            child: Obx(
              () => Stack(
                children: [
                  user.backgroundImgUrl == null
                      ? Container()
                      : Container(
                          height: authC.height.value,
                          child: Center(
                            child: Image.network("${user.backgroundImgUrl}",
                                width: authC.width.value),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          child: SvgPicture.asset(
                            "assets/xmark-solid.svg",
                            height: authC.height.value * 0.03,
                            color: Colors.white,
                          ),
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
                                round: 60.0, image: user.prvPhotoUrl)
                            : profileImage(authC.width * 0.3,
                                round: 60.0, image: user.prvPhotoUrl),
                        Padding(
                            padding: EdgeInsets.only(top: authC.height * 0.02)),
                        fontM("${user.name}", fonts: "NeoB", color: 0XFFFFFFFF),
                        Padding(
                            padding:
                                EdgeInsets.only(top: authC.height * 0.005)),
                        fontS("${user.email}", color: 0XFFFFFFFF),
                        Padding(
                            padding:
                                EdgeInsets.only(top: authC.height * 0.005)),
                        friendRecommend
                            ? Padding(
                                padding:
                                    EdgeInsets.only(top: authC.height * 0.005),
                                child: AddFreindBtn(user.email),
                              )
                            : Container(),
                        Padding(
                            padding: EdgeInsets.only(top: authC.height * 0.01)),
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
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      validator: (val) {},
                                      style: TextStyle(
                                        fontFamily: "NeoL",
                                        fontSize: 15,
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await authC.profileStatusUpdate(
                                          authC.textC.text);
                                    },
                                    child: SvgPicture.asset(
                                      "assets/pencil-light.svg",
                                      height: authC.height.value * 0.02,
                                      color: Colors.white,
                                    ),
                                  )
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
                  authC.user.value.email == user.email
                      ? Container(
                          height: authC.height.value,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Camera(authC.width * 0.08, context,
                                        background: true),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ));
  }
}
