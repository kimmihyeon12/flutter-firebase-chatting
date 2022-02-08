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
      body: Obx(() => Center(
            child: navPages[NavController.to.selectedIndex.value], // 페이지와 연결
          )),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat_bubble_outline,
              ),
              label: 'chat'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.emoji_emotions_outlined,
              ),
              label: 'my'),
        ],
        currentIndex: NavController.to.selectedIndex.value,

        onTap: (index) => {NavController.to.selectedIndex(index)},
        showSelectedLabels: false, //(1)
        showUnselectedLabels: false, //(1)
        type: BottomNavigationBarType.fixed, //(2)
      ),
    );
  }
}
