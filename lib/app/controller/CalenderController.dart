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
      "complete": false
    };
    var result = await firestore
        .collection("users")
        .doc(AuthController.to.user.value.email)
        .collection("calender")
        .add(data);
    addCalender(t, {"data": data, "id": result.id});
    calender.refresh();
    setEvent();

    title.clear();
    content.clear();
    loading(false);
    Get.back();
  }

  selectCalender() async {
    print(AuthController.to.user.value.email);
    var result = await firestore
        .collection('users')
        .doc(AuthController.to.user.value.email)
        .collection("calender")
        .get();

    result.docs.forEach((data) {
      var time = data.data()["time"].split(" ")[0].split("-");

      addCalender(time, {"data": data.data(), "id": data.id});
    });
    calender.refresh();
    setEvent();
  }

  deleteCalender(id, time) async {
    await firestore
        .collection('users')
        .doc(AuthController.to.user.value.email)
        .collection("calender")
        .doc(id)
        .delete();

    var timeResult = time.toString().split(" ")[0].split("-");
    var copyData = [];
    calender[DateTime(int.parse(timeResult[0]), int.parse(timeResult[1]),
            int.parse(timeResult[2]))]
        ?.forEach((element) {
      if (element["id"] != id) {
        copyData.add(element);
      }
    });
    calender[DateTime(int.parse(timeResult[0]), int.parse(timeResult[1]),
        int.parse(timeResult[2]))] = copyData;
    calender.refresh();
  }

  updateComplete(id, time, complete) async {
    print("updateComplete");
    await firestore
        .collection("users")
        .doc(AuthController.to.user.value.email)
        .collection("calender")
        .doc(id)
        .update({"complete": !complete});

    var timeResult = time.toString().split(" ")[0].split("-");
    var copyData = [];
    calender[DateTime(int.parse(timeResult[0]), int.parse(timeResult[1]),
            int.parse(timeResult[2]))]
        ?.forEach((element) {
      if (element["id"] != id) {
        copyData.add(element);
      } else {
        print(element);
        copyData.add({
          "data": {
            "title": element["data"]["title"],
            "content": element["data"]["content"],
            "time": element["data"]["time"],
            "complete": !complete
          },
          "id": id
        });
      }
    });
    calender[DateTime(int.parse(timeResult[0]), int.parse(timeResult[1]),
        int.parse(timeResult[2]))] = copyData;
    calender.refresh();
  }

  updateCalender(id, timepr) async {
    loading(true);

    var data = {
      "title": title.text,
      "content": content.text,
      "time": time.value.toString(),
      "complete": false
    };
    await firestore
        .collection("users")
        .doc(AuthController.to.user.value.email)
        .collection("calender")
        .doc(id)
        .update(data);

    var timeResult = timepr.toString().split(" ")[0].split("-");
    var copyData = [];
    calender[DateTime(int.parse(timeResult[0]), int.parse(timeResult[1]),
            int.parse(timeResult[2]))]
        ?.forEach((element) {
      if (element["id"] != id) {
        copyData.add(element);
      } else {
        copyData.add({"data": data, "id": id});
      }
    });
    calender[DateTime(int.parse(timeResult[0]), int.parse(timeResult[1]),
        int.parse(timeResult[2]))] = copyData;
    calender.refresh();
    title.clear();
    content.clear();
    loading(false);
    Get.back();
  }

  addCalender(time, data) {
    print(time);
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

  setTime(date) {
    time(date);
    time.refresh();
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
