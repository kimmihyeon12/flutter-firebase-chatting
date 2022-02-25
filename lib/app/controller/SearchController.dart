import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchC;
  var searchUser = [].obs;
  final authC = AuthController.to;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void searchFriend(String data, String email) async {
    print("SEARCH : $data");
    searchUser([]);
    if (data.length >= 1) {
      final users = await firestore.collection('users').get();
      final follows = authC.user.value.followUser;
      bool result = false;
      users.docs.forEach((user) {
        result = false;
        follows?.forEach((follow) {
          print(follow);
          if (user.data()["name"].contains(data)) {
            if (user.data()["email"] == follow.email) {
              result = true;
            }
          }
        });
        if (!result) {
          if (user.data()["name"].contains(data)) {
            searchUser.add(user.data() as Map<String, dynamic>);
          }
        }
      });
      // if (keyNameResult.docs.length > 0) {
      //   for (int i = 0; i < keyNameResult.docs.length; i++) {
      //     searchUser.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
      //   }
      // }
      print(searchUser);
    }
  }

  @override
  void onInit() {
    searchC = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
