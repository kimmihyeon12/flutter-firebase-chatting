import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/SearchController.dart';
import 'package:chatting_app/app/views/widgets/addFriendBtn.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:chatting_app/app/views/widgets/profileImage.dart';
import 'package:chatting_app/app/views/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserPage extends GetView<SearchController> {
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 20,
          leading: Padding(
            padding: EdgeInsets.only(top: 5),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context); //뒤로가기
                },
                color: Colors.grey,
                icon: Icon(Icons.arrow_back_ios)),
          ),
          title: Padding(
            padding: EdgeInsets.only(right: 11),
            child: font2XL("친구추가", fonts: "NotoB"),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: authC.height * 0.008)),
            Container(
              width: authC.width * 0.9,
              child: TextField(
                controller: controller.searchC,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffd6d3d3), width: 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffd6d3d3), width: 1),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    suffixIcon: InkWell(
                        child: Image.asset("assets/add-btn.png"),
                        onTap: () {
                          controller.searchFriend(
                            controller.searchC.text,
                            authC.user.value.email!,
                          );
                        }),
                    // filled: true,

                    contentPadding: EdgeInsets.all(20),
                    hintStyle:
                        TextStyle(color: Colors.grey[500], fontFamily: "NeoL"),
                    hintText: "닉네임을 입력해주세요.",
                    fillColor: Colors.white70),
              ),
            ),
            Obx(() => controller.searchUser.length == 0
                ? Center(
                    child: Center(
                        child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: authC.height * 0.02)),
                        fontM("등록된 친구가 없습니다", color: 0XFFFF728D, fonts: "NotoB")
                      ],
                    )),
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: controller.searchUser.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: authC.height * 0.01,
                                left: authC.width * 0.055),
                            child: Container(
                              width: authC.width * 0.85,
                              child: Row(
                                children: [
                                  profileImage(authC.width * 0.15,
                                      image:
                                          "${controller.searchUser[index]["photoUrl"]}"),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: authC.width * 0.03)),
                                  Container(
                                    width: authC.width * 0.45,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        fontS(
                                            "${controller.searchUser[index]["name"]}",
                                            color: 0xff000000,
                                            fonts: "NeoB"),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: authC.height * 0.002)),
                                        fontS(
                                            "${controller.searchUser[index]["email"]}",
                                            color: 0xff707070),
                                      ],
                                    ),
                                  ),
                                  AddFreindBtn(
                                      controller.searchUser[index]["email"]),
                                ],
                              ),
                            ),
                          );
                        }),
                  )),
          ],
        ),
      ),
    );
  }
}
