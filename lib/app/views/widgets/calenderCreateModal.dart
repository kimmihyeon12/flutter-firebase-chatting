import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/CalenderController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

CalenderCreateModal(context, {id = null, time = null}) {
  final authC = AuthController.to;
  print(id);
  var controller = CalenderController.to;
  Get.dialog(
    AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      content: Container(
        height: authC.height * 0.4,
        child: Column(
          children: [
            Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                fontS('일정 작성하기 ', fonts: "NeoB"),
                Image.asset("assets/smail.png")
              ],
            )),
            Padding(padding: EdgeInsets.only(top: Get.height * 0.01)),
            Container(
              height: Get.height * 0.05,
              child: TextFormField(
                controller: controller.title,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: const Color(0xffD5D5D5),
                    ),
                  ),
                  hintText: "제목",
                  contentPadding: EdgeInsets.all(10.0),
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {},
                style: TextStyle(
                  fontFamily: "NeoL",
                  fontSize: 15,
                  color: Color(0xff707070),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: Get.height * 0.01)),
            Container(
              child: TextFormField(
                cursorColor: Colors.black12,
                controller: controller.content,
                decoration: new InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                    borderSide: BorderSide(
                      color: const Color(0xffD5D5D5),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: "내용",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(12.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {},
                maxLines: 6,
                style: TextStyle(
                  fontFamily: "NeoL",
                  fontSize: 15,
                  color: Color(0xff707070),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: Get.height * 0.01)),
            InkWell(
              onTap: () {
                DatePicker.showDateTimePicker(
                  context,
                  locale: LocaleType.ko,
                  showTitleActions: true,
                  minTime: DateTime(2018, 3, 5),
                  maxTime: DateTime(2026, 6, 7),
                  onConfirm: (date) {
                    controller.setTime(date);
                  },
                  currentTime: controller.time.value,
                );
              },
              child: Obx(
                () => Container(
                  child: Padding(
                    padding: EdgeInsets.only(right: Get.width * 0.02),
                    child: Container(
                        width: Get.width,
                        child: Center(
                          child: Column(
                            children: [
                              fontS(
                                  controller.time.value
                                      .toString()
                                      .substring(0, 10),
                                  color: 0xffffffff,
                                  fonts: "NeoB"),
                              fontS(
                                  controller.time.value
                                      .toString()
                                      .substring(11, 16),
                                  color: 0xffffffff,
                                  fonts: "NeoB"),
                            ],
                          ),
                        )),
                  ),
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xffFFC1C1),
                    border: Border.all(
                      color: Color(0xffffffff),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: Get.height * 0.01)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // InkWell(
                //   child: fontS("취소", fonts: "NeoB"),
                //   onTap: () {
                //     Get.back();
                //   },
                // ),
                Padding(padding: EdgeInsets.only(right: 5)),
                InkWell(
                  child: fontS("확인", fonts: "NeoB"),
                  onTap: () {
                    if (!controller.loading.value) {
                      id != null
                          ? controller.updateCalender(id, time)
                          : controller.createCalendar();
                    }
                  },
                ),
                InkWell(
                  child: fontS("취소", fonts: "NeoB"),
                  onTap: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
