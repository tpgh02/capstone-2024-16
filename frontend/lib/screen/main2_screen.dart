import 'dart:convert';
import 'dart:developer';
import 'package:dodo/components/m2_button.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

double _lastMonthPercentage = 0.0;
double _thisMonthPercentage = 0.0;

Future<List<MyRoom_Main>> fetchRoomsMain() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/room/list'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<MyRoom_Main> roomsMain =
        jsonData.map((json) => MyRoom_Main.fromJson(json)).toList();
    log("Main2 : Connected!");
    return roomsMain;
  } else {
    throw Exception('Failed to load room list in main');
  }
}

class MyRoom_Main {
  final String room_title;
  final int room_id;
  final room_img;

  const MyRoom_Main(
      {required this.room_title,
      required this.room_id,
      required this.room_img});

  factory MyRoom_Main.fromJson(dynamic json) {
    return MyRoom_Main(
      room_title: json['name'] ?? "",
      room_id: json['roomId'] ?? 1,
      room_img: json['image'] ?? {},
    );
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

class main2Page extends StatefulWidget {
  const main2Page({super.key});

  @override
  State<main2Page> createState() => _main2PageState();
}

class _main2PageState extends State<main2Page>
    with SingleTickerProviderStateMixin {
  late Future<List<MyRoom_Main>> _roomsMainFuture;
  MyRoom_Main? _selectedRoom;
  late TabController tabController;
  late Future<List<calendarData>> _calendarDataFuture;

  Future<void> _initializeCalendarData(String roomId) async {
    if (_selectedRoom != null) {
      final List<calendarData> calendarDataList =
          await fetchcalendarData(roomId);
      setState(() {
        _calendarDataFuture = Future.value(calendarDataList);
      });
    }
  }

  List<String> dayoff = ['지난 달', '이번 달'];
  String month = '지난 달';
  DateTime selectedDate = DateTime.now();

  Future<List<calendarData>> fetchcalendarData(String roomId) async {
    final response = await http.get(
        Uri.parse('${serverUrl}/api/v1/report/simple/${roomId}'),
        headers: {
          'Authorization':
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
        });
    log('서버 : ${serverUrl}/api/v1/report/simple/${roomId}');
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData =
          jsonDecode(utf8.decode(response.bodyBytes));
      _lastMonthPercentage = jsonData["lastMonth"];
      _thisMonthPercentage = jsonData["thisMonth"];
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

    _roomsMainFuture = fetchRoomsMain();
    _initializeCalendarData("1");
    _calendarDataFuture = fetchcalendarData("1");
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  String formatPercentage(double percentage) {
    return (percentage).toStringAsFixed(2) + '%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const mainPage()),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: POINT_COLOR,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FutureBuilder<List<MyRoom_Main>>(
                      future: _roomsMainFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData) {
                          return DropdownButton(
                            value: _selectedRoom,
                            items: (snapshot.data ?? []).map((room) {
                              return DropdownMenuItem(
                                value: room,
                                child: Text(room.room_title,
                                    style: const TextStyle(
                                        fontFamily: 'bm', fontSize: 15)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRoom = value as MyRoom_Main?;
                                if (_selectedRoom != null) {
                                  _initializeCalendarData(
                                      _selectedRoom!.room_id.toString());
                                }
                              });
                            },
                          );
                        } else {
                          return DropdownButton(
                            value: _selectedRoom,
                            items: (snapshot.data ?? []).map((room) {
                              return DropdownMenuItem(
                                value: room,
                                child: Text(
                                  room.room_title,
                                  style: const TextStyle(
                                      fontFamily: 'bm', fontSize: 15),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRoom = value as MyRoom_Main?;

                                _initializeCalendarData(
                                    _selectedRoom!.room_id.toString());
                                // _calendarDataFuture = fetchcalendarData(
                                //     _selectedRoom!.room_id.toString());
                              });
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Visibility(
                      visible: MediaQuery.of(context).size.width > 420,
                      child: const Text(
                        "에서 나는?",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'kcc',
                            color: POINT_COLOR),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        //spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 3)),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        children: [
                          FutureBuilder<List<calendarData>>(
                              future: _calendarDataFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  log(_selectedRoom!.room_id.toString());
                                  log('calendar Error: ${snapshot.error}');
                                  return _buildDefaultCalendar();
                                } else if (snapshot.hasData) {
                                  final calendarDataList = snapshot.data!;
                                  if (calendarDataList == null ||
                                      calendarDataList.isEmpty) {
                                    return _buildDefaultCalendar();
                                  } else {
                                    return _CalendarData(calendarDataList);
                                  }
                                } else {
                                  return _buildDefaultCalendar();
                                }
                              }),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "이번 달성률 : ",
                                      style: TextStyle(
                                          fontFamily: "bm", fontSize: 20),
                                    ),
                                    Text(
                                      formatPercentage(_thisMonthPercentage),
                                      style: const TextStyle(
                                          fontFamily: "bm", fontSize: 30),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "지난 달성률 : ",
                                      style: TextStyle(
                                          fontFamily: "bm", fontSize: 20),
                                    ),
                                    Text(
                                      formatPercentage(_lastMonthPercentage),
                                      //"$_lastMonth%",
                                      style: const TextStyle(
                                          fontFamily: "bm", fontSize: 30),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: const m2_button(),
              ),
            ],
          ),
        ),
      ),
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
      titleTextStyle:
          TextStyle(fontFamily: 'bm', fontSize: 20, color: PRIMARY_COLOR),
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
      titleTextStyle:
          TextStyle(fontFamily: 'bm', fontSize: 20, color: PRIMARY_COLOR),
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
            decoration: const BoxDecoration(
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
  );
}
