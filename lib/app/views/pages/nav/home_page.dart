import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final authC = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            title: font2XL("친구", fonts: "NotoB"),
            actions: [
              InkWell(
                child: Image.asset("assets/add-btn.png"),
              )
            ],
            backgroundColor: Colors.white,
            elevation: 0.3,
          ),
          body: ListView(
            children: [
              //header
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.03,
                    top: Get.height * 0.012,
                    bottom: Get.height * 0.008),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: Get.width * 0.02,
                        bottom: Get.height * 0.01,
                      ),
                      child: fontS("친구추가", color: 0xff707070),
                    ),
                    Row(
                      children: [
                        Container(
                          width: Get.width * 0.13,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.ADDUSER);
                            },
                            child: Image.asset(
                              "assets/user-add.png",
                              width: Get.width * 0.13,
                            ),
                          ),
                        ),
                        Obx(
                          () => Container(
                            width: Get.width * 0.8,
                            height: Get.width * 0.13,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: authC.recommendUserList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(left: Get.width * 0.01),
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.PRORILEDETAIL,
                                            arguments: {
                                              "user": authC
                                                  .recommendUserList[index],
                                              "friendRecommend": true
                                            });
                                      },
                                      child: profileImage(Get.width * 0.13,
                                          image:
                                              "${authC.recommendUserList[index].photoUrl ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}"),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Divider(),

              //my
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(
                      left: Get.width * 0.05,
                      top: Get.height * 0.01,
                      bottom: Get.height * 0.01),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.PRORILEDETAIL,
                              arguments: {"user": authC.user.value});
                        },
                        child: profileImage(Get.width * 0.15,
                            image: authC.user.value.photoUrl!),
                      ),
                      Padding(padding: EdgeInsets.only(left: Get.width * 0.03)),
                      fontS(authC.user.value.name!, color: 0xff707070),
                    ],
                  ),
                ),
              ),
              //friend
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(
                    left: Get.width * 0.05,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          fontS("친구 ", color: 0xff707070),
                          fontS("${authC.user.value.followUser?.length}",
                              color: 0xff707070, fonts: "NeoB"),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: Get.height,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: authC.user.value.followUser?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(top: Get.height * 0.01),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.PRORILEDETAIL,
                                            arguments: {
                                              "user": authC
                                                  .user.value.followUser?[index]
                                            });
                                      },
                                      child: profileImage(Get.width * 0.12,
                                          image:
                                              "${authC.user.value.followUser?[index].photoUrl ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}"),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: Get.width * 0.03)),
                                    InkWell(
                                      onTap: () {
                                        authC.createFirebaseChatRoom(
                                            authC.user.value.followUser?[index]
                                                .email,
                                            authC.user.value.followUser?[index]
                                                .name);
                                      },
                                      child: Container(
                                        height: Get.height * 0.05,
                                        width: Get.width * 0.7,
                                        child: Center(
                                          child: Row(
                                            children: [
                                              fontS(
                                                  "${authC.user.value.followUser?[index].name}",
                                                  color: 0xff707070),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
