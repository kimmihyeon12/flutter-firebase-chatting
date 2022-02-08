import 'package:get/get.dart';

void getXSnackbar(String msg) {
  Get.snackbar(
    "message",
    msg,
    duration: Duration(seconds: 2),
  );
}
