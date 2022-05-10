import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                onTap: () {
                  Get.toNamed(Routes.MYPAGE);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    "assets/user-gear-solid.svg",
                    height: authC.height * 0.03,
                    color: Color(0xffc7c7c7),
                  ),
                ),
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
                    left: authC.width * 0.03,
                    top: authC.height * 0.012,
                    bottom: authC.height * 0.008),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: authC.width * 0.02,
                        bottom: authC.height * 0.01,
                      ),
                      child: fontS("친구추가", color: 0xff707070),
                    ),
                    Row(
                      children: [
                        Container(
                          width: authC.width * 0.13,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.ADDUSER);
                            },
                            child: Container(
                                width: authC.width * 0.13,
                                height: authC.width * 0.13,
                                child: Center(
                                  child: SvgPicture.asset(
                                    "assets/plus-solid.svg",
                                    height: authC.height * 0.03,
                                    color: Colors.white,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xffEBEBEB),
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        ),
                        Obx(
                          () => Container(
                            width: authC.width * 0.8,
                            height: authC.width * 0.13,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: authC.recommendUserList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: authC.width * 0.01),
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(Routes.PRORILEDETAIL,
                                            arguments: {
                                              "user": authC
                                                  .recommendUserList[index],
                                              "friendRecommend": true
                                            });
                                      },
                                      child: profileImage(authC.width * 0.13,
                                          image: authC.recommendUserList[index]
                                              .prvPhotoUrl),
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
                      left: authC.width * 0.05,
                      top: authC.height * 0.01,
                      bottom: authC.height * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed(Routes.PRORILEDETAIL,
                                  arguments: {"user": authC.user.value});
                            },
                            child: profileImage(authC.width * 0.15,
                                image: authC.user.value.prvPhotoUrl),
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(left: authC.width * 0.03)),
                          fontS(authC.user.value.name!, color: 0xff707070),
                        ],
                      ),
                      authC.user.value.status == ""
                          ? Container()
                          : Padding(
                              padding:
                                  EdgeInsets.only(right: authC.width * 0.02),
                              child: Container(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, bottom: 5, top: 2),
                                  child: fontS(authC.user.value.status!,
                                      color: 0xffffffff),
                                ),
                                // constraints:
                                //     BoxConstraints(maxWidth: authC.width * 0.6),
                                decoration: BoxDecoration(
                                    color: Color(0xffc7c7c7),
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              //friend
              Obx(
                () => Padding(
                  padding: EdgeInsets.only(
                    left: authC.width * 0.05,
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
                        height: authC.height.value,
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: authC.user.value.followUser?.length,
                            itemBuilder: (BuildContext context, int index) {
                              print(authC.user.value.followUser?[index]);
                              return Slidable(
                                  // Specify a key if the Slidable is dismissible.
                                  key: const ValueKey(0),

                                  // The end action pane is the one at the right or the bottom side.
                                  endActionPane: ActionPane(
                                    motion: ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: null,
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.white,
                                        icon: Icons.archive,
                                        label: 'Archive',
                                      ),
                                      SlidableAction(
                                        onPressed: (ctx) => {
                                          authC.createUnfollowUser(authC.user
                                              .value.followUser?[index].email)
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        label: '차단',
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: authC.height * 0.01),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Get.toNamed(
                                                    Routes.PRORILEDETAIL,
                                                    arguments: {
                                                      "user": authC.user.value
                                                          .followUser?[index]
                                                    });
                                              },
                                              child: profileImage(
                                                  authC.width * 0.12,
                                                  image: authC
                                                      .user
                                                      .value
                                                      .followUser?[index]
                                                      .prvPhotoUrl),
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    left: authC.width * 0.03)),
                                            InkWell(
                                              onTap: () {
                                                authC.createFirebaseChatRoom(
                                                    authC.user.value
                                                        .followUser?[index]);
                                              },
                                              child: Container(
                                                height: authC.height * 0.05,
                                                width: authC.width * 0.5,
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
                                        authC.user.value.followUser?[index]
                                                    .status! ==
                                                ""
                                            ? Container()
                                            : Padding(
                                                padding: EdgeInsets.only(
                                                    right: authC.width * 0.02),
                                                child: Container(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 5,
                                                        top: 2),
                                                    child: fontS(
                                                        '${authC.user.value.followUser?[index].status!}',
                                                        color: 0xffffffff),
                                                  ),
                                                  constraints: BoxConstraints(
                                                      maxWidth:
                                                          authC.width * 0.6),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffc7c7c7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ));
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
