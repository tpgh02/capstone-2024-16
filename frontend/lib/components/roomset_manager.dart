import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class RoomSetting_Manager extends StatelessWidget {
  const RoomSetting_Manager({super.key});

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
                    SettingsTile.navigation(
                      title: const Text('인증방 제목/소개/태그 변경'),
                      leading: const Icon(Icons.edit),
                      onPressed: ((context) {}),
                    ),
                    SettingsTile.navigation(
                      title: const Text('비밀번호 변경'),
                      leading: const Icon(Icons.lock),
                      onPressed: ((context) {}),
                    ),
                    SettingsTile.navigation(
                      title: const Text('인증 빈도/방식 변경'),
                      leading: const Icon(Icons.edit_calendar),
                      onPressed: ((context) {}),
                    ),
                    SettingsTile.navigation(
                      title: const Text('인원 제한 변경'),
                      leading: const Icon(Icons.person),
                      onPressed: ((context) {}),
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
                      onPressed: ((context) {}),
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
