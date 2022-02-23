import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({
    Key? key,
    required this.isSender,
    required this.msg,
    required this.time,
  }) : super(key: key);

  final bool isSender;
  final String msg;
  final String time;

  @override
  Widget build(BuildContext context) {
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
              ? fontSM(DateFormat('HH:mm').format(DateTime.parse(time)))
              : Container(),
          Padding(padding: EdgeInsets.only(right: isSender ? 5 : 0)),
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
            padding: EdgeInsets.only(top: 8, bottom: 9, left: 10, right: 10),
            child: fontS("$msg", fonts: "NeoM"),
          ),
          Padding(padding: EdgeInsets.only(right: !isSender ? 5 : 0)),
          !isSender
              ? fontSM(DateFormat('HH:mm').format(DateTime.parse(time)))
              : Container(),
          SizedBox(height: 5),
        ],
      ),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
    );
  }
}
