import 'dart:convert';
import 'dart:core';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:dodo/screen/roomlist_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<Map> fetchCreate(Map<String, dynamic> formData) async {
  final response = await http.post(
    Uri.parse(serverUrl + '/api/v1/room/create-ai-room'),
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(formData),
  );
  try {
    if (response.statusCode == 200) {
      print('연결 성공!');

      Map responseData = jsonDecode(utf8.decode(response.bodyBytes));
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

class AIroom_cr3 extends StatefulWidget {
  final String title;
  final String tag;
  final String category;
  final String comments;
  final String peoplesnum;
  final String password;
  final bool _isAI;

  const AIroom_cr3(
    this.title,
    this.tag,
    this.category,
    this.comments,
    this.peoplesnum,
    this.password,
    this._isAI, {
    Key? key,
  }) : super(key: key);

  @override
  State<AIroom_cr3> createState() => _AIroom_cr3State();
}

class _AIroom_cr3State extends State<AIroom_cr3>
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
  String _selectcount = '1회';
  String _selectgoodvote = '1표';
  String _selectfailvote = '1표';
  bool _peoplevote = false;
  bool _ischat = false;
  bool _ispick = false;
  List<String> checkList = [];
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _selectedPeriod;

  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 200),
  );
  int changeNum(String input) {
    String numbersString = input.toString().replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numbersString) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: method.length, vsync: this);
    tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _selectedPeriod = method[tabController.index];
    });
  }

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
              'AI 인증방 생성',
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontFamily: "bm",
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                            style: TextStyle(fontSize: 18)),
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
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    alignment: WrapAlignment.start,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _peoplevote,
                            onChanged: (value) {
                              setState(() {
                                _peoplevote = value!;
                                print(_peoplevote);
                              });
                            },
                            activeColor: PRIMARY_COLOR,
                          ),
                          const Text(
                            "구성원 투표",
                            style: TextStyle(fontFamily: "bma", fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          const Checkbox(
                            value: true,
                            onChanged: null,
                            activeColor: PRIMARY_COLOR,
                          ),
                          const Text(
                            "방장 승인",
                            style: TextStyle(fontFamily: "bma", fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Row(
                        children: [
                          const Checkbox(
                            value: true,
                            onChanged: null,
                            activeColor: PRIMARY_COLOR,
                          ),
                          const Text(
                            "AI 인증",
                            style: TextStyle(fontFamily: "bma", fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                _peoplevote
                    ? Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "구성원 투표 최소 투표 수",
                                style:
                                    TextStyle(fontFamily: "bm", fontSize: 20),
                              ),
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.spaceBetween,
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "인증",
                                      style: TextStyle(
                                          fontFamily: "bm", fontSize: 20),
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
                                      style: TextStyle(
                                          fontFamily: "bm", fontSize: 20),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(child: vote_fdd()),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
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
                if (widget._isAI)
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: OutlinedButton(
                      onPressed: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          initialEntryMode: TimePickerEntryMode.input,
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _ispick = true;
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: const BorderSide(color: PRIMARY_COLOR),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.access_time),
                          SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격 조절
                          Text(
                            _ispick
                                ? _selectedTime.format(context)
                                : '인증 시간 설정',
                            style: TextStyle(fontFamily: "bm", fontSize: 20),
                          ),
                        ],
                      ),
                    ),
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
                          "기상": "WAKEUP",
                          "학습": "STUDY",
                          "식단": "DIET",
                          "기타": "ETC"
                        };
                        Map<String, String> periodMap = {
                          "매일": "DAILY",
                          "매주": "WEEKLY",
                        };
                        String _category =
                            categoryMap[widget.category] ?? "ETC";
                        String _period = periodMap[_selectedPeriod] ?? "DAILY";
                        String certificationType =
                            _peoplevote ? "BOTH" : "ADMIN";
                        print(certificationType);
                        Map<String, dynamic> formData = {
                          "name": widget.title.toString(),
                          "category": _category,
                          "info": widget.comments.toString(),
                          "certificationType": certificationType,
                          "canChat": _ischat.toString(),
                          "numOfVoteSuccess": _selectgoodvote.replaceAll(
                              RegExp(r'[^0-9]'),
                              ''), //changeNum(_selectgoodvote).toString(),
                          "numOfVoteFail": _selectfailvote.replaceAll(
                              RegExp(r'[^0-9]'),
                              ''), //changeNum(_selectfailvote),
                          "frequency": _selectcount.replaceAll(
                              RegExp(r'[^0-9]'), ''), //changeNum(_selectcount),
                          "periodicity": _period,
                          "endDay": _selectedDate.toString().split(" ")[0] +
                              "T00:00:00",
                          "tag": widget.tag.toString().split(" "),
                          "maxUser":
                              widget.peoplesnum, //changeNum(widget.peoplesnum),
                          "pwd": widget.password
                        };
                        fetchCreate(formData).then((data) {
                          print("오케이");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => mainPage()));
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
              _selectcount = value.toString();
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
              _selectgoodvote = value.toString();
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
              _selectfailvote = value.toString();
            });
          },
        ),
      ),
    );
  }
}
