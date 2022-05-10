import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatting_app/app/data/model/user_model.dart';
import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image/image.dart' as IMG;

class AuthController extends GetxController {
  var height = Get.height.obs;
  var width = Get.width.obs;
  void init(context) {
    height(height.value -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom);
  }

  static AuthController get to => Get.find();
  var isSkipIntro = true.obs; // intro 보여줄시 false
  var isAutoLogin = false.obs;
  late TextEditingController textC = TextEditingController();
  // ignore: prefer_final_fields, unused_field
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = UsersModel().obs;
  var recommendUserList = [].obs;
  Future firstInitialized() async {
    print("로딩중...");
    final box = GetStorage();
    if (box.read('skipIntro') == true) {
      isSkipIntro(true);
    }
    if (box.read('loginStatus') != null) {
      autoLogin();
      isAutoLogin(true);
    }
  }

  //자동로그인
  Future autoLogin() async {
    final box = GetStorage();
    var email = box.read('loginStatus');
    CollectionReference users = firestore.collection('users');
    // user 정보 얻어오기 ()
    await getUser(users, email);
    await userFollowJoin(email);
    await getListChat();
    await getRecommendUser();
  }

  //그냥 로그인
  Future login() async {
    final currentUser = await googleFirebaseSign();
    //로그인시 skip
    final box = GetStorage();
    box.write('skipIntro', true);
    CollectionReference users = firestore.collection('users');
    final checkuser = await users.doc(currentUser!.user.email).get();
    DateTime date = await (DateTime.now().toUtc().add(Duration(hours: 9)));
    //이메일 storage에 존재하지 않으면
    if (checkuser.data() == null) {
      await users.doc(currentUser!.user.email).set({
        "uid": currentUser!.user!.uid,
        "name": currentUser!.user.displayName,
        "email": currentUser!.user.email,
        "photoUrl": currentUser!.user.photoURL ?? "noimage",
        "prvPhotoUrl": currentUser!.user.photoURL ?? "noimage",
        "status": "",
        "creationTime": date.toString(),
        "lastSignInTime": date.toString(),
        "updatedTime": DateTime.now().toIso8601String(),
      });
    }
    //이메일 storage에 존재하면 (로그인후 로그아웃한 경우)
    else {
      await users
          .doc(currentUser!.user.email)
          .update({"lastSignInTime": date.toString()});
    }
    // user 정보 얻어오기
    await getUser(users, currentUser!.user.email);
    await userFollowJoin(currentUser!.user.email);
    await getListChat();
    await getRecommendUser();
    box.write('loginStatus', currentUser!.user.email);

    Get.offAllNamed(Routes.Nav);
  }

  Future getUser(users, email) async {
    final currUser = await users.doc(email).get();
    final currUserData = currUser.data() as Map<String, dynamic>;
    user(UsersModel.fromJson(currUserData));
    user.refresh();
  }

  Future googleFirebaseSign() async {
    await _googleSignIn.signOut();
    // signInSilently 창 안띄우고 login // signIn 창띄우고 로그인
    final currentUser = await _googleSignIn.signIn();
    final googleAuth = await currentUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    //firebase login
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential;
  }

  //로그아웃
  Future<void> logout() async {
    final box = GetStorage();
    //  await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    box.write('loginStatus', null);
    Get.offAllNamed(Routes.LOGIN);
  }

  //회원탈퇴
  Future<void> withdrawal(email) async {
    CollectionReference users = firestore.collection('users');
    CollectionReference chats = firestore.collection('chats');

    var userList = await users.get();
    await Future.wait(userList.docs.map((user) async {
      var userFollowList = await users.doc(user.id).collection("follow").get();
      await Future.wait(userFollowList.docs.map((follow) async {
        if (follow.id == email) {
          await users.doc(user.id).collection("follow").doc(follow.id).delete();
        }
      }));

      var userChatList = await users.doc(user.id).collection("chats").get();
      var chatId = null;
      await Future.wait(userChatList.docs.map((chat) async {
        if (chat.data()["connection"] == email) {
          await users.doc(user.id).collection("chats").doc(chat.id).delete();
          chatId = chat.id;
        }
      }));

      chatId ?? await chats.doc(chatId).delete();
    }));

    final box = GetStorage();
    await _googleSignIn.signOut();
    box.write('loginStatus', null);
    Get.offAllNamed(Routes.LOGIN);

    final calenderList = await users.doc(email).collection("calender").get();
    final chatsList = await users.doc(email).collection("chats").get();
    final followList = await users.doc(email).collection("follow").get();
    await Future.wait(calenderList.docs.map((calender) async {
      await users.doc(email).collection("calender").doc(calender.id).delete();
    }));
    await Future.wait(chatsList.docs.map((chats) async {
      await users.doc(email).collection("chats").doc(chats.id).delete();
    }));
    await Future.wait(followList.docs.map((follow) async {
      await users.doc(email).collection("follow").doc(follow.id).delete();
    }));
    await users.doc(email).delete();
    print("탈퇴완료");
  }

