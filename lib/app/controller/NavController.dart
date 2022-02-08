import 'package:get/get.dart';

class NavController extends GetxController {
  static NavController get to => Get.find();
  RxInt selectedIndex = 0.obs;

  setIndex(index) {
    selectedIndex(index);
  }
}
