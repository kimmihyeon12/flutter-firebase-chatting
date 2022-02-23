import 'package:flutter/material.dart';

Widget profileImage(size, {image}) {
  return Container(
    width: size,
    height: size,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),

      child: image == null
          ? Image.asset("assets/user-bg-02.png", fit: BoxFit.cover)
          : Container(
              color: Colors.black.withOpacity(0.08),
              child: Image.network(image)),
      //호리둥절
    ),
  );
}
