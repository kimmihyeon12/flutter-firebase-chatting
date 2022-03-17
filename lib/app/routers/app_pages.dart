import 'package:chatting_app/app/binding/CalenderBinding.dart';
import 'package:chatting_app/app/binding/ChatBinding.dart';
import 'package:chatting_app/app/binding/NavBinding.dart';
import 'package:chatting_app/app/binding/SearchBinding.dart';
import 'package:chatting_app/app/views/pages/nav/add_user_page.dart';
import 'package:chatting_app/app/views/pages/nav/chat_room_page.dart';
import 'package:chatting_app/app/views/pages/introduction_page.dart';
import 'package:chatting_app/app/views/pages/login_page.dart';
import 'package:chatting_app/app/views/pages/nav/imgPreview.dart';
import 'package:chatting_app/app/views/pages/nav/my_page.dart';
import 'package:chatting_app/app/views/pages/nav/nav_page.dart';
import 'package:chatting_app/app/views/pages/nav/profileDetail.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
        name: Routes.Nav,
        page: () => NavPage(),
        bindings: [NavBinding(), ChatBinding(), CalendarBinding()]),
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
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.CHATROOM,
      page: () => ChatRoomPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: Routes.PRORILEDETAIL,
      page: () => ProfileDetail(),
    ),
    GetPage(
      name: Routes.IMGPREVIEW,
      page: () => ImagePreview(),
    ),
    GetPage(
      name: Routes.MYPAGE,
      page: () => Mypage(),
    ),
  ];
}
