import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class RoomSetting_Basic extends StatelessWidget {
  const RoomSetting_Basic({super.key});

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
                        value: const Text('01234567'),
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
