import 'dart:developer';

import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String _lastMonth = '';
String _thisMonth = '';

class m2Tabbar extends StatefulWidget {
  final roomId;
  const m2Tabbar({this.roomId});

  @override
  State<m2Tabbar> createState() => _m2TabbarState();
}

Future<List<calendarData>> fetchcalendarData(roomId) async {
  final response = await http
      .get(Uri.parse('${serverUrl}/api/v1/report/simple/${roomId}'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  log('서버 : ${serverUrl}/api/v1/report/simple/${roomId}');
  if (response.statusCode == 200) {
    // final Map<String, dynamic> jsonData =
    //     jsonDecode(utf8.decode(response.bodyBytes));
    // log("that is fetch data: $jsonData");
    // final List<calendarData> calenderData = jsonData['calender'];

    // log("that is fetch error:${calendarData}");
    // log("that is fetch error:${roomId == null}");
    final Map<String, dynamic> jsonData =
        jsonDecode(utf8.decode(response.bodyBytes));
    _lastMonth = jsonData["lastMonth"].toString();
    _thisMonth = jsonData["thisMonth"].toString();
    final List<dynamic> calendarDataList = jsonData['calender'];

    List<calendarData> calendarDatas =
        calendarDataList.map((json) => calendarData.fromJson(json)).toList();
    log("that is fetch data:${calendarDataList}");
    return calendarDatas;
  } else {
    log("that is no");
    throw Exception('Failed to load calendarData data');
  }
}

class calendarData {
  final String date;
  final bool flag;

  const calendarData({
    required this.date,
    required this.flag,
  });

  factory calendarData.fromJson(Map<String, dynamic> json) {
    return calendarData(
      date: json['date'],
      flag: json['flag'] == "true",
    );
  }
}

class _m2TabbarState extends State<m2Tabbar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Future<List<calendarData>> _calendarDataFuture;

  List<String> dayoff = ['지난 달', '이번 달'];
  String month = '지난 달';
  DateTime selectedDate = DateTime.now();
  int state = 10;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: dayoff.length,
      vsync: this,
      initialIndex: 0,
      animationDuration: const Duration(milliseconds: 200),
    );
    tabController.addListener(() {
      setState(() {
        month = dayoff[tabController.index];
      });
    });
    log("m2_tabbar!!! roomId:${widget.roomId}");
    if (widget.roomId != null) {
      _calendarDataFuture = fetchcalendarData(widget.roomId.toString());
    } else {}
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("m2_tabbar : ${widget.roomId}");
    return Column(
      children: [
        Container(
          child: _tabBar(),
        ),
        FutureBuilder<List<calendarData>>(
          future: _calendarDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Column(
                children: [
                  _buildDefaultCalendar(),
                  Text('Error: ${snapshot.error}'),
                ],
              );
            } else if (snapshot.hasData) {
              final calendarDataList = snapshot.data!;
              if (calendarDataList.isEmpty) {
                return _buildDefaultCalendar();
              } else {
                log("데이터 있음");
                //log("${calendarDataList[0].flag}");
                return Container(
                  child: _CalendarData(calendarDataList),
                );
              }
            } else {
              return _buildDefaultCalendar();
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "이번 달성률 : ",
                    style: TextStyle(fontFamily: "bm", fontSize: 20),
                  ),
                  Text(
                    "$_thisMonth%",
                    style: const TextStyle(fontFamily: "bm", fontSize: 30),
                  )
                ],
              ),
              Row(
                children: [
                  const Text(
                    "지난 달성률 : ",
                    style: TextStyle(fontFamily: "bm", fontSize: 20),
                  ),
                  Text(
                    "$_lastMonth%",
                    style: const TextStyle(fontFamily: "bm", fontSize: 30),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _tabBar() {
    return TabBar(
      controller: tabController,
      indicatorColor: PRIMARY_COLOR,
      labelColor: PRIMARY_COLOR,
      tabs: dayoff.map(
        (value) {
          return Tab(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'bm',
                fontSize: 20,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

Widget _buildDefaultCalendar() {
  return TableCalendar(
    focusedDay: DateTime.now(),
    firstDay: DateTime.utc(2024, 5, 1),
    lastDay: DateTime.utc(2024, 5, 31),
    headerStyle: const HeaderStyle(
      titleCentered: true,
      formatButtonVisible: false,
      leftChevronVisible: false,
      rightChevronVisible: false,
      titleTextStyle: TextStyle(fontFamily: 'bm', fontSize: 20),
    ),
    calendarStyle: const CalendarStyle(
      todayDecoration: BoxDecoration(
        color: PRIMARY_COLOR, // 변경 가능
        shape: BoxShape.circle,
      ),
    ),
    calendarBuilders: CalendarBuilders(
      markerBuilder: (context, date, events) {
        return null;
      },
    ),
  );
}

Widget _CalendarData(List<calendarData> calendarDataList) {
  return TableCalendar(
    focusedDay: DateTime.now(),
    firstDay: DateTime.utc(2024, 5, 1),
    lastDay: DateTime.utc(2024, 5, 31),
    headerStyle: const HeaderStyle(
      titleCentered: true,
      formatButtonVisible: false,
      leftChevronVisible: false,
      rightChevronVisible: false,
      titleTextStyle: TextStyle(fontFamily: 'bm', fontSize: 20),
    ),
    calendarStyle: const CalendarStyle(
      todayDecoration: BoxDecoration(
        color: PRIMARY_COLOR, // 변경 가능
        shape: BoxShape.circle,
      ),
    ),
    calendarBuilders: CalendarBuilders(
      // 서버에서 받은 캘린더 데이터를 이용하여 셀을 구성하고 스타일 적용
      markerBuilder: (context, date, events) {
        final filteredData = calendarDataList
            .where((element) => element.date == date.day.toString());
        final flaggedData =
            filteredData.where((element) => element.flag == true);
        if (filteredData.isNotEmpty && flaggedData.isNotEmpty) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: POINT_COLOR, // 변경 가능
              shape: BoxShape.circle,
            ),
            width: 8,
            height: 8,
          );
        }
        return null;
      },
      // markerBuilder: (context, date, events) {
      //   return null;
      // },
    ),
  );
}
