import 'dart:developer';
import 'dart:convert';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;

// 인증방 속성 변경
Future<String> fetchRoomInfo(Map<String, dynamic> form, int roomId) async {
  var url = '$serverUrl/api/v1/room/update?roomId=$roomId';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
    },
    body: jsonEncode(form),
  );
  try {
    if (response.statusCode == 200) {
      var responseData = utf8.decode(response.bodyBytes);
      log('인증방 수정 성공: $responseData');
      return responseData;
    } else {
      log('인증방 수정 실패: ${response.body}');
      throw Exception('인증방 수정을 실패하였습니다.');
    }
  } catch (e) {
    log(response.body);
    log('$e');
    throw Exception('네트워크 오류가 발생했습니다.');
  }
}

// 인증방 비밀번호 변경
Future<String> fetchRoomPwd(Map<String, String> form, int roomId) async {
  var url = '$serverUrl/api/v1/room/change-pwd/$roomId';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
    },
    body: jsonEncode(form),
  );
  try {
    if (response.statusCode == 200) {
      var responseData = utf8.decode(response.bodyBytes);
      log('인증방 비밀번호 수정 성공: $responseData');
      return responseData;
    } else {
      log('인증방 비밀번호 수정 실패: ${response.body}');
      throw Exception('인증방 수정을 실패하였습니다.');
    }
  } catch (e) {
    log(response.body);
    log('$e');
    throw Exception('네트워크 오류가 발생했습니다.');
  }
}

class RoomSetting_Manager extends StatefulWidget {
  final String room_title;
  final int room_id;
  final String? room_pwd;
  final String? info;
  final int room_mem;
  final int room_maxmem;
  final bool canChat;
  final List<dynamic>? tag;
  // final bool is_manager;
  const RoomSetting_Manager(
      {super.key,
      required this.room_title,
      required this.room_id,
      required this.info,
      this.room_pwd,
      required this.room_mem,
      required this.room_maxmem,
      required this.canChat,
      required this.tag});
  @override
  State<RoomSetting_Manager> createState() => _roomSetManagerState();
}

