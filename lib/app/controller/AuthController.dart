import 'dart:io';
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
  // ignore: prefer_final_fields, unused_field
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var user = UsersModel().obs;

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
    return true;
  }

  //그냥 로그인
  Future login() async {
    final currentUser = await googleFirebaseSign();
    //로그인시 skip
    final box = GetStorage();
    box.write('skipIntro', true);
    CollectionReference users = firestore.collection('users');
    final checkuser = await users.doc(currentUser!.user.email).get();
    print(currentUser!.user.photoURL);
    //이메일 storage에 존재하지 않으면
    if (checkuser.data() == null) {
      await users.doc(currentUser!.user.email).set({
        "uid": currentUser!.user!.uid,
        "name": currentUser!.user.displayName,
        "email": currentUser!.user.email,
        "photoUrl": currentUser!.user.photoURL ?? "noimage",
        "status": "",
        "creationTime":
            currentUser!.user!.metadata.creationTime!.toIso8601String(),
        "lastSignInTime":
            currentUser!.user!.metadata.lastSignInTime!.toIso8601String(),
        "updatedTime": DateTime.now().toIso8601String(),
      });
    }
    //이메일 storage에 존재하면 (로그인후 로그아웃한 경우)
    else {
      await users.doc(currentUser!.user.email).update({
        "lastSignInTime":
            currentUser!.user!.metadata.lastSignInTime!.toIso8601String(),
      });
    }
    // user 정보 얻어오기
    await getUser(users, currentUser!.user.email);
    await userFollowJoin(currentUser!.user.email);
    await getListChat();
    box.write('loginStatus', currentUser!.user.email);
    Get.offAllNamed(Routes.Nav);
  }

  Future getUser(users, email) async {
    final currUser = await users.doc(email).get();
    final currUserData = currUser.data() as Map<String, dynamic>;
    print(currUserData);
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
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    box.write('loginStatus', null);
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> createfollowUser(email, frendEmail) async {
    CollectionReference users = firestore.collection('users');
    await users.doc(email).collection("follow").doc(frendEmail).set({
      "lastTime": 000,
    });
    await users.doc(frendEmail).collection("follow").doc(email).set({
      "lastTime": 000,
    });
    await userFollowJoin(email);
    Get.back();
  }

  //FOLLOW
  Future userFollowJoin(email) async {
    var usersData = [];
    CollectionReference users = firestore.collection('users');
    final followList = await users.doc(email).collection("follow").get();
    var emailList = [];
    followList.docs.forEach((list) {
      emailList.add(list.id);
    });

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
          lastTime: dataDocChat["lastTime"],
          total_unread: dataDocChat["total_unread"],
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
      final updateStatusChat = await chats
          .doc(_chatid)
          .collection("chat")
          .where("isRead", isEqualTo: false)
          .where("recipient", isEqualTo: user.value.email)
          .get();

      updateStatusChat.docs.forEach((element) async {
        await chats
            .doc(_chatid)
            .collection("chat")
            .doc(element.id)
            .update({"isRead": true});
      });
      await users
          .doc(user.value.email)
          .collection("chats")
          .doc(_chatid)
          .update({
        "lastTime": date.toString(),
        "create_status": true,
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
}
