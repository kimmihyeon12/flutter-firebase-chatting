import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget fontSM(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 12,
        color: color == null ? Colors.black : Color(color),
        fontFamily: fonts ?? "NeoL"),
  );
}

Widget fontS(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 15,
        color: color == null ? Colors.black : Color(color),
        fontFamily: fonts ?? "NeoL"),
  );
}

Widget fontM(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 18,
        color: color == null ? Colors.black : Color(color),
        fontFamily: fonts ?? "NeoL"),
  );
}

Widget fontL(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 21,
        color: color == null ? Colors.black : Color(color),
        fontFamily: fonts ?? "NeoL"),
  );
}

Widget font2XL(String msg, {color, fonts}) {
  return Text(
    msg,
    style: TextStyle(
        fontSize: 30,
        color: color == null ? Colors.black : Color(color),
        fontFamily: fonts ?? "NeoL"),
  );
}
