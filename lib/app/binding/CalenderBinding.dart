import 'package:chatting_app/app/controller/CalenderController.dart';
import 'package:chatting_app/app/controller/ChatController.dart';
import 'package:chatting_app/app/controller/NavController.dart';
import 'package:get/get.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalenderController>(
      () => CalenderController(),
    );
  }
}
