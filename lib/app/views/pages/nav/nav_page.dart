import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/ChatController.dart';
import 'package:chatting_app/app/controller/NavController.dart';
import 'package:chatting_app/app/views/pages/nav/chat_page.dart';
import 'package:chatting_app/app/views/pages/nav/home_page.dart';
import 'package:chatting_app/app/views/pages/nav/calender.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

List<Widget> navPages = [HomePage(), ChatPage(), Calender()];

class NavPage extends StatelessWidget {
  final authC = AuthController.to;
  final chatC = ChatController.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => IndexedStack(
            index: NavController.to.selectedIndex.value,
            children: navPages, // 페이지와 연결
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,

          items: [
            BottomNavigationBarItem(
                icon: NavController.to.selectedIndex.value == 0
                    ? SvgPicture.asset(
                        "assets/house-solid.svg",
                        height: authC.height * 0.028,
                        color: Color(0xffFF728E),
                      )
                    : SvgPicture.asset(
                        "assets/house-solid.svg",
                        height: authC.height * 0.028,
                        color: Color(0xffc7c7c7),
                      ),
                label: 'home'),
            BottomNavigationBarItem(
                icon: NavController.to.selectedIndex.value == 1
                    ? Container(
                        child:
                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: chatC
                              .chatsStream(authC.user.value.email.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                return FutureBuilder(
                                    future: chatC.streamLastChatsSum(
                                        authC.user.value.email.toString()),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                                      if (snapshot.hasData == false) {
                                        return SvgPicture.asset(
                                          "assets/comment-dots-solid.svg",
                                          height: authC.height * 0.03,
                                          color: Color(0xffFF728E),
                                        );
                                      }
                                      //error가 발생하게 될 경우 반환하게 되는 부분
                                      else if (snapshot.hasError) {
                                        return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SvgPicture.asset(
                                              "assets/comment-dots-solid.svg",
                                              height: authC.height * 0.03,
                                              color: Color(0xffFF728E),
                                            ));
                                      }
                                      // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                      else {
                                        return Stack(
                                          children: [
                                            SvgPicture.asset(
                                              "assets/comment-dots-solid.svg",
                                              height: authC.height * 0.03,
                                              color: Color(0xffFF728E),
                                            ),
                                            snapshot.data == 0
                                                ? Container(
                                                    width: 0,
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                      left: Get.width * 0.04,
                                                    ),
                                                    child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Color(0xffFF728E),
                                                          border: Border.all(
                                                              width: 1.0,
                                                              color:
                                                                  Colors.white),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      30.0) // POINT
                                                                  ),
                                                        ),
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 6,
                                                                  vertical: 3),
                                                          child: fontSM(
                                                              "${snapshot.data}",
                                                              color:
                                                                  0xffffffff),
                                                        )),
                                                  ),
                                          ],
                                        );
                                      }
                                    });
                              }
                            } else {
                              return SvgPicture.asset(
                                "assets/comment-dots-solid.svg",
                                height: authC.height * 0.03,
                                color: Color(0xffFF728E),
                              );
                              ;
                            }
                            return SvgPicture.asset(
                              "assets/comment-dots-solid.svg",
                              height: authC.height * 0.03,
                              color: Color(0xffFF728E),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Container(
                          child: StreamBuilder<
                              QuerySnapshot<Map<String, dynamic>>>(
                            stream: chatC
                                .chatsStream(authC.user.value.email.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  return FutureBuilder(
                                      future: chatC.streamLastChatsSum(
                                          authC.user.value.email.toString()),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                                        if (snapshot.hasData == false) {
                                          return SvgPicture.asset(
                                            "assets/comment-dots-solid.svg",
                                            height: authC.height * 0.03,
                                            color: Color(0xffc7c7c7),
                                          );
                                          ;
                                        }
                                        //error가 발생하게 될 경우 반환하게 되는 부분
                                        else if (snapshot.hasError) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Error: ${snapshot.error}',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                        }
                                        // 데이터를 정상적으로 받아오게 되면 다음 부분을 실행하게 되는 것이다.
                                        else {
                                          return Stack(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/comment-dots-solid.svg",
                                                height: authC.height * 0.03,
                                                color: Color(0xffc7c7c7),
                                              ),
                                              snapshot.data == 0
                                                  ? Container(
                                                      width: 0,
                                                    )
                                                  : Padding(
                                                      padding: EdgeInsets.only(
                                                        left: Get.width * 0.04,
                                                      ),
                                                      child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Color(
                                                                0xffFF728E),
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        30.0) // POINT
                                                                    ),
                                                          ),
                                                          child: Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        6,
                                                                    vertical:
                                                                        2),
                                                            child: fontSM(
                                                                "${snapshot.data}",
                                                                color:
                                                                    0xffffffff),
                                                          )),
                                                    ),
                                            ],
                                          );
                                        }
                                      });
                                }
                              } else {
                                return SvgPicture.asset(
                                  "assets/comment-dots-solid.svg",
                                  height: authC.height * 0.03,
                                  color: Color(0xffc7c7c7),
                                );
                              }
                              return SvgPicture.asset(
                                "assets/comment-dots-solid.svg",
                                height: authC.height * 0.03,
                                color: Color(0xffc7c7c7),
                              );
                            },
                          ),
                        ),
                      ),
                label: 'chat'),
            BottomNavigationBarItem(
                icon: NavController.to.selectedIndex.value == 2
                    ? SvgPicture.asset(
                        "assets/calendar-check-solid.svg",
                        height: authC.height * 0.028,
                        color: Color(0xffFF728E),
                      )
                    : SvgPicture.asset(
                        "assets/calendar-check-solid.svg",
                        height: authC.height * 0.028,
                        color: Color(0xffc7c7c7),
                      ),
                label: 'chat'),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.emoji_emotions_outlined,
            //     ),
            //     label: 'my'),
          ],
          currentIndex: NavController.to.selectedIndex.value,

          onTap: (index) => {NavController.to.selectedIndex(index)},
          showSelectedLabels: false, //(1)
          showUnselectedLabels: false, //(1)
          type: BottomNavigationBarType.fixed, //(2)
        ),
      ),
    );
  }
}
