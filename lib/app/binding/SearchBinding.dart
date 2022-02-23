import 'package:chatting_app/app/controller/NavController.dart';
import 'package:chatting_app/app/controller/SearchController.dart';
import 'package:get/get.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
