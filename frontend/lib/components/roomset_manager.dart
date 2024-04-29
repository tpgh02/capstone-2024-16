import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class RoomSetting_Manager extends StatelessWidget {
  final String room_title;
  final int room_id;
  final String? room_pwd;
  final String room_type;
  // final String room_img;
  final int room_mem;
  final int room_maxmem;
  final bool canChat;
  // final bool is_manager;
  const RoomSetting_Manager(
      {super.key,
      required this.room_title,
      required this.room_id,
      this.room_pwd,
      required this.room_type,
      required this.room_mem,
      required this.room_maxmem,
      required this.canChat});

  @override
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
                      value: Text('$room_id'),
                      leading: const Icon(Icons.vpn_key),
                    ),
                    SettingsTile.navigation(
                      title: const Text('인증방 제목/소개/태그 수정'),
                      leading: const Icon(Icons.edit),
                      onPressed: ((context) => modifyRoomSetDialog(context)),
                    ),
                    SettingsTile.navigation(
                      title: const Text('비밀번호 변경'),
                      leading: const Icon(Icons.lock),
                      onPressed: ((context) => resetRoomPwdDialog(context)),
                    ),
                    SettingsTile.navigation(
                      title: const Text('인증 빈도/방식 변경'),
                      leading: const Icon(Icons.edit_calendar),
                      onPressed: ((context) {}),
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
                      initialValue: true,
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
    TextEditingController roomTitleController =
        TextEditingController(text: room_title);
    TextEditingController roomIntroController =
        TextEditingController(text: "인증방 소개");
    TextEditingController roomTagController = TextEditingController(text: "");

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text('인증방 제목/소개/태그 수정'),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
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
                      controller: roomIntroController,
                      maxLines: 6,
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
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
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

  // 비밀번호 변경
  void resetRoomPwdDialog(BuildContext context) {
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
                  // 현재 비밀번호
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
                    child: TextFormField(
                      obscureText: true,
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
                          labelText: '현재 비밀번호',
                          labelStyle: const TextStyle(
                              color: Color(0xff4f4f4f), fontSize: 18),
                          filled: true,
                          fillColor: const Color(0xffEDEDED)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '비밀번호를 입력해주세요.';
                        }
                        if (value.length < 4) {
                          return '4글자 이상 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),

                  // 변경할 비밀번호
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
                    child: TextFormField(
                      obscureText: true,
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
                          labelText: '새 비밀번호',
                          labelStyle: const TextStyle(
                              color: Color(0xff4f4f4f), fontSize: 18),
                          filled: true,
                          fillColor: const Color(0xffEDEDED)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '비밀번호를 입력해주세요.';
                        }
                        if (value.length < 4) {
                          return '4글자 이상 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),

                  // 비밀번호 확인
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
                    child: TextFormField(
                      obscureText: true,
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
                          labelText: '비밀번호 확인',
                          labelStyle: const TextStyle(
                              color: Color(0xff4f4f4f), fontSize: 18),
                          filled: true,
                          fillColor: const Color(0xffEDEDED)),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '비밀번호를 입력해주세요.';
                        }
                        if (value.length < 4) {
                          return '4글자 이상 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
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
    TextEditingController maxMemController =
        TextEditingController(text: "$room_maxmem");

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
                        if (value as int < room_mem) {
                          return '현재 소속된 인원 수보다 많아야 합니다.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
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
                // 인증방 해체 전 비밀번호 확인
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: ((context) {
                    return AlertDialog(
                      backgroundColor: LIGHTGREY,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      content: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "인증방을 해체하려면 비밀번호를 입력하세요.",
                              style: TextStyle(
                                color: POINT_COLOR,
                                fontSize: 15,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                              child: TextFormField(
                                obscureText: true,
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
                                    hintText: '인증방의 비밀번호를 입력하세요.',
                                    labelStyle: const TextStyle(
                                        color: Color(0xff4f4f4f), fontSize: 18),
                                    filled: true,
                                    fillColor: const Color(0xffEDEDED)),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return '비밀번호를 입력해주세요.';
                                  }
                                  if (value != room_pwd) {
                                    return '비밀번호가 틀립니다.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); //창 닫기
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
                          child: const Text("취소",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    );
                  }),
                );
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
}
