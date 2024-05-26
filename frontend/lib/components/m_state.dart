import 'dart:convert';
import 'dart:developer';

import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dodo/token_storage.dart'; // 추가된 부분

class CalendarData {
  final String date;
  final bool flag;

  CalendarData({
    required this.date,
    required this.flag,
  });

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      date: json['date'] ?? "", // 기본값으로 빈 문자열을 사용할 수 있습니다.
      flag: json['flag'] ?? false, // 기본값으로 false를 사용할 수 있습니다.
    );
  }
}

Future<List<CalendarData>> fetchCalendarData(String roomId) async {
  final tokenStorage = TokenStorage(); // TokenStorage 인스턴스 생성
  final token = await tokenStorage.getToken(); // 토큰 가져오기

  final response = await http.get(
    Uri.parse('$serverUrl/api/v1/report/weekly-goal'),
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU', //$token',
    },
  );
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(utf8.decode(response.bodyBytes));

    // 데이터가 List<dynamic>인지 확인하고 예외 처리합니다.
    if (jsonData is List<dynamic>) {
      List<CalendarData> calendarDatas =
          jsonData.map((json) => CalendarData.fromJson(json)).toList();
      log("m_state fetch data: $jsonData");
      return calendarDatas;
    } else {
      throw Exception('Data format is not as expected');
    }
  } else {
    log("that is no");
    throw Exception('Failed to load calendarData data');
  }
}

class m_state extends StatefulWidget {
  const m_state({Key? key}) : super(key: key);

  @override
  State<m_state> createState() => _m_stateState();
}

class _m_stateState extends State<m_state> {
  late Future<List<CalendarData>> _futureCalendarData;

  @override
  void initState() {
    super.initState();
    _futureCalendarData = fetchCalendarData('roomId');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CalendarData>>(
      future: _futureCalendarData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          //return Text('Error: ${snapshot.error}');
          return errorContent(snapshot.error.toString());
        } else {
          return buildContent(snapshot.data!);
        }
      },
    );
  }

  Widget buildContent(List<CalendarData> calendarData) {
    DateTime currentDate = DateTime.now();
    int currentWeekday = currentDate.weekday;
    DateTime mondayDate =
        currentDate.subtract(Duration(days: currentWeekday - 1));
    List<int> weekDates = [];
    for (int i = 0; i < 7; i++) {
      weekDates.add(mondayDate.add(Duration(days: i)).day);
    }
    // log("date : $weekDates");
    const TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 25);
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              minimumSize: const Size(500, 100),
              elevation: 5, // 그림자
            ),
            onPressed: () {
              statedialog(context, 70);
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: const Text(
                    "주간목표",
                    style: style,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < calendarData.length; i++)
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: calendarData[i].flag
                                  ? Colors.white
                                  : Colors.grey[400],
                            ),
                            child: Center(
                              child: calendarData[i].flag
                                  ? Image.asset(
                                      'assets/images/turtle.png',
                                      width: 22,
                                      height: 22,
                                    )
                                  : Text(
                                      weekDates[i].toString(),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'kcc',
                                        color: Colors.black38,
                                      ),
                                    ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget errorContent(String state) {
  DateTime currentDate = DateTime.now();
  int currentWeekday = currentDate.weekday;
  DateTime mondayDate =
      currentDate.subtract(Duration(days: currentWeekday - 1));
  List<int> weekDates = [];
  for (int i = 0; i < 7; i++) {
    weekDates.add(mondayDate.add(Duration(days: i)).day);
  }
  // log("date : $weekDates");
  const TextStyle style =
      TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 25);
  return Column(
    children: [
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            minimumSize: const Size(500, 100),
            elevation: 5, // 그림자
          ),
          onPressed: () {},
          child: Column(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: const Text(
                  "주간목표",
                  style: style,
                ),
              ),
              Text(
                "에러가 발생하였습니다. 잠시후 시도해주십시오",
                style: const TextStyle(
                  fontFamily: 'bma',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

void statedialog(context, state) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          margin: EdgeInsets.all(10),
          width: 400,
          height: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              const Text(
                "가입이 승인되었습니다",
                style: TextStyle(fontFamily: "bm", fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              Image.asset(
                "assets/images/turtle.png",
                scale: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "대단해요!",
                style: TextStyle(fontFamily: "bma", fontSize: 20),
              ),
              const Text(
                "앞으로도 멋진 모습 기대할게요!",
                style: TextStyle(fontFamily: "bma", fontSize: 16),
              ),
              const SizedBox(
                height: 15,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close),
              )
            ],
          ),
        ),
      );
    },
  );
}
