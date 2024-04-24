import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class RoomSetting_Basic extends StatelessWidget {
  final String room_title;
  final int room_id;
  final String? room_pwd;
  final String room_type;
  // final String room_img;
  final int room_mem;
  final int room_maxmem;
  final bool canChat;
  // final bool is_manager;
  const RoomSetting_Basic({
    super.key,
    required this.room_title,
    required this.room_id,
    this.room_pwd,
    required this.room_type,
    required this.room_mem,
    required this.room_maxmem,
    required this.canChat,
  });

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
                        title: const Text('인증방 정보'),
                        leading: const Icon(Icons.info_outline),
                        onPressed: ((context) {}),
                      ),
                      SettingsTile.navigation(
                        title: const Text('인증방 나가기'),
                        leading: const Icon(Icons.exit_to_app),
                        onPressed: ((context) {}),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ));
  }

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
