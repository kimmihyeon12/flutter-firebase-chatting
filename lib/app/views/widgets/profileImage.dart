import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget profileImage(size, {image, round = 15.0}) {
  return Container(
    width: size,
    height: size,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(round),

      child: image == null
          ? Image.asset(
              "assets/user-bg-02.png",
            )
          : Container(
              color: Colors.black.withOpacity(0.08),
              child: Image.network(
                image,
                width: size,
                height: size,
                fit: BoxFit.fitHeight,
                filterQuality: FilterQuality.low,
              )),
      //호리둥절
    ),
  );
}
