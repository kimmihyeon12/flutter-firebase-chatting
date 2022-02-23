import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  late TextEditingController searchC;
  var searchUser = [].obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void searchFriend(String data, String email) async {
    print("SEARCH : $data");
    searchUser([]);
    if (data.length >= 1) {
      // firestore 컬렉션을 참조하는 users라는 CollectionReference를 만듭니다.
      CollectionReference users = await firestore.collection('users');
      // 사용자의 CollectionReference를 호출하여 새 사용자를 추가합니다.
      final keyNameResult = await users.where("name", isEqualTo: data).get();
      if (keyNameResult.docs.length > 0) {
        for (int i = 0; i < keyNameResult.docs.length; i++) {
          searchUser.add(keyNameResult.docs[i].data() as Map<String, dynamic>);
        }
      }
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
