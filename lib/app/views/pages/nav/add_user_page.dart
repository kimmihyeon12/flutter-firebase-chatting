import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 20,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.grey,
              icon: Icon(Icons.arrow_back_ios)),
          title: Padding(
            padding: EdgeInsets.only(right: 11),
            child: font2XL("친구추가", fonts: "NotoB"),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                width: Get.width * 0.9,
                //height: Get.height * 0.08,
                child: TextField(
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
                      ),
                      // filled: true,
                      contentPadding: EdgeInsets.all(20),
                      hintStyle: TextStyle(
                          color: Colors.grey[500], fontFamily: "NeoL"),
                      hintText: "닉네임을 입력해주세요.",
                      fillColor: Colors.white70),
                ),
              ),
              Container(
                width: Get.width * 0.85,
                child: Row(
                  children: [
                    Image.asset("assets/user-bg-02.png",
                        width: Get.width * 0.15,
                        height: Get.width * 0.15,
                        fit: BoxFit.cover),
                    Padding(padding: EdgeInsets.only(left: Get.width * 0.03)),
                    Container(
                      width: Get.width * 0.48,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          fontS("김미현", color: 0xff000000, fonts: "NeoB"),
                          Padding(
                              padding:
                                  EdgeInsets.only(top: Get.height * 0.002)),
                          fontS("2_5_3_1@naver.com", color: 0xff707070),
                        ],
                      ),
                    ),
                    Container(
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: fontSM("친구추가",
                                color: 0xffffffff, fonts: "NotoB")),
                        decoration: BoxDecoration(
                            color: Color(0xffff7282),
                            borderRadius: BorderRadius.circular(50), //모서리를 둥글게
                            border: Border.all(
                                color: Color(0xffff7282), width: 1))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
