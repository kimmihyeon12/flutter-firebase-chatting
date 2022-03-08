import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/controller/CalenderController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2022, 3, 22): ['Easter Monday'],
};

class Calender extends GetView<CalenderController> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    controller.setEvent();

    return Obx(
      () => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                content: Container(
                  height: Get.height * 0.365,
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
                              if (!controller.loading.value)
                                controller.createCalendar();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          backgroundColor: Color(0xffFF728E),
          child: Icon(
            Icons.add,
            size: 35,
          ),
        ),
        appBar: AppBar(
          centerTitle: false,
          title: font2XL("일정", fonts: "NotoB"),
          backgroundColor: Colors.white,
          elevation: 0.3,
        ),
        backgroundColor: Color(0xffF5F5F6),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.025),
                        child: Container(
                          width: Get.width * 0.88,
                          height: Get.height * 0.36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: TableCalendar(
                            daysOfWeekStyle: DaysOfWeekStyle(
                                weekdayStyle:
                                    TextStyle(fontSize: 13, fontFamily: "NeoB"),
                                weekendStyle: TextStyle(
                                    fontSize: 13, fontFamily: "NeoB")),
                            locale: 'ko-KR',
                            daysOfWeekHeight: Get.height * 0.027,
                            rowHeight: Get.height * 0.052,
                            calendarBuilders: CalendarBuilders(
                                markerBuilder: (context, date, events) {
                              return events.isNotEmpty
                                  ? Positioned(
                                      bottom: 0,
                                      right: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xffcecece),
                                            shape: BoxShape.circle),
                                        padding: const EdgeInsets.all(4.0),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 1),
                                          child: Text(
                                            events.length.toString(),
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontFamily: "NeoH"),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            }),
                            calendarStyle: CalendarStyle(
                              selectedTextStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "NeoH",
                                  color: Colors.white),
                              defaultTextStyle:
                                  TextStyle(fontSize: 13, fontFamily: "NeoR"),
                              weekendTextStyle:
                                  TextStyle(fontSize: 13, fontFamily: "NeoR"),
                              outsideTextStyle: TextStyle(
                                  fontSize: 13,
                                  fontFamily: "NeoR",
                                  color: Colors.grey),
                              todayDecoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    offset: Offset(
                                        1, 1), // changes position of shadow
                                  ),
                                ],
                                color: Color(0xffFFC1C1),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              outsideDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              selectedDecoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 0.5,
                                    blurRadius: 2,
                                    offset: Offset(
                                        1, 1), // changes position of shadow
                                  ),
                                ],
                                color: Color(0xffFFD9D9),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              weekendDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              defaultDecoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              titleTextStyle:
                                  TextStyle(fontSize: 15, fontFamily: "NeoB"),
                              headerPadding: EdgeInsets.symmetric(vertical: 2),
                              titleCentered: true,
                              formatButtonVisible: false,
                            ),
                            firstDay: DateTime.utc(2021, 1, 1),
                            lastDay: DateTime.utc(2025, 12, 31),
                            focusedDay: controller.focusedDay.value,
                            eventLoader: controller.getEventForDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) {
                              return isSameDay(
                                  controller.selectedDay.value, day);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              print(selectedDay
                                  .toString()
                                  .split(" ")[0]
                                  .split("-")[2]);
                              Get.bottomSheet(
                                Container(
                                  height: 250,
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          fontL(
                                              "${selectedDay.toString().split(" ")[0].split("-")[2]}일",
                                              fonts: "NeoB"),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: controller
                                                .getEventForDay(selectedDay)
                                                .map((event) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          fontS(
                                                              event["title"]
                                                                  .toString(),
                                                              color: 0xff0A0A0A,
                                                              fonts: "NeoB"),
                                                          fontS(
                                                              event["content"],
                                                              color: 0xff707070)
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                enableDrag: true,
                                backgroundColor: Colors.white,
                              );

                              if (!isSameDay(
                                  controller.selectedDay.value, selectedDay)) {
                                controller.focusedDay(focusedDay);
                                controller.selectedDay(selectedDay);

                                controller.getEventForDay(selectedDay);
                              }
                            },
                            onPageChanged: (focusedDay) {
                              controller.focusedDay(focusedDay);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: Get.width * 0.06, top: Get.height * 0.02),
                    child: fontM("오늘의 할일", fonts: "NeoB"),
                  ),
                  (() {
                    List<Widget> todayWidget = [];
                    controller.calender.forEach((key, values) => {
                          if (key.toString().substring(0, 10) ==
                              DateTime.now().toString().substring(0, 10))
                            {
                              for (var value in values)
                                {
                                  todayWidget.add(
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 320,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  fontS(value["title"],
                                                      fonts: "NeoB"),
                                                  fontS(value["content"],
                                                      fonts: "NeoL",
                                                      color: 0xff707070),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                }
                            }
                        });

                    return Column(
                      children: todayWidget,
                    );
                  })(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
