import 'dart:convert';
import 'dart:developer';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main2_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

Future<UserData> fetchUserData() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/report/me'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    log('Main title: Connected!: ${utf8.decode(response.bodyBytes)}');
    return UserData.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Main title: fail to connect');
  }
}

class UserData {
  final double lastMonth;
  final double thisMonth;
  final Map<String, int> categorySize;
  final int allCategorySize;
  final double mostActivity;

  UserData({
    required this.lastMonth,
    required this.thisMonth,
    required this.categorySize,
    required this.allCategorySize,
    required this.mostActivity,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      lastMonth: _toDouble(json['lastMonth']),
      thisMonth: _toDouble(json['thisMonth']),
      categorySize: Map<String, int>.from(json['categorySize'] ?? {}),
      allCategorySize: json['allCategorySize'] ?? 0,
      mostActivity: _toDouble(json['mostActivity']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }
}

class reportPage extends StatefulWidget {
  const reportPage({super.key});

  @override
  State<reportPage> createState() => _reportPageState();
}

class _reportPageState extends State<reportPage> {
  Future<UserData>? myUserData;

  @override
  void initState() {
    super.initState();
    myUserData = fetchUserData();
  }

  List<Widget> buildTopCategories(UserData data) {
    Map<String, String> categoryMap = {
      "EXERCISE": "운동",
      "GYM": "헬스",
      "RISE": "기상",
      "STUDY": "학습",
      "DIET": "식단",
      "ETC": "기타",
      "WAKEUP": "기상",
    };

    var sortedCategories = data.categorySize.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var topCategories = sortedCategories.take(3).toList();

    double screenWidth = MediaQuery.of(context).size.width;
    double textSize = screenWidth * 0.05;
    textSize = textSize.clamp(12.0, 24.0);

    return topCategories.asMap().entries.map((entry) {
      int index = entry.key + 1;
      var category = entry.value;
      double percentage = (category.value / data.allCategorySize * 100);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "$index. ${categoryMap[category.key] ?? category.key}",
                style: TextStyle(
                    color: PRIMARY_COLOR, fontSize: textSize, fontFamily: 'bm'),
              ),
              SizedBox(
                width: screenWidth * 0.02,
              ),
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: TextStyle(
                    color: PRIMARY_COLOR, fontSize: textSize, fontFamily: 'bm'),
              ),
            ],
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String reportMonth = "${now.month == 1 ? 12 : now.month - 1}월 REPORT";

    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  reportMonth,
                  style: const TextStyle(fontFamily: "bm", fontSize: 35),
                ),
              ),
              FutureBuilder<UserData>(
                future: myUserData,
                builder: (context, snapshot) {
                  Widget errorWidget = Column(
                    children: const [
                      Text(
                        "서버 연결 실패",
                        style: TextStyle(
                          fontFamily: "kcc",
                          fontSize: 20,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  );

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    log("Main title: Error - ${snapshot.error.toString()}");
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "도도",
                            style: TextStyle(
                              fontFamily: "bm",
                              fontSize: 25,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        errorWidget,
                      ],
                    );
                  } else if (snapshot.hasData) {
                    UserData data = snapshot.data!;

                    // 데이터 검증
                    double thisMonthPercent =
                        (data.thisMonth >= 0 && data.thisMonth <= 100)
                            ? data.thisMonth / 100
                            : 0.0;
                    double mostActivityPercent =
                        (data.mostActivity >= 0 && data.mostActivity <= 100)
                            ? data.mostActivity / 100
                            : 0.0;
                    double mostActivity =
                        (data.mostActivity >= 0 && data.mostActivity <= 100)
                            ? data.mostActivity
                            : 0.0;

                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "도도",
                            style: TextStyle(
                              fontFamily: "bm",
                              fontSize: 25,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // First, achievement rate
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 5.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "이번달 달성률은",
                                    style: TextStyle(
                                      fontFamily: "bm",
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${data.thisMonth.toStringAsFixed(0)}%",
                                      style: const TextStyle(
                                        fontFamily: "bm",
                                        fontSize: 50,
                                        color: PRIMARY_COLOR,
                                      ),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "예요",
                                        style: TextStyle(
                                          fontFamily: "bm",
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                LinearPercentIndicator(
                                  animation: true,
                                  animationDuration: 100,
                                  lineHeight: 30,
                                  percent: 0.78, //thisMonthPercent,
                                  progressColor: PRIMARY_COLOR,
                                  barRadius: const Radius.circular(20),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Second, better rate
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "지난달 달성률은 ${data.lastMonth.toStringAsFixed(0)}%예요\n이번달 ${(data.thisMonth - data.lastMonth).toStringAsFixed(0)}% 더 높아요",
                                  style: const TextStyle(
                                    fontFamily: "bm",
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 200,
                                child: BarChartSample(
                                  lastMonth: data.lastMonth,
                                  thisMonth: data.thisMonth,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Third, category
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 5.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "제일 열심히 한 분야는",
                                    style: TextStyle(
                                      fontFamily: "bm",
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible:
                                          MediaQuery.of(context).size.width >
                                              320,
                                      child: Icon(
                                        Icons.flag,
                                        color: PRIMARY_COLOR,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: buildTopCategories(data),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        // Fourth, most active
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 5.0,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    "가장 많이 활동한 방에서 나는",
                                    style: TextStyle(
                                      fontFamily: "bm",
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    "상위 ${mostActivity.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      fontFamily: "bm",
                                      fontSize: 40,
                                      color: PRIMARY_COLOR,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.eco_rounded,
                                  color: POINT_COLOR,
                                  size: 100,
                                ),
                                LinearPercentIndicator(
                                  animation: true,
                                  animationDuration: 100,
                                  lineHeight: 30,
                                  percent: 0.15, //mostActivityPercent,
                                  progressColor: PRIMARY_COLOR,
                                  barRadius: const Radius.circular(20),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const main2Page(),
                                ),
                              );
                            },
                            child: const Text(
                              "확인",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'bm',
                                fontSize: 20,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('잠시후 시도해주십시오');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarChartSample extends StatelessWidget {
  final double lastMonth;
  final double thisMonth;

  BarChartSample({required this.lastMonth, required this.thisMonth});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              margin: 20,
              getTitles: (double value) {
                switch (value.toInt()) {
                  case 0:
                    return '지난달';
                  case 1:
                    return '이번달';
                  default:
                    return '';
                }
              },
            ),
            leftTitles: SideTitles(showTitles: false),
          ),
          borderData: FlBorderData(show: false),
          barGroups: thisMonth == lastMonth
              ? [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        y: lastMonth + 10,
                        colors: [Colors.grey],
                        width: 40,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        y: thisMonth + 10,
                        colors: [Colors.grey],
                        width: 40,
                      ),
                    ],
                  ),
                ]
              : thisMonth > lastMonth
                  ? [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            y: 60,
                            colors: [Colors.grey],
                            width: 40,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            y: 80,
                            colors: [PRIMARY_COLOR],
                            width: 40,
                          ),
                        ],
                      ),
                    ]
                  : [
                      BarChartGroupData(
                        x: 0,
                        barRods: [
                          BarChartRodData(
                            y: 80,
                            colors: [PRIMARY_COLOR],
                            width: 40,
                          ),
                        ],
                      ),
                      BarChartGroupData(
                        x: 1,
                        barRods: [
                          BarChartRodData(
                            y: 60,
                            colors: [Colors.grey],
                            width: 40,
                          ),
                        ],
                      ),
                    ],
        ),
      ),
    );
  }
}
