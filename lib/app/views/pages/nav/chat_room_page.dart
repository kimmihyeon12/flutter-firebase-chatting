import 'dart:async';

import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/ChatController.dart';
import 'package:chatting_app/app/views/widgets/chat_message.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoomPage extends GetView<ChatController> {
  final authC = AuthController.to;
  final List<ChatMessage> messages = <ChatMessage>[];
  final Map argument = Get.arguments as Map<String, dynamic>;

  @override
  Widget build(BuildContext context) {
    print(argument);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(top: 5),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.grey,
              icon: Icon(Icons.arrow_back_ios)),
        ),
        title: Padding(
          padding: EdgeInsets.only(right: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              fontM("${argument["friendName"]}",
                  fonts: "NeoB", color: 0xff707070),
              fontM("님과의 채팅", color: 0xff707070),
            ],
          ),
        ),
        elevation: 0.3,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/chat-bg.png",
                  width: Get.width + 20,
                  height: Get.height * 0.81,
                ),
                Container(
                  height: Get.height * 0.81,
                  width: Get.width,
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: controller.streamChats(argument["chat_id"]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var alldata = snapshot.data!.docs;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                                // 리스트뷰의 스크롤 방향을 반대로 변경. 최신 메시지가 하단에 추가
                                reverse: true,
                                controller: controller.scrollC,
                                itemCount: alldata.length,
                                itemBuilder: (context, index) {
                                  // if (alldata[index]["groupTime"] ==
                                  //     alldata[index - 1]["groupTime"]) {
                                  //   return ChatMessage(
                                  //     msg: "${alldata[index]["msg"]}",
                                  //     isSender: alldata[index]["sender"] ==
                                  //             authC.user.value.email!
                                  //         ? true
                                  //         : false,
                                  //     time: "${alldata[index]["time"]}",
                                  //   );
                                  // } else {
                                  return Column(
                                    children: [
                                      // fontS("${alldata[index]["groupTime"]}",
                                      //     fonts: "NeoM"),
                                      ChatMessage(
                                        msg: "${alldata[index]["msg"]}",
                                        isSender: alldata[index]["sender"] ==
                                                authC.user.value.email!
                                            ? true
                                            : false,
                                        time: "${alldata[index]["time"]}",
                                      ),
                                    ],
                                  );
                                  //}
                                }),
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: Get.height * 0.025)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/pickture-btn.png"),
                  Padding(padding: EdgeInsets.only(right: Get.width * 0.02)),
                  Container(
                    width: Get.width * 0.85,
                    //height: Get.height * 0.08,
                    child: TextField(
                      //포커스 주기!
                      autocorrect: false,
                      controller: controller.chatC,
                      focusNode: controller.focusNode,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffd6d3d3), width: 1),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffd6d3d3), width: 1),
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          suffixIcon: InkWell(
                            child: Image.asset("assets/chat-icon.png"),
                            onTap: () {
                              controller.createChat(
                                authC.user.value.email!,
                                Get.arguments as Map<String, dynamic>,
                                controller.chatC.text,
                              );
                            },
                          ),
                          // filled: true,
                          contentPadding: EdgeInsets.all(15),
                          hintStyle: TextStyle(
                              color: Colors.grey[500], fontFamily: "NeoL"),
                          hintText: "",
                          fillColor: Colors.white70),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
