import 'dart:collection';

import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderController extends GetxController {
  static CalenderController get to => Get.find();
  late TextEditingController title;
  late TextEditingController content;

  final calender = RxMap<DateTime, List>();
  final event = RxMap();
  final focusedDay = DateTime.now().obs;
  final selectedDay = DateTime.now().obs;
  final time = DateTime.now().obs;
  final loading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  createCalendar() async {
    loading(true);
    var t = time.value.toString().split(" ")[0].split("-");
    var data = {
      "title": title.text,
      "content": content.text,
      "time": time.value.toString(),
    };
    await firestore
        .collection("users")
        .doc(AuthController.to.user.value.email)
        .collection("calender")
        .add(data);
    addCalender(t, data);
    calender.refresh();
    setEvent();

    title.clear();
    content.clear();
    loading(false);
    Get.back();
  }

  setTime(date) {
    time(date);
    time.refresh();
  }

  selectCalender() async {
    print("selectCalender");
    print(AuthController.to.user.value.email);
    var result = await firestore
        .collection('users')
        .doc(AuthController.to.user.value.email)
        .collection("calender")
        .get();

    result.docs.forEach((data) {
      print(data.data());
      var time = data.data()["time"].split(" ")[0].split("-");
      addCalender(time, data.data());
    });
    calender.refresh();
    setEvent();
  }

  addCalender(time, data) {
    if (calender.containsKey(
        DateTime(int.parse(time[0]), int.parse(time[1]), int.parse(time[2])))) {
      calender[DateTime(
              int.parse(time[0]), int.parse(time[1]), int.parse(time[2]))]
          ?.add(data);
    } else {
      calender[DateTime(
          int.parse(time[0]), int.parse(time[1]), int.parse(time[2]))] = [];
      calender[DateTime(
              int.parse(time[0]), int.parse(time[1]), int.parse(time[2]))]
          ?.add(data);
    }
  }

  setEvent() {
    event(LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(calender));
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  List getEventForDay(DateTime day) {
    return event[day] ?? [];
  }

  @override
  void onInit() async {
    await selectCalender();
    title = TextEditingController();
    content = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    title.dispose();
    content.dispose();
    super.onClose();
  }
}
