import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final authC = AuthController.to;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.2,
          leading: Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text("친구",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                )),
          )),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () => {},
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.05,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: Get.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: Get.width * 0.15,
                          height: Get.width * 0.15,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.network(
                              authC.user.value.photoUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: Get.height * 0.02),
                        ),
                        fontS("${authC.user.value.name}")
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.02),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.1,
                          ),
                        )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.02),
                      child: Row(
                        children: [
                          fontSM(
                            "친구",
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.02),
                      child: Row(
                        children: [
                          Container(
                            width: Get.width * 0.12,
                            height: Get.width * 0.12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyGnV38qI3kabyXoa6e9eOn9960Lcnzj3jGA&usqp=CAU",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.02),
                          ),
                          fontS("미현")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.02),
                      child: Row(
                        children: [
                          Container(
                            width: Get.width * 0.12,
                            height: Get.width * 0.12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyGnV38qI3kabyXoa6e9eOn9960Lcnzj3jGA&usqp=CAU",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.02),
                          ),
                          fontS("미현")
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Get.height * 0.015),
                      child: Row(
                        children: [
                          Container(
                            width: Get.width * 0.12,
                            height: Get.width * 0.12,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17),
                              child: Image.network(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyGnV38qI3kabyXoa6e9eOn9960Lcnzj3jGA&usqp=CAU",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.02),
                          ),
                          fontS("미현")
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
