import 'dart:convert';

import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' hide VoidCallback;
import 'package:http/http.dart' as http;

Future<Map> fetchBuy(Map<String, dynamic> userData) async {
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  };
  final response =
      await http.post(Uri.parse(serverUrl + '/api/v1/room/create-ai-room'));
  response.headers.addAll(headers);
  try {
    if (response.statusCode == 200) {
      print('연결 성공!');

      Map responseData = json.decode(response.body);
      print('$responseData'); //log 찍는 걸로 차후에 변경하기
      return responseData;
    } else {
      // 에러가 있는 경우 처리
      throw Exception('인증방 생성이 실패했습니다. 잠시 후 시도해주십시오');
    }
  } catch (e) {
    print('네트워크 오류: $e');
    throw Exception('네트워크 오류가 발생했습니다');
  }
}

class Room_cr2 extends StatefulWidget {
  final String title;
  final String tag;
  final String category;
  final String comments;
  final String peoplesnum;
  final String password;

  const Room_cr2(this.title, this.tag, this.category, this.comments,
      this.peoplesnum, this.password,
      {super.key});

  @override
  State<Room_cr2> createState() => _Room_cr2State();
}

class _Room_cr2State extends State<Room_cr2>
    with SingleTickerProviderStateMixin {
  DateTime? _selectedDate;
  List count = [
    '1회',
    '2회',
    '3회',
    '4회',
    '5회',
    '6회',
  ];
  List method = ['매일', '매주'];
  List votes = ['1표', '2표', '3표', '4표', '5표', '6표', '7표', '8표', '9표', '10표'];
  Object? _selectcount = '1회';
  Object? _selectgoodvote = '1표';
  Object? _selectfailvote = '1표';
  bool _peoplevote = false;
  bool _captinevote = false;
  bool _ischat = false;
  List<String> checkList = [];

  late TabController tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 200),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHTGREY,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            width: 390,
            height: 80,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  color: Color(0x7F414C58),
                ),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
            child: const Text(
              '일반 인증방 생성',
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontFamily: "bm",
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              //목표기한
              Container(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime.now(), //DateTime(2024),
                      lastDate: DateTime(2025), //DateTime.now(),
                    ).then((selectedDate) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    });
                  },
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: PRIMARY_COLOR),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: PRIMARY_COLOR,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                          _selectedDate != null
                              ? _selectedDate.toString().split(" ")[0]
                              : "목표기한",
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              //매일 또는 매주 선택
              Container(
                child: _tabBar(),
              ),
              const SizedBox(
                height: 20,
              ),
              //인증횟수 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "인증횟수",
                    style: TextStyle(fontFamily: "bm", fontSize: 20),
                  ),
                  Container(child: count_dd()),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text(
                    "인증방식",
                    style: TextStyle(fontFamily: "bm", fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "(다중 선택 가능)",
                    style: TextStyle(fontFamily: "bma", fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _peoplevote,
                          onChanged: (value) {
                            setState(() {
                              _peoplevote = value!;
                            });
                          },
                          activeColor: PRIMARY_COLOR,
                        ),
                        const Text(
                          "구성원 투표",
                          style: TextStyle(fontFamily: "bma", fontSize: 20),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Checkbox(
                          value: _captinevote,
                          onChanged: (value) {
                            setState(() {
                              _captinevote = value!;
                            });
                          },
                          activeColor: PRIMARY_COLOR,
                        ),
                        const Text(
                          "방장 승인",
                          style: TextStyle(fontFamily: "bma", fontSize: 20),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Checkbox(
                          value: false,
                          onChanged: null,
                          activeColor: PRIMARY_COLOR,
                        ),
                        const Text(
                          "AI 인증",
                          style: TextStyle(fontFamily: "bma", fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "구성원 투표 최소 투표율",
                  style: TextStyle(fontFamily: "bm", fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "인증",
                        style: TextStyle(fontFamily: "bm", fontSize: 20),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(child: vote_gdd()),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        "실패",
                        style: TextStyle(fontFamily: "bm", fontSize: 20),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(child: vote_fdd()),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "채팅 기능 활성화하기",
                    style: TextStyle(fontFamily: "bm", fontSize: 20),
                  ),
                  CupertinoSwitch(
                    value: _ischat,
                    trackColor: DARKGREY,
                    activeColor: PRIMARY_COLOR,
                    onChanged: (bool? value) {
                      setState(() {
                        _ischat = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              //이전, 다음 버튼
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 2,
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black,
                        side: const BorderSide(color: PRIMARY_COLOR),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("이전",
                        style: TextStyle(color: PRIMARY_COLOR)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Map<String, String> categoryMap = {
                        "운동": "EXERCISE",
                        "헬스": "GYM",
                        "기상": "RISE",
                        "학습": "STUDY",
                        "식단": "DIET",
                        "기타": "ETC"
                      };
                      String category = "운동";
                      String _category = categoryMap[category] ?? "ETC";
                      Map<String, dynamic> formData = {
                        "name": widget.title,
                        "category": _category,
                        "info": widget.comments,
                        "certificationType": _peoplevote ? "VOTE" : null,
                        "canChat": _ischat,
                        "numOfVoteSuccess": _selectgoodvote
                            .toString()
                            .replaceAll(RegExp(r'[^0-9]'), ''),
                        "numOfVoteFail": _selectfailvote
                            .toString()
                            .replaceAll(RegExp(r'[^0-9]'), ''),
                        "frequency": "7",
                        "endDay": _selectedDate.toString() + "T00:00:00",
                        "periodicity": "daily",
                        "tag": widget.tag.toString().split(" "),
                        "maxUser": widget.peoplesnum //숫자로 변환하기
                      };
                      fetchBuy(formData).then((data) {
                        print("오케이");
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => buyPage(img, name)));
                      }).catchError((error) {
                        print("에러$error");
                        print("$formData");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        elevation: 2,
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black,
                        side: BorderSide(color: PRIMARY_COLOR),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "생성",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget _tabBar() {
    return TabBar(
      overlayColor: MaterialStatePropertyAll(Colors.blue.shade100),
      splashBorderRadius: BorderRadius.circular(20),
      controller: tabController,
      tabs: method.map(
        (value) {
          return DropdownMenuItem(
            value: value,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                value,
                style: const TextStyle(fontFamily: 'bm', fontSize: 20),
              ),
            ),
          );
        },
      ).toList(),
      labelColor: PRIMARY_COLOR,
      indicatorColor: PRIMARY_COLOR,
    );
  }

  Widget count_dd() {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          value: _selectcount,
          underline: const SizedBox.shrink(),
          focusColor: LIGHTGREY,
          iconEnabledColor: PRIMARY_COLOR,
          icon: const Icon(Icons.arrow_drop_down),
          items: count.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value,
                    style: const TextStyle(fontFamily: 'bm', fontSize: 20),
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              _selectcount = value;
            });
          },
        ),
      ),
    );
  }

  Widget vote_gdd() {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          value: _selectgoodvote,
          underline: const SizedBox.shrink(),
          focusColor: LIGHTGREY,
          iconEnabledColor: PRIMARY_COLOR,
          icon: const Icon(Icons.arrow_drop_down),
          items: votes.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value,
                    style: const TextStyle(fontFamily: 'bm', fontSize: 20),
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              _selectgoodvote = value;
            });
          },
        ),
      ),
    );
  }

  Widget vote_fdd() {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          value: _selectfailvote,
          underline: const SizedBox.shrink(),
          focusColor: LIGHTGREY,
          iconEnabledColor: PRIMARY_COLOR,
          icon: const Icon(Icons.arrow_drop_down),
          items: votes.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value,
                    style: const TextStyle(fontFamily: 'bm', fontSize: 20),
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              _selectfailvote = value;
            });
          },
        ),
      ),
    );
  }
}
