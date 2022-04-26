import 'dart:io';
import 'package:chatting_app/app/views/widgets/size.dart';
import 'package:device_info_plus/device_info_plus.dart';
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

class AuthController extends GetxController {
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

  Future<void> logout() async {
    final box = GetStorage();
    //  await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    box.write('loginStatus', null);
    Get.offAllNamed(Routes.LOGIN);
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

  createFirebaseChatRoom(String friendEmail, String friendName) async {
    print("addFirebaseChat");
    DateTime date = await (DateTime.now().toUtc().add(Duration(hours: 9)));
    CollectionReference chats = firestore.collection("chats");
    CollectionReference users = firestore.collection("users");

    final checkConnection = await users
        .doc(user.value.email)
        .collection("chats")
        .where("connection", isEqualTo: friendEmail)
        .get();

    // 채팅방이 존재하지 않는다면?!
    if (checkConnection.docs.length == 0) {
      // user - chats 와 chats 생성!
      final newChatDoc = await chats.add({
        "connections": [
          user.value.email,
          friendEmail,
        ],
      });

      await users
          .doc(user.value.email)
          .collection("chats")
          .doc(newChatDoc.id)
          .set({
        "connection": friendEmail,
        "lastTime": date,
        "create_status": false,
        "read_index": 0
      });

      Get.toNamed(
        Routes.CHATROOM,
        arguments: {
          "chat_id": "${newChatDoc.id}",
          "friendEmail": friendEmail,
          "friendName": friendName
        },
      );
    }
    //채팅방이 존재한다면
    else {
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
        "read_index": chatMap['chat'].length,
      });

      Get.toNamed(
        Routes.CHATROOM,
        arguments: {
          "chat_id": _chatid,
          "friendEmail": friendEmail,
          "friendName": friendName
        },
      );
    }
  }

  profileStatusUpdate(text) async {
    print(text);
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
      if (_image != null) {
        final storageReference = FirebaseStorage.instance
            .ref()
            .child("post/${DateTime.now().millisecondsSinceEpoch}");
        var storageUploadTask = await storageReference.putFile(_image!);
        String photoUrl = await storageReference.getDownloadURL();
        if (background) {
          await firestore
              .collection("users")
              .doc(user.value.email)
              .update({"backgroundImgUrl": photoUrl});
          user.update((user) {
            user!.backgroundImgUrl = photoUrl;
          });
        } else {
          await firestore
              .collection("users")
              .doc(user.value.email)
              .update({"photoUrl": photoUrl});
          user.update((user) {
            user!.photoUrl = photoUrl;
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
      for (int i = 0; i < follows!.length; i++) {
        if (userMap["email"] == user.value.email ||
            userMap["email"] == follows[i].email) {
          result = true;
        }
      }
      if (!result) {
        recommendUserList.add(UsersModel.fromJson(userMap));
      }
    });
    recommendUserList.refresh();
    print('recommendUserList.length ${recommendUserList.length}');
  }

  @override
  void onInit() async {
    textC = TextEditingController();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo}');
    if (androidInfo == "AndroidDeviceInfo") {
      Size().setHeight(Get.height);
    }
    super.onInit();
  }

  @override
  void onClose() {
    textC.dispose();
    super.onClose();
  }
}
