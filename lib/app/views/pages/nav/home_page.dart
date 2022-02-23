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
                onTap: () {
                  Get.toNamed(Routes.ADDUSER);
                },
              )
            ],
            backgroundColor: Colors.white,
            elevation: 0.3,
          ),
          body: ListView(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //header
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.03, top: Get.height * 0.012),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: Get.width * 0.02,
                      ),
                      child: fontS("친구추가", color: 0xff707070),
                    ),
                    Container(
                      height: Get.height * 0.07,
                      child:
                          ListView(scrollDirection: Axis.horizontal, children: [
                        InkWell(
                          onTap: () {
                            authC.streamChatsAll(
                                authC.user.value.email.toString());
                          },
                          child: Container(
                              width: Get.width * 0.15,
                              child: Image.asset(
                                "assets/user-add.png",
                                width: Get.width * 0.14,
                              )),
                        ),
                        Container(
                            width: Get.width * 0.15,
                            child: Image.asset(
                              "assets/user-bg-01.png",
                              width: Get.width * 0.14,
                            )),
                        Container(
                            width: Get.width * 0.15,
                            child: Image.asset(
                              "assets/user-bg-02.png",
                              width: Get.width * 0.14,
                            )),
                        Container(
                            width: Get.width * 0.15,
                            child: Image.asset(
                              "assets/user-bg-01.png",
                              width: Get.width * 0.14,
                            )),
                        Container(
                            width: Get.width * 0.15,
                            child: Image.asset(
                              "assets/user-bg-02.png",
                              width: Get.width * 0.14,
                            )),
                        Container(
                            width: Get.width * 0.15,
                            child: Image.asset(
                              "assets/user-bg-01.png",
                              width: Get.width * 0.14,
                            )),
                        Container(
                            width: Get.width * 0.15,
                            child: Image.asset(
                              "assets/user-bg-02.png",
                              width: Get.width * 0.14,
                            )),
                      ]),
                    ),
                  ],
                ),
              ),

              // Container(
              //   height: Get.height * 0.1,
              //   child: ListView.builder(
              //     itemCount: 10,
              //     itemBuilder: (BuildContext context, int index) {
              //       if (index == 0) return Image.asset("assets/user-bg-01.png");
              //       return Image.asset("assets/user-bg-01.png");
              //     },
              //   ),
              // ),

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
                      profileImage(Get.width * 0.15,
                          image: authC.user.value.photoUrl!),
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
                                child: InkWell(
                                  onTap: () {
                                    authC.createFirebaseChatRoom(
                                        authC.user.value.followUser?[index]
                                            .email,
                                        authC.user.value.followUser?[index]
                                            .name);
                                  },
                                  child: Row(
                                    children: [
                                      profileImage(Get.width * 0.12,
                                          image:
                                              "${authC.user.value.followUser?[index].photoUrl ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}"),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: Get.width * 0.03)),
                                      fontS(
                                          "${authC.user.value.followUser?[index].name}",
                                          color: 0xff707070),
                                    ],
                                  ),
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

// class HomePage extends StatelessWidget {
//   final authC = AuthController.to;
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0.2,
//           leading: Center(
//               child: Padding(
//             padding: const EdgeInsets.only(left: 8),
//             child: Text("친구",
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                 )),
//           )),
//           actions: [
//             IconButton(
//               icon: Icon(Icons.add, color: Colors.black),
//               onPressed: () => {},
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: Get.width * 0.05,
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: Get.width * 0.05),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: Get.width * 0.15,
//                           height: Get.width * 0.15,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(22),
//                             child: Image.network(
//                               authC.user.value.photoUrl!,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.only(right: Get.height * 0.02),
//                         ),
//                         fontS("${authC.user.value.name}")
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: Get.height * 0.02),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             border: Border(
//                           bottom: BorderSide(
//                             color: Colors.grey,
//                             width: 0.1,
//                           ),
//                         )),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: Get.height * 0.02),
//                       child: Row(
//                         children: [
//                           fontSM(
//                             "친구",
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: Get.height * 0.02),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: Get.width * 0.12,
//                             height: Get.width * 0.12,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(17),
//                               child: Image.network(
//                                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyGnV38qI3kabyXoa6e9eOn9960Lcnzj3jGA&usqp=CAU",
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: Get.width * 0.02),
//                           ),
//                           fontS("미현")
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: Get.height * 0.02),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: Get.width * 0.12,
//                             height: Get.width * 0.12,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(17),
//                               child: Image.network(
//                                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyGnV38qI3kabyXoa6e9eOn9960Lcnzj3jGA&usqp=CAU",
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: Get.width * 0.02),
//                           ),
//                           fontS("미현")
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: Get.height * 0.015),
//                       child: Row(
//                         children: [
//                           Container(
//                             width: Get.width * 0.12,
//                             height: Get.width * 0.12,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(17),
//                               child: Image.network(
//                                 "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyGnV38qI3kabyXoa6e9eOn9960Lcnzj3jGA&usqp=CAU",
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: EdgeInsets.only(right: Get.width * 0.02),
//                           ),
//                           fontS("미현")
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
