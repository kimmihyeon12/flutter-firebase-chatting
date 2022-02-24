import 'package:flutter/material.dart';
import 'bottomSheet.dart';

Widget Camera(size, context, {background = false}) {
  return InkWell(
    onTap: () async {
      await bottomSheet(context, background);
    },
    child: Container(
      width: size,
      height: size,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            color: Colors.grey,
            child: Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: size - 10,
            ),
            //호리둥절
          )),
    ),
  );
}
