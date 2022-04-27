import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Size {
  double width = Get.width;
  double height = Get.height;

  void init(context) {
    height = height - MediaQuery.of(context).padding.top;
  }
}
