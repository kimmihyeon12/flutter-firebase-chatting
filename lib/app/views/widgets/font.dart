import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget fontSM(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 12,
        color: color ?? Colors.black,
        fontFamily: fonts ?? "NeoL"),
  );
}

Widget fontS(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 15,
        color: color ?? Colors.black,
        fontFamily: fonts ?? "NeoL"),
  );
}

Widget fontM(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 18,
        color: color ?? Color(color),
        fontFamily: fonts ?? "NeoL"),
  );
}

Widget fontL(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 21,
        color: color ?? Colors.black,
        fontFamily: fonts ?? "NeoL"),
  );
}
