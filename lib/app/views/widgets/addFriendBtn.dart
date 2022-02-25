import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget AddFreindBtn(frendEmail) {
  final authC = AuthController.to;
  return InkWell(
      onTap: () async {
        await authC.createfollowUser(frendEmail);
      },
      child: Container(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: fontSM("친구추가", color: 0xffffffff, fonts: "NotoB")),
          decoration: BoxDecoration(
              color: Color(0xffff7282),
              borderRadius: BorderRadius.circular(50), //모서리를 둥글게
              border: Border.all(color: Color(0xffff7282), width: 1))));
}
