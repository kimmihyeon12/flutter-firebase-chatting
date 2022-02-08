import 'package:chatting_app/app/controller/NavController.dart';
import 'package:get/get.dart';

class NavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavController>(
      () => NavController(),
    );
  }
}
