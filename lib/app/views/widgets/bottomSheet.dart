import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';

Future bottomSheet(context, background) {
  final authC = AuthController.to;
  return showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(
                      Icons.photo_library,
                      color: Colors.grey,
                    ),
                    title: fontS('갤러리'),
                    onTap: () async {
                      await authC.profileImageUpdate("gallery", background);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                    leading: Icon(
                      Icons.photo_camera,
                      color: Colors.grey,
                    ),
                    title: fontS('카메라'),
                    onTap: () async {
                      await authC.profileImageUpdate("camera", background);

                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: new Icon(
                    Icons.delete_rounded,
                    color: Colors.grey,
                  ),
                  title: fontS('삭제'),
                  onTap: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });
}
