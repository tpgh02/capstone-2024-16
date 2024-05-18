import 'dart:convert';

import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map> fetchCreate(Map<String, dynamic> userData) async {
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
    'Content-Type': 'application/json',
  };
  final response = await http.post(
    Uri.parse(serverUrl + '/api/v1/room/create-ai-room'),
    headers: headers,
    body: jsonEncode(userData),
  );

  print('Request URL: ${serverUrl + '/api/v1/room/create-ai-room'}');
  print('Request Headers: $headers');
  print('Request Body: ${jsonEncode(userData)}');

  try {
    if (response.statusCode == 200) {
      print('연결 성공!');
      Map responseData = json.decode(response.body);
      print('Response Data: $responseData'); // log 찍는 걸로 차후에 변경하기
      return responseData;
    } else {
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
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
  List<String> count = [
    '1회',
    '2회',
    '3회',
    '4회',
    '5회',
    '6회',
  ];
  List<String> method = ['매일', '매주'];
  List<String> votes = [
    '1표',
    '2표',
    '3표',
    '4표',
    '5표',
    '6표',
    '7표',
    '8표',
    '9표',
    '10표'
  ];
  String _selectcount = '1회';
  String _selectgoodvote = '1표';
  String _selectfailvote = '1표';
  bool _peoplevote = false;
  bool _captinevote = false;
  bool _ischat = false;
  String? _selectedPeriod;
  List<String> checkList = [];
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  late TabController tabController = TabController(
    length: method.length,
    vsync: this,
    initialIndex: 0,
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
        child: Form(
          key: _globalKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: [
              // 목표기한
              Container(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2025),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: PRIMARY_COLOR,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedDate != null
                            ? _selectedDate.toString().split(" ")[0]
                            : "목표기한을 선택해주세요",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // 목표기한 검증 메시지
              if (_selectedDate == null &&
                  _autovalidateMode == AutovalidateMode.always)
                _buildValidationMessage('목표기한을 선택해주세요'),

              // 매일 또는 매주 선택
              Container(child: _tabBar()),
              const SizedBox(height: 20),
              // 인증횟수 선택
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
              const SizedBox(height: 15),
              _buildCertificationOptions(),

              if (_peoplevote)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildVoteOptions(),
                  ],
                ),
              const SizedBox(height: 15),
              _buildChatSwitch(),
              const SizedBox(height: 15),
              // 이전, 다음 버튼
              _buildButtonRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationMessage(String message) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _buildDropdownButton(
    String currentValue,
    List<String> items,
    ValueChanged<String?>? onChanged,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: PRIMARY_COLOR, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton<String>(
          value: currentValue,
          underline: const SizedBox.shrink(),
          focusColor: LIGHTGREY,
          iconEnabledColor: PRIMARY_COLOR,
          icon: const Icon(Icons.arrow_drop_down),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  value,
                  style: const TextStyle(fontFamily: 'bm', fontSize: 20),
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDatePickerButton() {
    return Container(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(2025),
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
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: PRIMARY_COLOR,
            ),
            const SizedBox(width: 10),
            Text(
              _selectedDate != null
                  ? _selectedDate.toString().split(" ")[0]
                  : "목표기한을 선택해주세요",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
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
        indicatorColor: PRIMARY_COLOR);
  }

  Widget _buildCertificationOptions() {
    return Row(
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
              const SizedBox(width: 15),
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
              const SizedBox(width: 15),
              const Checkbox(
                value: false,
                onChanged: null,
                activeColor: PRIMARY_COLOR,
              ),
              const Text(
                "AI 인증",
                style: TextStyle(fontFamily: "bma", fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoteOptions() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              "구성원 투표 최소 투표 수",
              style: TextStyle(fontFamily: "bm", fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              spacing: 5,
              runSpacing: 5,
              children: [
                Row(
                  children: [
                    const Text(
                      "인증",
                      style: TextStyle(fontFamily: "bm", fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      child:
                          _buildDropdownButton(_selectgoodvote, votes, (value) {
                        setState(() {
                          _selectgoodvote = value!;
                        });
                      }),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      "실패",
                      style: TextStyle(fontFamily: "bm", fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      child:
                          _buildDropdownButton(_selectfailvote, votes, (value) {
                        setState(() {
                          _selectfailvote = value!;
                        });
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatSwitch() {
    return Row(
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
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    return Row(
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
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("이전", style: TextStyle(color: PRIMARY_COLOR)),
        ),
        const SizedBox(width: 10),
        OutlinedButton(
          onPressed: () {
            if (_selectedDate == null) {
              setState(() {
                _autovalidateMode = AutovalidateMode.always;
              });
              return;
            }

            if (!_peoplevote && !_captinevote) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('오류'),
                  content: Text('인증 방식을 최소 하나 이상 선택해주십시오'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
              return;
            }

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
            String _category = categoryMap[widget.category] ?? "ETC";
            String _period = periodMap[_selectedPeriod] ?? "DAILY";
            String certificationType;
            if (_peoplevote && _captinevote) {
              certificationType = "BOTH";
            } else if (_peoplevote) {
              certificationType = "VOTE";
            } else if (_captinevote) {
              certificationType = "ADMIN";
            } else {
              certificationType = "";
            }
            Map<String, dynamic> formData = {
              "name": widget.title,
              "category": _category,
              "info": widget.comments,
              "certificationType": certificationType,
              "canChat": _ischat.toString(),
              "numOfVoteSuccess":
                  _selectgoodvote.replaceAll(RegExp(r'[^0-9]'), ''),
              "numOfVoteFail":
                  _selectfailvote.replaceAll(RegExp(r'[^0-9]'), ''),
              "frequency": _selectcount.replaceAll(RegExp(r'[^0-9]'), ''),
              "periodicity": _period,
              "endDay": _selectedDate != null
                  ? _selectedDate.toString().split(" ")[0] + "T00:00:00"
                  : "",
              "tag": widget.tag.split(" "),
              "maxUser": int.parse(widget.peoplesnum), // Convert to int
              "pwd": widget.password,
              "roomType": "NORMAL" // Added roomType as per your data structure
            };

            if (!_globalKey.currentState!.validate()) {
              setState(() {
                _autovalidateMode = AutovalidateMode.always;
              });
              return;
            }

            fetchCreate(formData).then((data) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mainPage()),
              );
            }).catchError((error) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('오류'),
                  content: Text('인증방 생성이 실패했습니다. 잠시 후 시도해주십시오'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: PRIMARY_COLOR,
            elevation: 2,
            foregroundColor: Colors.black,
            shadowColor: Colors.black,
            side: const BorderSide(color: PRIMARY_COLOR),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "생성",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
