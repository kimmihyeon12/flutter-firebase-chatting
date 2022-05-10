import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/routers/app_routes.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({
    Key? key,
    required this.index,
    required this.isSender,
    required this.img,
    required this.prvImg,
    required this.msg,
    required this.time,
    required this.friendData,
  }) : super(key: key);

  final bool isSender;
  final int index;
  final friendData;
  final String msg;
  final String time;
  final String img;
  final String prvImg;
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    print(friendData.prvPhotoUrl);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isSender
              ? Column(
                  children: [
                    //  index >= read_index ? fontSM("읽음") : Container(),
                    fontSM(DateFormat('HH:mm').format(DateTime.parse(time))),
                  ],
                )
              : Container(),
          Padding(padding: EdgeInsets.only(right: isSender ? 5 : 0)),
          Row(
            children: [
              isSender
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Get.toNamed(Routes.PRORILEDETAIL, arguments: {
                          "user": friendData,
                        });
                      },
                      child: profileImage(authC.width * 0.08,
                          image: friendData.prvPhotoUrl),
                    ),
              Padding(padding: EdgeInsets.only(right: isSender ? 0 : 5)),
              Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.6),
                decoration: BoxDecoration(
                  color: isSender ? Color(0xffFFE0ED) : Colors.white,
                  borderRadius: isSender
                      ? BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                ),
                padding:
                    EdgeInsets.only(top: 8, bottom: 9, left: 10, right: 10),
                child: prvImg != "null"
                    ? InkWell(
                        onTap: () =>
                            {Get.toNamed(Routes.IMGDETAIL, arguments: img)},
                        child: Image.network(
                          prvImg,
                          width: Get.width * 0.4,
                        ))
                    : fontS("$msg", fonts: "NeoM"),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(right: !isSender ? 5 : 0)),
          !isSender
              ? Row(
                  children: [
                    fontSM(DateFormat('HH:mm').format(DateTime.parse(time))),
                    Padding(padding: EdgeInsets.only(right: 2)),
                  ],
                )
              : Container(),
          SizedBox(height: 5),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
