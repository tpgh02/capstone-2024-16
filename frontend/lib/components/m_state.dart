import 'dart:convert';
import 'dart:developer';

import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//main 화면에서 상태 멘트를 날려주는 컴포넌트
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

Future<List<calendarData>> fetchcalendarData(String roomId) async {
  final response = await http
      .get(Uri.parse('${serverUrl}/api/v1/report/simple/${roomId}'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  log('서버 : ${serverUrl}/api/v1/report/simple/${roomId}');
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData =
        jsonDecode(utf8.decode(response.bodyBytes));
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

List<DateTime> getWeekDates(DateTime currentDate) {
  int currentWeekday = currentDate.weekday;
  DateTime mondayDate =
      currentDate.subtract(Duration(days: currentWeekday - 1));
  List<DateTime> weekDates = [];
  for (int i = 0; i < 7; i++) {
    weekDates.add(mondayDate.add(Duration(days: i)));
  }

  return weekDates;
}

class m_state extends StatefulWidget {
  final state;
  const m_state(this.state);

  @override
  State<m_state> createState() => _m_stateState();
}

class _m_stateState extends State<m_state> {
  DateTime currentDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    int currentWeekday = currentDate.weekday;
    DateTime mondayDate =
        currentDate.subtract(Duration(days: currentWeekday - 1));
    List<int> weekDates = [];
    for (int i = 0; i < 7; i++) {
      weekDates.add(mondayDate.add(Duration(days: i)).day);
    }
    log("date : ${weekDates}");
    const TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 25);
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              minimumSize: const Size(500, 100),
              elevation: 5, //그림자
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
                        for (int i = 0; i < widget.state.length; i++)
                          Container(
                            margin: const EdgeInsets.all(10),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.state[i] == 0
                                  ? Colors.grey[400]
                                  : Colors.white,
                            ),
                            child: Center(
                              child: widget.state[i] == 0
                                  ? Text(
                                      weekDates[i].toString(),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'kcc',
                                          color: Colors.black38),
                                    )
                                  : Image.asset(
                                      'assets/images/turtle.png', // 이미지 파일 경로
                                      width: 22,
                                      height: 22,
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

//방 가입시 나오는 팝업창(테스트 용도로 제작)
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
              style: TextStyle(fontFamily: "bma", fontSize: 20),
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
      ));
    },
  );
}
