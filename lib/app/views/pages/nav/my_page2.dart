import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatting_app/app/controller/AuthController.dart';
import 'package:chatting_app/app/views/widgets/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2020, 1, 1): ['New Year\'s Day'],
  DateTime(2020, 1, 6): ['Epiphany'],
  DateTime(2020, 2, 14): ['Valentine\'s Day'],
  DateTime(2020, 4, 21): ['Easter Sunday'],
  DateTime(2020, 4, 22): ['Easter Monday'],
};

class Calender extends StatefulWidget {
  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _eventsList = {
      // `DateTime A`: [`event title1`, `event title2`, ...],
      DateTime.now().subtract(Duration(days: 2)): ['Event A1', 'Event B1'],

      DateTime.now().add(Duration(days: 1)): [
        'Event A3',
        'Event B3',
        'Event C2',
        'Event D2'
      ],
      DateTime.now().add(Duration(days: 3)):
          Set.from(['Event A4', 'Event A5', 'Event B4']).toList(),
      DateTime.now(): [
        'Event A6',
        'Event B5',
        'Event C3',
        'Event C3',
        'Event C3',
        'Event C3'
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              content: Container(
                height: Get.height * 0.36,
                child: Column(
                  children: [
                    Center(child: fontS('일정 작성하기😄', fonts: "NeoB")),
                    Padding(padding: EdgeInsets.only(top: Get.height * 0.01)),
                    Container(
                      height: Get.height * 0.05,
                      child: TextFormField(
                        decoration: new InputDecoration(
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
                        decoration: new InputDecoration(
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
                    Row(
                      children: [
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: Get.width * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [fontS("2021-09-11"), fontS("11:00")],
                            ),
                          ),
                          width: Get.width * 0.32,
                          height: 40,
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff707070),
                              ),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0))),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(right: Get.width * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [fontS("2021-09-11"), fontS("11:00")],
                            ),
                          ),
                          width: Get.width * 0.32,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xff707070),
                            ),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0)),
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: Get.height * 0.01)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        fontS("취소", fonts: "NeoB"),
                        Padding(padding: EdgeInsets.only(right: 5)),
                        fontS("확인", fonts: "NeoB"),
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
                              weekendStyle:
                                  TextStyle(fontSize: 13, fontFamily: "NeoB")),
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
                          focusedDay: _focusedDay,
                          eventLoader: _getEventForDay,
                          calendarFormat: _calendarFormat,
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            print(selectedDay);
                            Get.bottomSheet(
                              Container(
                                height: 250,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      fontL("2일(화)", fonts: "NeoB"),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: _getEventForDay(selectedDay)
                                            .map((event) => ListTile(
                                                  title:
                                                      fontS(event.toString()),
                                                ))
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              enableDrag: true,
                              backgroundColor: Colors.white,
                            );

                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              _getEventForDay(selectedDay);
                            }
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
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
                  _eventsList.forEach((key, values) => {
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
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                fontS(value, fonts: "NeoB"),
                                                fontS("- 마이페이지 켈린더 구상하기",
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
            /*ListView(
              shrinkWrap: true,
              children: _getEventForDay(_selectedDay!)
                  .map((event) => ListTile(
                        title: Text(event.toString()),
                      ))
                  .toList(),
            )
            */
          ],
        ),
      ),
    );
  }
}