class _roomSetManagerState extends State<RoomSetting_Manager> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roomSetAppBar(),
      backgroundColor: LIGHTGREY,
      body: Column(
        children: [
          Flexible(
            child: SettingsList(
              contentPadding: const EdgeInsets.all(15),
              sections: [
                SettingsSection(
                  tiles: [
                    SettingsTile(
                      title: const Text('방 ID'),
                      value: Text('${widget.room_id}'),
                      leading: const Icon(Icons.vpn_key),
                    ),
                    SettingsTile.navigation(
                      title: const Text('인증방 편집'),
                      leading: const Icon(Icons.edit),
                      onPressed: ((context) => modifyRoomSetDialog(context)),
                    ),
                    SettingsTile.navigation(
                      title: const Text('비밀번호 변경'),
                      leading: const Icon(Icons.lock),
                      onPressed: ((context) => resetRoomPwdDialog(context)),
                    ),
                    SettingsTile.navigation(
                      title: const Text('인원 제한 변경'),
                      leading: const Icon(Icons.person),
                      onPressed: ((context) => modifyMaxMemlog(context)),
                    ),
                    SettingsTile.switchTile(
                      title: const Text('채팅 기능 활성화'),
                      leading: const Icon(Icons.chat),
                      onToggle: ((context) {}),
                      initialValue: widget.canChat,
                    ),
                    SettingsTile.navigation(
                      title: const Text('인증방 해체하기'),
                      leading: const Icon(Icons.cancel),
                      onPressed: ((context) => deleteRoomDialog(context)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // AppBar
  PreferredSizeWidget _roomSetAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        width: 390,
        height: 80,
        // Border Line
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0x7F414C58),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: LIGHTGREY,
              leading: const BackButton(
                color: PRIMARY_COLOR,
              ),
              title: const Text(
                "인증방 설정",
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontFamily: "bm",
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 인증방 제목/소개/태그 수정
  void modifyRoomSetDialog(BuildContext context) {
    final _editRoomKey = GlobalKey<FormState>();

    // controller
    String? nowRoomInfo = "";
    if (widget.info != null) {
      nowRoomInfo = widget.info;
    }
    String? nowRoomTag = "";
    if (widget.tag!.isNotEmpty || widget.tag == null) {
      nowRoomTag = widget.tag!.join(' ');
    }
    TextEditingController roomTitleController =
        TextEditingController(text: widget.room_title);
    TextEditingController roomInfoController =
        TextEditingController(text: nowRoomInfo);
    TextEditingController roomTagController =
        TextEditingController(text: nowRoomTag);

    void dispose() {
      roomTitleController.dispose();
      roomInfoController.dispose();
      roomTagController.dispose();
      dispose();
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text('인증방 편집'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _editRoomKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // 인증방 제목
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 7),
                      child: TextFormField(
                        controller: roomTitleController,
                        style: const TextStyle(
                          color: Color(0xff4f4f4f),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            labelText: '인증방 제목',
                            labelStyle: const TextStyle(
                                color: Color(0xff4f4f4f), fontSize: 18),
                            filled: true,
                            fillColor: const Color(0xffEDEDED)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '제목을 입력해주세요.';
                          }
                          if (value.length < 2) {
                            return '2글자 이상 입력해주세요.';
                          }
                          return null;
                        },
                      ),
                    ),

                    // 인증방 소개
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: TextFormField(
                        controller: roomInfoController,
                        maxLines: 4,
                        style: const TextStyle(
                          color: Color(0xff4f4f4f),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            labelText: '인증방 소개',
                            labelStyle: const TextStyle(
                                color: Color(0xff4f4f4f), fontSize: 18),
                            filled: true,
                            fillColor: const Color(0xffEDEDED)),
                      ),
                    ),

                    // 인증방 태그
                    Container(
                      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
                      child: TextFormField(
                        controller: roomTagController,
                        style: const TextStyle(
                          color: Color(0xff4f4f4f),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            labelText: '인증방 태그',
                            labelStyle: const TextStyle(
                                color: Color(0xff4f4f4f), fontSize: 18),
                            filled: true,
                            fillColor: const Color(0xffEDEDED)),
                      ),
                    ),
                    const Center(
                      child: Text('※ 태그는 띄어쓰기로 구분해주세요.'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (_editRoomKey.currentState!.validate()) {
                  String editedName = roomTitleController.text;
                  String? editedInfo = roomInfoController.text;
                  List<dynamic>? editedTag = [];
                  if (roomTagController.text != "") {
                    editedTag = roomTagController.text.split(' ');
                    log("$editedTag");
                  }
                  if (editedInfo.isEmpty) {
                    editedInfo = null;
                  }

                  Map<String, dynamic> editedRoomData = {
                    "name": editedName,
                    "info": editedInfo,
                    "tag": editedTag
                  };

                  fetchRoomInfo(editedRoomData, widget.room_id)
                      .then((data) {})
                      .catchError((error) {
                    log("Room Edit Fail: $error");
                  });

                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "변경",
                style: TextStyle(
                    color: Color.fromARGB(226, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); //창 닫기
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "취소",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }

  // 비밀번호 변경
  void resetRoomPwdDialog(BuildContext context) {
    String? nowPwd = "";
    if (widget.room_pwd != null) {
      nowPwd = widget.room_pwd;
    }
    TextEditingController resetPwdController =
        TextEditingController(text: nowPwd);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text('인증방 비밀번호 변경'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // 비밀번호 존재 여부
                  widget.room_pwd != null ? Text("비번ㅇ") : Text("비번X"),

                  // 비밀번호 입력
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
                    child: TextFormField(
                      controller: resetPwdController,
                      style: const TextStyle(
                        color: Color(0xff4f4f4f),
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: POINT_COLOR),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: POINT_COLOR),
                          ),
                          labelText: '비밀번호 입력',
                          labelStyle: const TextStyle(
                              color: Color(0xff4f4f4f), fontSize: 18),
                          filled: true,
                          fillColor: const Color(0xffEDEDED)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                String? changedPwd = resetPwdController.text;
                if (resetPwdController.text.isEmpty) {
                  changedPwd = null;
                }
                fetchRoomInfo({"pwd": changedPwd}, widget.room_id).then((data) {
                  log("changed pwd: $changedPwd");
                }).catchError((error) {
                  log("Room Pwd Edit Fail: $error");
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "변경",
                style: TextStyle(
                    color: Color.fromARGB(226, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); //창 닫기
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "취소",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }

  // 인원 제한 변경
  void modifyMaxMemlog(BuildContext context) {
    final _modifyMaxMemKey = GlobalKey<FormState>();
    TextEditingController maxMemController =
        TextEditingController(text: "${widget.room_maxmem}");

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text('인원 제한 변경'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 7),
                    child: Form(
                      key: _modifyMaxMemKey,
                      child: TextFormField(
                        controller: maxMemController,
                        style: const TextStyle(
                          color: Color(0xff4f4f4f),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: POINT_COLOR),
                            ),
                            labelText: '최대 인원 수',
                            labelStyle: const TextStyle(
                                color: Color(0xff4f4f4f), fontSize: 18),
                            filled: true,
                            fillColor: const Color(0xffEDEDED)),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '숫자를 입력해주세요.';
                          }
                          if (int.parse(value) < widget.room_mem) {
                            return '현재 소속된 인원 수보다 많아야 합니다.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                if (_modifyMaxMemKey.currentState!.validate()) {
                  fetchRoomInfo({"maxUser": int.parse(maxMemController.text)},
                          widget.room_id)
                      .then((data) {})
                      .catchError((error) {
                    log("Edit MaxUSer Fail: $error");
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "변경",
                style: TextStyle(
                    color: Color.fromARGB(226, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); //창 닫기
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "취소",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }

  // 인증방 해체하기
  void deleteRoomDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            '정말 인증방을 해체하시겠습니까?',
            style: TextStyle(
              color: POINT_COLOR,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              '※ 인증방을 해체시킬 경우, 해당 인증방의 데이터는 복구할 수 없습니다.',
              style: TextStyle(
                color: POINT_COLOR,
                fontSize: 15,
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // 인증방 해체 전 검증
                Navigator.of(context).pop();
                deleteRoomValidaion(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "예",
                style: TextStyle(
                    color: Color.fromARGB(226, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); //창 닫기
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text("아니오",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }),
    );
  }

  // 인증방 해체 검증
  void deleteRoomValidaion(BuildContext context) {
    final _deleteRoomKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "인증방을 해체하려면 '해체하겠습니다'를 입력하세요.",
                  style: TextStyle(
                    color: POINT_COLOR,
                    fontSize: 15,
                  ),
                ),

                // 인증방 해체 검증용 문자 입력
                Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  child: Form(
                    key: _deleteRoomKey,
                    child: Column(
                      children: [
                        TextFormField(
                          style: const TextStyle(
                            color: Color(0xff4f4f4f),
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: POINT_COLOR),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: POINT_COLOR),
                              ),
                              hintText: "'해체하겠습니다'를 입력하세요.",
                              labelStyle: const TextStyle(
                                  color: Color(0xff4f4f4f), fontSize: 18),
                              filled: true,
                              fillColor: const Color(0xffEDEDED)),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '문장을 입력해주세요.';
                            }
                            if (value.replaceAll(RegExp('\\s'), "") !=
                                '해체하겠습니다') {
                              return '입력한 문장이 맞지 않습니다.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_deleteRoomKey.currentState!.validate()) {
                  String deleteroomUrl =
                      '$serverUrl/api/v1/room/delete-room/${widget.room_id}';
                  await http.get(Uri.parse(deleteroomUrl), headers: {
                    'Authorization':
                        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
                  });
                  print(deleteroomUrl);
                  Navigator.of(context).pop(); //창 닫기
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const mainPage()));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text(
                "해체",
                style: TextStyle(
                    color: Color.fromARGB(226, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                Navigator.of(context).pop(); //창 닫기
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text("취소",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }),
    );
  }
}
