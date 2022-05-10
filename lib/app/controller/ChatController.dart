import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as IMG;

class ChatController extends GetxController {
  var isLoading = false.obs;
  static ChatController get to => Get.find();
  late TextEditingController chatC;
  late FocusNode focusNode;
  late ScrollController scrollC;
  var imgUrl = "".obs;

  void setIsLoading() {
    isLoading(!isLoading.value);
    print(isLoading.value);
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  //채팅 실시간(바뀔떄마다)
  streamChats(String chat_id) {
    CollectionReference chats = firestore.collection("chats");
    return (chats.doc(chat_id).snapshots());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream(String email) {
    return firestore
        .collection("users")
        .doc(email)
        .collection("chats")
        .snapshots();
  }

  void streamChatsAll(String email) async {
    var mychat = await firestore
        .collection('chats')
        .where('connections', isEqualTo: email)
        .get();
  }

  Future streamLastChatsSum(String email) async {
    print("streamLastChatsSum");

    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    var chatList = await users
        .doc(email)
        .collection("chats")
        .where("create_status", isEqualTo: true)
        .get();
    num chatResultSum = 0;
    await Future.wait(chatList.docs.map((chat) async {
      var chatResult = await chats.doc(chat.id).get();
      var result =
          await users.doc(email).collection("chats").doc(chat.id).get();
      chatResultSum += chatResult['chat'].length - result['read_index'];
    }));
    return chatResultSum;
  }

  Future streamLastChats(String email) async {
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    var chatLastList = [];
    var chatList = await users
        .doc(email)
        .collection("chats")
        .where("create_status", isEqualTo: true)
        .where("isgetout", isEqualTo: false)
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
        "chatId": chat.id,
        "email": user[0].email,
        "name": user[0].name,
        "prvPhotoUrl": user[0].prvPhotoUrl,
        "photoUrl": user[0].photoUrl,
        "backgroundImgUrl": user[0].backgroundImgUrl,
        "img": lastChatList["img"],
        "prvImg": lastChatList["prvImg"],
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

  getOutChat(String email, Map argument) async {
    print("getOutChat");
    CollectionReference users = firestore.collection("users");
    DateTime date = (DateTime.now().toUtc().add(const Duration(hours: 9)));
    await users.doc(email).collection("chats").doc(argument["chat_id"]).update({
      "chatEndTime": date.toString(),
    });
  }

  //채팅 create
  createChat(String email, Map<String, dynamic> argument,
      {msg = "", img = "", prvImg = ""}) async {
    print("argument");
    print(argument);
    List imageList = [];
    imageList.add(img);
    imageList.add(prvImg);

    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");
    DateTime date = (DateTime.now().toUtc().add(const Duration(hours: 9)));
// / 파일 업로드 완료까지 대기
//     await storageUploadTask.onComplete;
    if (img != "" && prvImg != "") {
      isLoading(true);
      var imagesUrls = await Future.wait(imageList.map((_image) async {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child("post/${DateTime.now().millisecondsSinceEpoch}");
        final uploadTask = await storageReference.putFile(_image!);
        String photoUrl = await storageReference.getDownloadURL();
        return photoUrl;
      }));

      await chats.doc(argument["chat_id"]).update({
        "chat": FieldValue.arrayUnion([
          {
            "sender": email,
            "recipient": argument["friendEmail"],
            "img": imagesUrls[0],
            "prvImg": imagesUrls[1],
            "time": date.toString(),
            "groupTime": DateFormat('yy년 MM월 dd일')
                .format(DateTime.parse(date.toString()))
          }
        ])
      });
      isLoading(false);
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
      "read_index": chatMap['chat'].length,
      "isgetout": false,
    });

    //마지막 채팅시간 업데이트(상대방)
    var friendData = await users
        .doc(argument["friendData"].email.toString())
        .collection("chats")
        .doc(argument["chat_id"])
        .get();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    bool isRecipient = false;
    if (friendData.data()?["chatStartTime"] != null &&
        friendData.data()?["chatEndTime"] != null) {
      if (friendData.data()?["chatStartTime"] != null &&
          friendData.data()?["chatEndTime"] == null) {
        isRecipient = true;
      } else {
        if (dateFormat
                .parse(friendData.data()?["chatStartTime"])
                .difference(dateFormat.parse(friendData.data()?["chatEndTime"]))
                .inSeconds >
            0) {
          isRecipient = true;
        }
      }
    }

    bool isChatRoom = false;
    final chatRoom =
        await users.doc(argument["friendData"].email).collection("chats").get();
    //채팅방 존재 유무
    chatRoom.docs.forEach((chat) {
      if (argument["chat_id"] == chat.id) isChatRoom = true;
    });
    if (isChatRoom) {
      //채팅방 존재
      await users
          .doc(argument["friendData"].email)
          .collection("chats")
          .doc(argument["chat_id"])
          .update(isRecipient
              ? {
                  "lastTime": date.toString(),
                  "create_status": true,
                  "read_index": chatMap['chat'].length,
                  "isgetout": false,
                }
              : {
                  "lastTime": date.toString(),
                  "create_status": true,
                  "isgetout": false,
                });
    } else {
      //채팅방 존재하지않음
      await users
          .doc(argument["friendData"].email)
          .collection("chats")
          .doc(argument["chat_id"])
          .set({
        "connection": email,
        "lastTime": date,
        "create_status": true,
        "read_index": 0,
        "isgetout": false,
      });
    }
  }

  chatImage(email, option, arguments) async {
    var argument = arguments as Map<String, dynamic>;
    final _image;
    final _prvImage;

    final picker = ImagePicker();
    var pickedFile;
    var prvPickedFile;
    if (option == "gallery") {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 100);
    }
    if (option == "camera") {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 100);
    }

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      final _prvImagebytes = await _image.readAsBytes();
      IMG.Image? _prvImageDecode = IMG.decodeImage(_prvImagebytes);
      IMG.Image _prvImageResize = IMG.copyResize(_prvImageDecode!, width: 200);

      final jpg = IMG.encodeJpg(_prvImageResize);
      File _prvImage = File(pickedFile.path.split("jpg")[0] + "prv.jpg");
      _prvImage.writeAsBytes(jpg);

      await createChat(
        email,
        argument,
        img: _image,
        prvImg: _prvImage,
      );

      // Get.toNamed(
      //   Routes.IMGPREVIEW,
      //   arguments: {
      //     "img": _image,
      //     "prvImg": _prvImage,
      //     "chat_id": argument["chat_id"],
      //     "friendEmail": argument["friendEmail"],
      //     "friendName": argument["friendName"]
      //   },
      // );
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
