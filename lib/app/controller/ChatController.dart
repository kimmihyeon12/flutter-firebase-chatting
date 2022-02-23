import 'dart:async';

import 'package:chatting_app/app/views/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();
  late TextEditingController chatC;
  late FocusNode focusNode;
  late ScrollController scrollC;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //채팅 실시간(바뀔떄마다) get

  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chat_id) {
    CollectionReference chats = firestore.collection("chats");
    var chat;
    try {
      chat = chats
          .doc(chat_id)
          .collection("chat")
          .orderBy("time", descending: true)
          .limit(100) //100개 채팅 제한
          .snapshots();
      print(chat);
    } catch (e) {
      print("strem chat error ");
      chat = null;
    }
    return chat;
  }

  void streamChatsAll(String email) async {
    var mychat = await firestore
        .collection('chats')
        .where('connections', isEqualTo: email)
        .get();
    mychat.docs.forEach((data) {
      print(data.id);
    });
  }

  //채팅 create
  createChat(String email, Map<String, dynamic> argument, String chat) async {
    print(argument);
    if (chat != "") {
      CollectionReference chats = firestore.collection("chats");
      CollectionReference users = firestore.collection("users");
      DateTime date = (await NTP.now());

      await chats.doc(argument["chat_id"]).collection("chat").add({
        "sender": email,
        "recipient": argument["friendEmail"],
        "msg": chat,
        "time": date.toString(),
        "isRead": false,
        "groupTime":
            DateFormat('yy년 MM월 dd일').format(DateTime.parse(date.toString())),
        // "groupTime": DateFormat.yMMMMd('en_US').format(DateTime.parse(date)),
      });

      // clear
      chatC.clear();
      //마지막 채팅시간 업데이트(나)
      await users
          .doc(email)
          .collection("chats")
          .doc(argument["chat_id"])
          .update({
        "lastTime": date.toString(),
      });
      //마지막 채팅시간 업데이트(상대방)
      try {
        await users
            .doc(argument["friendEmail"])
            .collection("chats")
            .doc(argument["chat_id"])
            .update({
          "lastTime": date.toString(),
        });
      } catch (e) {
        await users
            .doc(argument["friendEmail"])
            .collection("chats")
            .doc(argument["chat_id"])
            .set({
          "connection": email,
          "lastTime": date,
          "total_unread": 0,
        });
      }
    }
  }

  @override
  void onInit() {
    chatC = TextEditingController();
    scrollC = ScrollController();
    focusNode = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    chatC.dispose();
    super.onClose();
  }
}
