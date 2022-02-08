import 'package:chatting_app/app/controller/NavController.dart';
import 'package:chatting_app/app/views/pages/nav/chat_page.dart';
import 'package:chatting_app/app/views/pages/nav/home_page.dart';
import 'package:chatting_app/app/views/pages/nav/my_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<Widget> navPages = [HomePage(), ChatPage(), MyPage()];

class NavPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => Center(
            child: navPages[NavController.to.selectedIndex.value], // 페이지와 연결
          )),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: Colors.white,

          items: [
            BottomNavigationBarItem(
                icon: NavController.to.selectedIndex.value == 0
                    ? Image.asset("assets/home-click.png")
                    : Image.asset("assets/home.png"),
                label: 'home'),
            BottomNavigationBarItem(
                icon: NavController.to.selectedIndex.value == 1
                    ? Image.asset("assets/chat-click.png")
                    : Image.asset("assets/chat.png"),
                label: 'chat'),
            BottomNavigationBarItem(
                icon: NavController.to.selectedIndex.value == 2
                    ? Image.asset("assets/mypage-click.png")
                    : Image.asset("assets/mypage.png"),
                label: 'chat'),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.emoji_emotions_outlined,
            //     ),
            //     label: 'my'),
          ],
          currentIndex: NavController.to.selectedIndex.value,

          onTap: (index) => {NavController.to.selectedIndex(index)},
          showSelectedLabels: false, //(1)
          showUnselectedLabels: false, //(1)
          type: BottomNavigationBarType.fixed, //(2)
        ),
      ),
    );
  }
}
