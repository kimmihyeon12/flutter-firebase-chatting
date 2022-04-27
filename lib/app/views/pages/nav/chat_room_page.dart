import 'dart:async';

import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/ChatController.dart';
import 'package:chatting_app/app/views/widgets/bottomSheet.dart';
import 'package:chatting_app/app/views/widgets/chat_message.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
                Image.asset("assets/chat-bg.png",
                    width: authC.width.value,
                    height: authC.height * 0.812,
                    fit: BoxFit.fill),
                Container(
                  height: authC.height * 0.81,
                  width: Get.width,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: controller.streamChats(argument["chat_id"]),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasData) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          var alldata;
                          try {
                            alldata = snapshot.data?['chat'];
                            Timer(
                              Duration.zero,
                              () => controller.scrollC.jumpTo(
                                  controller.scrollC.position.maxScrollExtent),
                            );
                          } catch (e) {
                            alldata = null;
                          }

                          print('alldata $alldata');
                          var groupTime = "";

                          return alldata != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ListView.builder(
                                      // 리스트뷰의 스크롤 방향을 반대로 변경. 최신 메시지가 하단에 추가
                                      // reverse: true,
                                      controller: controller.scrollC,
                                      itemCount: alldata.length,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            (() {
                                              bool result = false;
                                              if (groupTime !=
                                                  alldata[index]["groupTime"]) {
                                                result = true;
                                                groupTime =
                                                    alldata[index]["groupTime"];
                                              }
                                              return result
                                                  ? Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical:
                                                                  authC.height *
                                                                      0.01),
                                                      child: fontS(
                                                          "${alldata[index]["groupTime"]}"),
                                                    )
                                                  : Container();
                                            })(),
                                            ChatMessage(
                                              img: "${alldata[index]["img"]}",
                                              msg: "${alldata[index]["msg"]}",
                                              isSender: alldata[index]
                                                          ["sender"] ==
                                                      authC.user.value.email!
                                                  ? true
                                                  : false,
                                              time: "${alldata[index]["time"]}",
                                            ),
                                          ],
                                        );
                                      }),
                                )
                              : Container();
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
            Padding(padding: EdgeInsets.only(top: authC.height * 0.025)),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: () async {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext bc) {
                              return SafeArea(
                                child: Container(
                                  child: Wrap(
                                    children: <Widget>[
                                      ListTile(
                                          leading: Icon(
                                            Icons.photo_library,
                                            color: Colors.grey,
                                          ),
                                          title: fontS('갤러리'),
                                          onTap: () async {
                                            controller.chatImage(
                                                "gallery", argument);
                                            Navigator.of(context).pop();
                                          }),
                                      ListTile(
                                          leading: Icon(
                                            Icons.photo_camera,
                                            color: Colors.grey,
                                          ),
                                          title: fontS('카메라'),
                                          onTap: () async {
                                            controller.chatImage(
                                                "camera", argument);
                                            Navigator.of(context).pop();
                                          }),
                                      ListTile(
                                        leading: new Icon(
                                          Icons.delete_rounded,
                                          color: Colors.grey,
                                        ),
                                        title: fontS('삭제'),
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: Image.asset("assets/pickture-btn.png")),
                  Padding(padding: EdgeInsets.only(right: authC.width * 0.02)),
                  Container(
                    width: authC.width * 0.85,
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
                                msg: controller.chatC.text,
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
