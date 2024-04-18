import 'package:dodo/components/m2_board.dart';
import 'package:dodo/components/m2_button.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/main2_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class reportPage extends StatefulWidget {
  const reportPage({super.key});

  @override
  State<reportPage> createState() => _reportPageState();
}

class _reportPageState extends State<reportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "3월 REPORT",
                    style: TextStyle(fontFamily: "bm", fontSize: 35),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    "Username",
                    style: TextStyle(
                        fontFamily: "bm", fontSize: 25, color: PRIMARY_COLOR),
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
                              offset: Offset(0, 3))
                        ]),
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "이번달 달성률은",
                                style:
                                    TextStyle(fontFamily: "bm", fontSize: 25),
                              ),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "82%",
                                  style: TextStyle(
                                    fontFamily: "bm",
                                    fontSize: 50,
                                    color: PRIMARY_COLOR,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "예요",
                                    style: TextStyle(
                                        fontFamily: "bm", fontSize: 25),
                                  ),
                                ),
                              ],
                            ),
                            LinearPercentIndicator(
                              //width: 200,

                              animation: true,
                              animationDuration: 100,
                              lineHeight: 30,
                              percent: 0.82,
                              //center: Text("20"),
                              progressColor: PRIMARY_COLOR,
                              barRadius: Radius.circular(20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ))),
                // Second, better rate
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "누적 평균 달성률은 76%예요\n이번달 6% 더 높아요",
                          style: TextStyle(fontFamily: "bm", fontSize: 25),
                        ),
                      ),
                      const Text(
                        "굉장히 험난할 예정일 차트가 들어설 겁니다.",
                        style: TextStyle(fontFamily: "bm", fontSize: 15),
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
                            offset: Offset(0, 3))
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "제일 열심히 한 분야는",
                            style: TextStyle(fontFamily: "bm", fontSize: 25),
                          ),
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.flag,
                              color: PRIMARY_COLOR,
                              size: 150,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "1. 운동",
                                      style: TextStyle(
                                          color: PRIMARY_COLOR,
                                          fontSize: 40,
                                          fontFamily: 'bm'),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      "72%",
                                      style: TextStyle(
                                          color: PRIMARY_COLOR,
                                          fontSize: 40,
                                          fontFamily: 'bm'),
                                    ),
                                  ],
                                ),
                                Text(
                                  "2. 기상 23%",
                                  style: TextStyle(
                                      color: POINT_COLOR,
                                      fontSize: 20,
                                      fontFamily: 'bm'),
                                ),
                                Text(
                                  "3. 기타 5%",
                                  style: TextStyle(
                                      color: POINT_COLOR,
                                      fontSize: 20,
                                      fontFamily: 'bm'),
                                )
                              ],
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
                //Fourth, most active
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            spreadRadius: 0,
                            blurRadius: 5.0,
                            offset: Offset(0, 3))
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "가장 많이 활동한 방에서 나는",
                            style: TextStyle(fontFamily: "bm", fontSize: 25),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "상위 15%",
                            style: TextStyle(
                              fontFamily: "bm",
                              fontSize: 40,
                              color: PRIMARY_COLOR,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.eco_rounded,
                          color: POINT_COLOR,
                          size: 100,
                        ),
                        LinearPercentIndicator(
                          //width: 200,

                          animation: true,
                          animationDuration: 100,
                          lineHeight: 30,
                          percent: 0.75,
                          //center: Text("20"),
                          progressColor: PRIMARY_COLOR,
                          barRadius: Radius.circular(20),
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
                                builder: (context) => main2Page()));
                      },
                      child: Text(
                        "이미지로 다운받기",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'bm',
                            fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                    )),
              ],
            )),
      ),
    );
  }
}
