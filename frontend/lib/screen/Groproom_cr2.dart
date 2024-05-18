import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<Map> fetchCreate(Map<String, dynamic> formData) async {
  final response = await http.post(
    Uri.parse(serverUrl + '/api/v1/room/create-group-room'),
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
      print('$responseData'); // log 찍는 걸로 차후에 변경하기
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

class Groproom_cr2 extends StatefulWidget {
  final String title;
  final String tag;
  final String category;
  final String comments;
  final String peoplesnum;
  final String password;

  const Groproom_cr2(
    this.title,
    this.tag,
    this.category,
    this.comments,
    this.peoplesnum,
    this.password, {
    Key? key,
  }) : super(key: key);

  @override
  State<Groproom_cr2> createState() => _Groproom_cr2State();
}

class _Groproom_cr2State extends State<Groproom_cr2>
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
  bool _ischat = false;

  List<String> checkList = [];
  bool _isEnabled = true;
  String? _selectedPeriod;
  List<TextEditingController> goalControllers = [];
  GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
    animationDuration: const Duration(milliseconds: 200),
  );

  int changeNum(String input) {
    String numbersString = input.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(numbersString) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    // 각 TextField의 컨트롤러를 초기화
    for (int i = 0; i < 6; i++) {
      goalControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var controller in goalControllers) {
      controller.dispose();
    }
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? count = int.tryParse(_selectcount.replaceAll(RegExp(r'[^0-9]'), ''));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: LIGHTGREY,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _globalKey,
            autovalidateMode: _autovalidateMode,
            child: Column(
              children: [
                // 목표기한
                _buildDatePickerButton(),
                const SizedBox(height: 20),
                // 목표기한 검증 메시지
                if (_selectedDate == null &&
                    _autovalidateMode == AutovalidateMode.always)
                  _buildValidationMessage('목표기한을 선택해주세요'),
                const SizedBox(height: 20),
                // 인증횟수 선택
                _buildDropdownRow(),
                const SizedBox(height: 20),
                // 중간목표 입력 필드
                _buildGoalTextFields(count),
                const SizedBox(height: 20),
                // 인증방식 선택
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
                      const Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: null,
                            activeColor: PRIMARY_COLOR,
                          ),
                          Text(
                            "방장 승인",
                            style: TextStyle(fontFamily: "bma", fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: null,
                            activeColor: PRIMARY_COLOR,
                          ),
                          Text(
                            "AI 인증",
                            style: TextStyle(fontFamily: "bma", fontSize: 20),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_peoplevote) _buildVoteOptions(),
                const SizedBox(height: 20),
                // 채팅 기능 활성화
                _buildChatSwitch(),
                const SizedBox(height: 15),
                // 이전, 다음 버튼
                _buildButtonRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
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
          '그룹 인증방 생성',
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontFamily: "bm",
            fontSize: 30,
          ),
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

  Widget _buildValidationMessage(String message) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }

  Widget _buildDropdownRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "중간목표",
          style: TextStyle(fontFamily: "bm", fontSize: 20),
        ),
        Container(
            child: _buildDropdownButton(_selectcount, count, (value) {
          setState(() {
            _selectcount = value!;
          });
        })),
      ],
    );
  }

  Widget _buildGoalTextFields(int? count) {
    return Column(
      children: List.generate(count ?? 0, (index) {
        return Column(
          children: [
            SizedBox(
              height: 48,
              child: TextFormField(
                enabled: _isEnabled,
                controller: goalControllers[index],
                keyboardType: TextInputType.text,
                scrollPadding: const EdgeInsets.all(8),
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "bma",
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: PRIMARY_COLOR),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  labelText: "중간 목표를 입력하십시오",
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(
                      color: POINT_COLOR, fontSize: 18, fontFamily: 'bm'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '중간 목표를 입력해주십시오';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      }),
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
                        child: _buildDropdownButton(_selectgoodvote, votes,
                            (value) {
                      setState(() {
                        _selectgoodvote = value!;
                      });
                    })),
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
                        child: _buildDropdownButton(_selectfailvote, votes,
                            (value) {
                      setState(() {
                        _selectfailvote = value!;
                      });
                    })),
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
          child: const Text(
            "이전",
            style: TextStyle(color: PRIMARY_COLOR),
          ),
        ),
        const SizedBox(width: 10),
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
            String _category = categoryMap[widget.category] ?? "ETC";
            String _period = periodMap[_selectedPeriod] ?? "DAILY";
            String certificationType = _peoplevote ? "BOTH" : "ADMIN";

            // Extract texts from controllers
            List<String> goals =
                goalControllers.map((controller) => controller.text).toList();

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
              "maxUser": widget.peoplesnum,
              "pwd": widget.password,
              "numOfGoal": _selectcount.replaceAll(RegExp(r'[^0-9]'), ''),
              "goal": goals,
            };

            if (!_globalKey.currentState!.validate() || _selectedDate == null) {
              setState(() {
                _autovalidateMode = AutovalidateMode.always;
              });
              return;
            }

            try {
              fetchCreate(formData);
              print("오케이");
              setState(() {
                _isEnabled = false;
                _autovalidateMode = AutovalidateMode.always;
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => mainPage()),
              );
            } catch (e) {
              setState(() {
                _isEnabled = false;
              });
              print("에러$e");
              print("$formData");
            }
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
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
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
          items: items.map((value) {
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
}
