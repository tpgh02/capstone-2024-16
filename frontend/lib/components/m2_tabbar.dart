import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class m2Tabbar extends StatefulWidget {
  const m2Tabbar({Key? key}) : super(key: key);

  @override
  State<m2Tabbar> createState() => _m2TabbarState();
}

Future<List<Calendar>> fetchCalendar() async {
  final response = await http
      .get(Uri.parse(serverUrl + '/api/v1/creature/Calendartory'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

    List<Calendar> Calendars =
        jsonData.map((json) => Calendar.fromJson(json)).toList();
    return Calendars;
  } else {
    throw Exception('Failed to load album');
  }
}

class Calendar {
  final int price;
  final String name;
  final String info;
  final image;
  final int creatureId;

  const Calendar({
    required this.price,
    required this.name,
    required this.info,
    required this.image,
    required this.creatureId,
  });

  factory Calendar.fromJson(dynamic json) {
    return Calendar(
      price: json['price'],
      name: json['name'],
      info: json['info'],
      image: json['image'],
      creatureId: json['creatureId'],
    );
  }
}

class _m2TabbarState extends State<m2Tabbar>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

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
  }

  final List<Map<String, dynamic>> calendarData = [
    {'date': '1', 'flag': false},
    {'date': '4', 'flag': true},
    {'date': '5', 'flag': true},
    {'date': '20', 'flag': true},
    {'date': '24', 'flag': true},
    {'date': '18', 'flag': true}
  ];

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: _tabBar(),
        ),
        TableCalendar(
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
            // 특정 날짜에 대한 셀을 구성하고 스타일 적용
            markerBuilder: (context, date, events) {
              if (calendarData
                      .where(
                          (element) => element['date'] == date.day.toString())
                      .toList()
                      .isNotEmpty &&
                  calendarData
                      .where((element) =>
                          element['date'] == date.day.toString() &&
                          element['flag'] == true)
                      .toList()
                      .isNotEmpty) {
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
          ),
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
                    "$state%",
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
                    "$state%",
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
