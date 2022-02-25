import 'dart:async';

import 'package:chatting_app/app/controller/AuthController.dart';
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
  //채팅 실시간(바뀔떄마다)
  Stream<QuerySnapshot<Map<String, dynamic>>> streamChats(String chat_id) {
    CollectionReference chats = firestore.collection("chats");
    var chat;
    chat = chats
        .doc(chat_id)
        .collection("chat")
        .orderBy("time", descending: false)
        .limit(100) //100개 채팅 제한
        .snapshots();
    return chat;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return firestore
        .collection('users')
        .doc(email)
        .collection("chats")
        .orderBy("lastTime", descending: true)
        .snapshots();
  }

  void streamChatsAll(String email) async {
    var mychat = await firestore
        .collection('chats')
        .where('connections', isEqualTo: email)
        .get();
  }

  Future streamLastChats(String email) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    var chatLastList = [];
    var chatList = await users
        .doc(email)
        .collection("chats")
        .where("create_status", isEqualTo: true)
        .get();

    await Future.wait(chatList.docs.map((chat) async {
      var user =
          await AuthController.to.firebaseUserJoin([chat.data()["connection"]]);
      var lastChat = await chats
          .doc(chat.id)
          .collection("chat")
          .orderBy("time", descending: true)
          .limit(1)
          .get();
      var msgTime = lastChat.docs[0]
          .data()["time"]
          .toString()
          .substring(0, 10)
          .split("-");
      var currentTime = DateTime.now();
      var pretime = DateTime(
          int.parse(msgTime[0]), int.parse(msgTime[1]), int.parse(msgTime[2]));

      final updateStatusChat = await chats
          .doc(chat.id)
          .collection("chat")
          .where("isRead", isEqualTo: false)
          .where("recipient", isEqualTo: email)
          .get();

      var time;
      if (currentTime.difference(pretime).inDays == 0) {
        time = lastChat.docs[0].data()["time"].toString().substring(11, 16);
      } else if (currentTime.difference(pretime).inDays == 1) {
        time = "어제";
      } else {
        time = lastChat.docs[0].data()["time"].toString().substring(0, 10);
      }
      chatLastList.add({
        "friendEmail": user[0].email,
        "friendName": user[0].name,
        "friendPhotoUrl": user[0].photoUrl,
        "msg": lastChat.docs[0].data()["msg"],
        "time": time.toString(),
        "datetime": DateTime.parse(lastChat.docs[0].data()["time"]),
        "chat_id": lastChat.docs[0].id,
        "un_read": updateStatusChat.docs.length
      });
    }));

    chatLastList.sort((a, b) {
      print(a["datetime"].difference(b["datetime"]).inSeconds);
      return b["datetime"].difference(a["datetime"]).inSeconds;
    });

    return chatLastList;
  }

  //채팅 create
  createChat(String email, Map<String, dynamic> argument, String chat) async {
    if (chat != "") {
      CollectionReference chats = firestore.collection("chats");
      CollectionReference users = firestore.collection("users");
      DateTime date = (DateTime.now().toUtc().add(const Duration(hours: 9)));

      await chats.doc(argument["chat_id"]).collection("chat").add({
        "sender": email,
        "recipient": argument["friendEmail"],
        "msg": chat,
        "time": date.toString(),
        "isRead": false,
        "groupTime":
            DateFormat('yy년 MM월 dd일').format(DateTime.parse(date.toString())),
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
        "create_status": true,
      });
      //마지막 채팅시간 업데이트(상대방)
      try {
        await users
            .doc(argument["friendEmail"])
            .collection("chats")
            .doc(argument["chat_id"])
            .update({
          "lastTime": date.toString(),
          "create_status": true,
        });
      } catch (e) {
        await users
            .doc(argument["friendEmail"])
            .collection("chats")
            .doc(argument["chat_id"])
            .set({
          "connection": email,
          "lastTime": date,
          "create_status": true,
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
