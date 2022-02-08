import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: font2XL("채팅", fonts: "NotoB"),
        backgroundColor: Colors.white,
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(left: Get.width * 0.045, top: Get.height * 0.015),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset("assets/user-bg-02.png",
                      width: Get.width * 0.15,
                      height: Get.width * 0.15,
                      fit: BoxFit.cover),
                  Padding(padding: EdgeInsets.only(left: Get.width * 0.03)),
                  Container(
                    width: Get.width * 0.58,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fontS("김미현", color: 0xff000000, fonts: "NeoB"),
                        Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.002)),
                        fontS("고맙습니다 진우랑 추억이 쌓였어요ㅎ", color: 0xff707070),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      fontS(
                        "오후 2:23",
                        color: 0xff707070,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.002)),
                      Container(
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 7, right: 7, bottom: 1),
                              child: fontS("12", color: 0xffffffff)),
                          decoration: BoxDecoration(
                              color: Color(0xffff2057),
                              borderRadius:
                                  BorderRadius.circular(50), //모서리를 둥글게
                              border: Border.all(
                                  color: Color(0xffff2057), width: 1))),
                    ],
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: Get.height * 0.015)),
              Row(
                children: [
                  Image.asset("assets/user-bg-02.png",
                      width: Get.width * 0.15,
                      height: Get.width * 0.15,
                      fit: BoxFit.cover),
                  Padding(padding: EdgeInsets.only(left: Get.width * 0.03)),
                  Container(
                    width: Get.width * 0.58,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fontS("멜론쥬스바나나킥", color: 0xff000000, fonts: "NeoB"),
                        Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.002)),
                        fontS("고맙습니다 진우랑 추억이 쌓였어요ㅎ", color: 0xff707070),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      fontS(
                        "오후 2:23",
                        color: 0xff707070,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.002)),
                      Container(
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 7, right: 7, bottom: 1),
                              child: fontS("123", color: 0xffffffff)),
                          decoration: BoxDecoration(
                              color: Color(0xffff2057),
                              borderRadius:
                                  BorderRadius.circular(50), //모서리를 둥글게
                              border: Border.all(
                                  color: Color(0xffff2057), width: 1))),
                    ],
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: Get.height * 0.015)),
              Row(
                children: [
                  Image.asset("assets/user-bg-02.png",
                      width: Get.width * 0.15,
                      height: Get.width * 0.15,
                      fit: BoxFit.cover),
                  Padding(padding: EdgeInsets.only(left: Get.width * 0.03)),
                  Container(
                    width: Get.width * 0.58,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fontS("초코파이", color: 0xff000000, fonts: "NeoB"),
                        Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.002)),
                        fontS("고맙습니다 진우랑 추억이 쌓였어요ㅎ", color: 0xff707070),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      fontS(
                        "오후 2:23",
                        color: 0xff707070,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.002)),
                      Container(
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 7, right: 7, bottom: 1),
                              child: fontS("1", color: 0xffffffff)),
                          decoration: BoxDecoration(
                              color: Color(0xffff2057),
                              borderRadius:
                                  BorderRadius.circular(50), //모서리를 둥글게
                              border: Border.all(
                                  color: Color(0xffff2057), width: 1))),
                    ],
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(top: Get.height * 0.015)),
              Row(
                children: [
                  Image.asset("assets/user-bg-02.png",
                      width: Get.width * 0.15,
                      height: Get.width * 0.15,
                      fit: BoxFit.cover),
                  Padding(padding: EdgeInsets.only(left: Get.width * 0.03)),
                  Container(
                    width: Get.width * 0.58,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fontS("민트쿠키", color: 0xff000000, fonts: "NeoB"),
                        Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.002)),
                        fontS("고맙습니다 진우랑 추억이 쌓였어요ㅎ", color: 0xff707070),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      fontS(
                        "오후 2:23",
                        color: 0xff707070,
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: Get.height * 0.002)),
                      Container(
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 7, right: 7, bottom: 1),
                              child: fontS("1", color: 0xffffffff)),
                          decoration: BoxDecoration(
                              color: Color(0xffff2057),
                              borderRadius:
                                  BorderRadius.circular(50), //모서리를 둥글게
                              border: Border.all(
                                  color: Color(0xffff2057), width: 1))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
