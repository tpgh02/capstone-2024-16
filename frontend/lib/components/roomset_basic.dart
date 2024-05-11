import 'dart:developer';

import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:http/http.dart' as http;

class RoomSetting_Basic extends StatefulWidget {
  final String room_title;
  final int room_id;
  final String? room_pwd;
  final bool canChat;
  final List<dynamic>? tag;
  final String? periodicity;
  final int frequency;
  final String category;
  final String certificationType;

  const RoomSetting_Basic(
      {super.key,
      required this.room_title,
      required this.room_id,
      this.room_pwd,
      required this.canChat,
      required this.tag,
      required this.periodicity,
      required this.frequency,
      required this.category,
      required this.certificationType});

  @override
  State<RoomSetting_Basic> createState() => _roomSetBasicState();
}

class _roomSetBasicState extends State<RoomSetting_Basic> {
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
                      title: const Text('인증방 정보'),
                      leading: const Icon(Icons.info_outline),
                      onPressed: ((context) => roomInfoDialog(context)),
                    ),
                    SettingsTile.navigation(
                      title: const Text('인증방 나가기'),
                      leading: const Icon(Icons.exit_to_app),
                      onPressed: ((context) => roomExitDialog(context)),
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

  // 인증방 정보
  void roomInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            widget.room_title,
            style: const TextStyle(
              color: POINT_COLOR,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 카테고리
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    const Expanded(
                      child: Text(
                        "카테고리",
                        style: TextStyle(
                            color: POINT_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "${widget.category}",
                      style: const TextStyle(
                        color: POINT_COLOR,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  ],
                ),
                // 인증 주기
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    const Expanded(
                      child: Text(
                        "인증 주기",
                        style: TextStyle(
                            color: POINT_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "${widget.periodicity} ${widget.frequency}회",
                      style: const TextStyle(
                        color: POINT_COLOR,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  ],
                ),
                // 인증 방식
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    const Expanded(
                      child: Text(
                        "인증 방식",
                        style: TextStyle(
                            color: POINT_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    widget.certificationType == 'VOTE'
                        ? const Text(
                            "투표",
                            style: TextStyle(
                              color: POINT_COLOR,
                              fontSize: 15,
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                    widget.certificationType == 'ADMIN'
                        ? const Text(
                            "방장 승인",
                            style: TextStyle(
                              color: POINT_COLOR,
                              fontSize: 15,
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                    widget.certificationType == 'BOTH'
                        ? const Text(
                            "방장 승인 & 투표",
                            style: TextStyle(
                              color: POINT_COLOR,
                              fontSize: 15,
                            ),
                          )
                        : SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    const Expanded(
                      child: Text(
                        "채팅 가능 여부",
                        style: TextStyle(
                            color: POINT_COLOR,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    widget.canChat
                        ? const Text(
                            "O",
                            style: TextStyle(
                              color: POINT_COLOR,
                              fontSize: 15,
                            ),
                          )
                        : const Text(
                            "X",
                            style: TextStyle(
                              color: POINT_COLOR,
                              fontSize: 15,
                            ),
                          ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
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
              child: const Text("닫기",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }),
    );
  }

  // 인증방 나가기
  void roomExitDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            '정말 인증방에서 나가시겠습니까?',
            style: TextStyle(
              color: POINT_COLOR,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              '※ 인증방에서 퇴장할 경우, 해당 인증방에서의 데이터는 복구할 수 없습니다.',
              style: TextStyle(
                color: POINT_COLOR,
                fontSize: 15,
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                String leaveRoomUrl =
                    '$serverUrl/api/v1/room/room-out/${widget.room_id}';
                await http.get(Uri.parse(leaveRoomUrl), headers: {
                  'Authorization':
                      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
                });
                log("인증방 퇴장 성공");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const mainPage())); //창 닫기
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

  // Appbar
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
}
