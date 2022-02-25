import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/ChatController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends GetView<ChatController> {
  final authC = AuthController.to;
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
          padding: EdgeInsets.only(
              left: Get.width * 0.045,
              right: Get.width * 0.045,
              top: Get.height * 0.015),
          child: Container(
            height: Get.height * 0.81,
            width: Get.width,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.chatsStream(authC.user.value.email.toString()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return FutureBuilder(
                        future: controller
                            .streamLastChats(authC.user.value.email.toString()),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
                          if (snapshot.hasData == false) {
                            return Center(child: Text("3"));
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
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.only(top: Get.height * 0.01),
                                    child: InkWell(
                                      onTap: () {
                                        authC.createFirebaseChatRoom(
                                          snapshot.data[index]["friendEmail"],
                                          snapshot.data[index]["friendName"],
                                        );
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: Get.width * 0.65,
                                            child: Row(
                                              children: [
                                                profileImage(Get.width * 0.15,
                                                    image:
                                                        "${snapshot.data[index]["friendPhotoUrl"] ?? "https://w.namu.la/s/c4b8eb1c9ea25c0e252b81e3aab503097fdd7a7ae00acdba6f86da4e46ad5e3629335e1022104c01db12954074159679a427e9d4f2e0519db064e4203dec3dc04fdbf124789ea8400b3e6793f77a221e"}"),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            Get.width * 0.03)),
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      fontS(
                                                          "${snapshot.data[index]["friendName"]}",
                                                          color: 0xff000000,
                                                          fonts: "NeoB"),
                                                      Padding(
                                                          padding: EdgeInsets.only(
                                                              top: Get.height *
                                                                  0.002)),
                                                      fontS(
                                                          "${snapshot.data[index]["msg"]}",
                                                          color: 0xff707070),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              fontS(
                                                "${snapshot.data[index]["time"]}",
                                                color: 0xff9a9a9a,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: Get.height * 0.002)),
                                              snapshot.data[index]["un_read"] ==
                                                      0
                                                  ? Text(" ")
                                                  : Container(
                                                      child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 6,
                                                                  right: 6,
                                                                  bottom: 3,
                                                                  top: 1),
                                                          child: fontSM(
                                                              "${snapshot.data[index]["un_read"]}",
                                                              color:
                                                                  0xffffffff)),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffff2057),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          //모서리를 둥글게
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffff2057),
                                                              width: 1))),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  //}
                                });
                          }
                        });
                  }
                } else {
                  return Center(child: Text("1"));
                }
                return Center(child: Text("2"));
              },
            ),
          ),
        ),
      ),
    );
  }
}
