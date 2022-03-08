import 'dart:async';
import 'dart:io';
import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  static ChatController get to => Get.find();
  late TextEditingController chatC;
  late FocusNode focusNode;
  late ScrollController scrollC;
  var imgUrl = "".obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //채팅 실시간(바뀔떄마다)
  streamChats(String chat_id) {
    CollectionReference chats = firestore.collection("chats");
    return chats.doc(chat_id).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return firestore.collection('chats').snapshots();
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
      var chatResult = await chats.doc(chat.id).get();
      var chatList = chatResult['chat'];
      var lastChatList = chatList[chatList.length - 1];
      var msgTime = lastChatList["time"].toString().substring(0, 10).split("-");

      var currentTime = DateTime.now();
      var pretime = DateTime(
          int.parse(msgTime[0]), int.parse(msgTime[1]), int.parse(msgTime[2]));

      var result =
          await users.doc(email).collection("chats").doc(chat.id).get();

      var time;
      if (currentTime.difference(pretime).inDays == 0) {
        time = lastChatList["time"].toString().substring(11, 16);
      } else if (currentTime.difference(pretime).inDays == 1) {
        time = "어제";
      } else {
        time = lastChatList["time"].toString().substring(0, 10);
      }

      chatLastList.add({
        "friendEmail": user[0].email,
        "friendName": user[0].name,
        "friendPhotoUrl": user[0].photoUrl,
        "img": lastChatList["img"],
        "msg": lastChatList["msg"],
        "time": time.toString(),
        "datetime": DateTime.parse(lastChatList["time"]),
        "read_index": chatResult['chat'].length - result['read_index']
      });
    }));

    chatLastList.sort((a, b) {
      return b["datetime"].difference(a["datetime"]).inSeconds;
    });

    return chatLastList;
  }

  //채팅 create
  createChat(String email, Map<String, dynamic> argument,
      {msg = "", img = ""}) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    DateTime date = (DateTime.now().toUtc().add(const Duration(hours: 9)));

    if (img != "") {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child("post/${DateTime.now().millisecondsSinceEpoch}");
      var storageUploadTask = await storageReference.putFile(img!);
      String photoUrl = await storageReference.getDownloadURL();
      await chats.doc(argument["chat_id"]).update({
        "chat": FieldValue.arrayUnion([
          {
            "sender": email,
            "recipient": argument["friendEmail"],
            "img": photoUrl,
            "time": date.toString(),
            "groupTime": DateFormat('yy년 MM월 dd일')
                .format(DateTime.parse(date.toString()))
          }
        ])
      });
    }
    if (msg != "") {
      await chats.doc(argument["chat_id"]).update({
        "chat": FieldValue.arrayUnion([
          {
            "sender": email,
            "recipient": argument["friendEmail"],
            "msg": msg,
            "time": date.toString(),
            "groupTime": DateFormat('yy년 MM월 dd일')
                .format(DateTime.parse(date.toString()))
          }
        ])
      });
    }
    var chatList = await chats.doc(argument["chat_id"]).get();
    var chatMap = chatList.data() as Map;

    chatC.clear();
    //마지막 채팅시간 업데이트(나)
    await users.doc(email).collection("chats").doc(argument["chat_id"]).update({
      "lastTime": date.toString(),
      "create_status": true,
      "read_index": chatMap['chat'].length
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
        "read_index": 0
      });
    }
  }

  chatImage(option, arguments) async {
    var argument = arguments as Map<String, dynamic>;
    final _image;
    final picker = ImagePicker();
    var pickedFile;
    if (option == "gallery") {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    }
    if (option == "camera") {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 50);
    }

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Get.toNamed(
        Routes.IMGPREVIEW,
        arguments: {
          "img": _image,
          "chat_id": argument["chat_id"],
          "friendEmail": argument["friendEmail"],
          "friendName": argument["friendName"]
        },
      );
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
