import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Size {
  double width = Get.width;
  double height = Get.height ;

  void init(context){
    print("init");
    height = height - MediaQuery.of(context).padding.top;

  }
  void setWidth(double width) {
    width = width;
  }

  void setHeight(double height) {

    print(height);
  }
}
