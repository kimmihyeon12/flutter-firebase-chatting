import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: false,
            title: font2XL("내 정보", fonts: "NotoB"),
            backgroundColor: Colors.white,
            elevation: 0.3,
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: Get.height * 0.04)),
                  Container(
                    width: Get.width * 0.4,
                    height: Get.width * 0.4,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xffebebeb),
                            offset: Offset(0.0, 6.0), //(x,y)
                            blurRadius: 10,
                          ),
                        ],
                        color: Color(0xffffe0ed),
                        borderRadius: BorderRadius.circular(200), //모서리를 둥글게
                        border: Border.all(color: Color(0xffffffff), width: 4)),
                    child: Image.asset(
                      "assets/user-01.png",
                      width: Get.width * 0.3,
                      height: Get.width * 0.3,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: Get.height * 0.01)),
                  fontL("김미현", fonts: "NeoB"),
                  Padding(padding: EdgeInsets.only(top: Get.height * 0.005)),
                  fontM("2_5_3_1@naver.com", color: 0xff707070),
                ],
              ),
            ),
          )),
    );
  }
}

// class MyPage extends StatelessWidget {
//   final authC = AuthController.to;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         AvatarGlow(
//           endRadius: 60,
//           glowColor: Colors.black,
//           duration: Duration(seconds: 2),
//           child: Container(
//             margin: EdgeInsets.all(15),
//             width: Get.width * 0.25,
//             height: Get.width * 0.25,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(35),
//               child: authC.user.value.photoUrl! == "noimage"
//                   ? Image.asset(
//                       "assets/logo/noimage.png",
//                       fit: BoxFit.cover,
//                     )
//                   : Image.network(
//                       authC.user.value.photoUrl!,
//                       fit: BoxFit.cover,
//                     ),
//             ),
//           ),
//         ),
//         fontM("${authC.user.value.name}"),
//         fontM("${authC.user.value.email}"),
//       ],
//     ));
//   }
// }