  Future<void> createfollowUser(frendEmail) async {
    String? email = user.value.email;
    CollectionReference users = firestore.collection('users');
    await users.doc(email).collection("follow").doc(frendEmail).set({
      "lastTime": 000,
    });
    await users.doc(frendEmail).collection("follow").doc(email).set({
      "lastTime": 000,
    });

    await userFollowJoin(email);
    await getRecommendUser();
    Get.back();
  }

  Future<void> createUnfollowUser(frendEmail) async {
    print(frendEmail);
    String? email = user.value.email;
    CollectionReference users = firestore.collection('users');
    await users.doc(email).collection("unfollow").doc(frendEmail).set({
      "lastTime": 000,
    });
    await users.doc(email).collection("follow").doc(frendEmail).delete();
    // await userFollowJoin(email);
    // await getRecommendUser();
    // Get.back();
  }

  Future getUserData(email) async {
    CollectionReference users = firestore.collection('users');
    final result = await users.doc(email).collection("chats").get();
    return result;
  }

  //FOLLOW
  Future userFollowJoin(email) async {
    var usersData = [];
    CollectionReference users = firestore.collection('users');
    final followList = await users.doc(email).collection("follow").get();
    var emailList = [];
    for (var list in followList.docs) {
      emailList.add(list.id);
    }

    usersData = await firebaseUserJoin(emailList);

    user.update((user) {
      user!.followUser = usersData;
    });
    user.refresh();
  }

  //유저이메일과 유저정보 조인
  Future firebaseUserJoin(emailList) async {
    CollectionReference users = firestore.collection('users');
    final userList = await users.get();
    var usersData = [];
    userList.docs.forEach((user) {
      emailList.forEach((email) {
        if (user.id == email) {
          final userMap = user.data() as Map<String, dynamic>;
          usersData.add(UsersModel.fromJson(userMap));
        }
      });
    });

    return usersData;
  }

  Future getListChat() async {
    CollectionReference users = firestore.collection("users");
    final listChats =
        await users.doc(user.value.email).collection("chats").get();
    if (listChats.docs.length != 0) {
      List<ChatUser> dataListChats = [];
      listChats.docs.forEach((element) {
        var dataDocChat = element.data();
        var dataDocChatId = element.id;
        dataListChats.add(ChatUser(
          chatId: dataDocChatId,
          connection: dataDocChat["connection"],
          lastTime: dataDocChat["lastTime"].toString(),
        ));
      });

      user.update((user) {
        user!.chats = dataListChats;
      });
    } else {
      user.update((user) {
        user!.chats = [];
      });
    }
  }

  createFirebaseChatRoom(friendData) async {
    DateTime date = (DateTime.now().toUtc().add(const Duration(hours: 9)));
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final checkConnection = await users
        .doc(user.value.email)
        .collection("chats")
        .where("connection", isEqualTo: friendData.email)
        .get();

    // 채팅방이 존재하지 않는다면?!
    if (checkConnection.docs.length == 0) {
      print("채팅방존재 않음");
      // user - chats 와 chats 생성!
      final newChatDoc = await chats.add({
        "connections": [
          user.value.email,
          friendData.email,
        ],
      });

      await users
          .doc(user.value.email)
          .collection("chats")
          .doc(newChatDoc.id)
          .set({
        "isgetout": false,
        "getoutIndex": 0,
        "chatStartTime": date.toString(),
        "connection": friendData.email,
        "lastTime": date,
        "create_status": false,
        "read_index": 0
      });

      Get.toNamed(
        Routes.CHATROOM,
        arguments: {
          "chat_id": "${newChatDoc.id}",
          "friendData": friendData,
        },
      );
    }
    //채팅방이 존재한다면
    else {
      print("채팅방존재");
      await getListChat();
      var _chatid;
      checkConnection.docs.forEach((e) => {_chatid = e.id});
      var chatList = await chats.doc(_chatid).get();
      var chatMap = chatList.data() as Map;

      await users
          .doc(user.value.email)
          .collection("chats")
          .doc(_chatid)
          .update({
        "read_index": chatMap['chat']?.length,
        "chatStartTime": date.toString(),
      });

      Get.toNamed(
        Routes.CHATROOM,
        arguments: {
          "chat_id": _chatid,
          "friendData": friendData,
        },
      );
    }
  }

