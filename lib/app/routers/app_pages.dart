import 'package:chatting_app/app/binding/NavBinding.dart';
import 'package:chatting_app/app/views/pages/nav/add_user_page.dart';
import 'package:chatting_app/app/views/pages/nav/home_page.dart';
import 'package:chatting_app/app/views/pages/introduction_page.dart';
import 'package:chatting_app/app/views/pages/login_page.dart';
import 'package:chatting_app/app/views/pages/nav/nav_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.Nav,
      page: () => NavPage(),
      binding: NavBinding(),
    ),
    GetPage(
      name: Routes.INTRODUCTION,
      page: () => IntroductionPage(),
      // binding: IntroductionBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      // binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.ADDUSER,
      page: () => AddUserPage(),
      // binding: LoginBinding(),
    ),
  ];
}
