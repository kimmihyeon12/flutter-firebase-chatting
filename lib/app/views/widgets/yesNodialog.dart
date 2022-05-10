import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

YesNoDialog(String msg) {
  return Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[fontS('${msg}', color: 0xff707070)],
      ),
      actions: <Widget>[
        InkWell(
          onTap: () => {Get.back(result: true)},
          child: Container(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: fontSM("예", color: 0xff707070),
          )),
        ),
        InkWell(
          onTap: () => {Get.back(result: false)},
          child: Container(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            child: fontSM("아니요", color: 0xff707070),
          )),
        ),
      ],
      elevation: 10,
    ),
  );
}