  getOutOfIndex(chatId) async {
    print("getOutOfIndex");
    print(chatId);
    CollectionReference users = firestore.collection("users");
    var result =
        await users.doc(user.value.email).collection("chats").doc(chatId).get();
    var resultMap = result.data() as Map<dynamic, dynamic>;
    return resultMap["getoutIndex"] == null ? 0 : resultMap["getoutIndex"];
  }

  userChatDelete(chatId) async {
    print(chatId);
    CollectionReference users = firestore.collection("users");
    CollectionReference chats = firestore.collection("chats");
    var chatData = await users.doc(user.value.email).collection("chats").get();
    var chatLength = chatData.docs[0].data()["read_index"];
    print(chatLength);
    await users.doc(user.value.email).collection("chats").doc(chatId).update({
      "isgetout": true,
      "getoutIndex": chatLength,
    });
  }

  profileStatusUpdate(text) async {
    await firestore
        .collection("users")
        .doc(user.value.email)
        .update({"status": text});
    user.update((user) {
      user!.status = text;
    });
    user.refresh();
    Get.back();
  }

  profileImageUpdate(option, background) async {
    File _image;
    final picker = ImagePicker();
    PickedFile? pickedFile;
    if (option == "gallery") {
      pickedFile =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 80);
    }
    if (option == "camera") {
      pickedFile =
          await picker.getImage(source: ImageSource.camera, imageQuality: 80);
    }

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      final _prvImagebytes = await _image.readAsBytes();
      IMG.Image? _prvImageDecode = IMG.decodeImage(_prvImagebytes);
      IMG.Image _prvImageResize = IMG.copyResize(_prvImageDecode!, width: 50);

      final jpg = IMG.encodeJpg(_prvImageResize);
      File _prvImage = File(pickedFile.path.split("jpg")[0] + "prv.jpg");
      _prvImage.writeAsBytes(jpg);
      List imageList = [];
      imageList.add(_image);
      imageList.add(_prvImage);

      if (_image != null) {
        var imagesUrls = await Future.wait(imageList.map((_image) async {
          final storageReference = FirebaseStorage.instance
              .ref()
              .child("post/${DateTime.now().millisecondsSinceEpoch}");
          final uploadTask = storageReference.putFile(_image!);
          String photoUrl = await (await uploadTask).ref.getDownloadURL();
          return photoUrl;
        }));

        if (background) {
          await firestore
              .collection("users")
              .doc(user.value.email)
              .update({"backgroundImgUrl": imagesUrls[0]});
          user.update((user) {
            user!.backgroundImgUrl = imagesUrls[0];
          });
        } else {
          await firestore.collection("users").doc(user.value.email).update(
              {"photoUrl": imagesUrls[0], "prvPhotoUrl": imagesUrls[1]});
          user.update((user) {
            user!.photoUrl = imagesUrls[0];
            user.prvPhotoUrl = imagesUrls[1];
          });
        }

        user.refresh();
      }
    }
  }

//나와 나의 follow에 있는사람을 제외한 20명 추천!
  getRecommendUser() async {
    recommendUserList([]);
    var userList = await firestore
        .collection("users")
        .orderBy("creationTime", descending: true)
        .limit(20)
        .get();
    var follows = user.value.followUser;

    var result = false;
    userList.docs.forEach((data) {
      result = false;
      final userMap = data.data() as Map<String, dynamic>;
      // 본인 이메일 제외
      if (userMap["email"] == user.value.email) {
        result = true;
      }
      // 본인 팔로우 목록 제외
      for (int i = 0; i < follows!.length; i++) {
        if (userMap["email"] == follows[i].email) {
          result = true;
        }
      }

      if (!result) {
        recommendUserList.add(UsersModel.fromJson(userMap));
      }
    });
    recommendUserList.refresh();
  }

  @override
  void onInit() async {
    textC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    textC.dispose();
    super.onClose();
  }
}
