import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

// 하단 설정 부분
class MyPageSetting extends StatelessWidget {
  const MyPageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('계정 설정'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('비밀번호 변경'),
                leading: const Icon(Icons.key),
                onPressed: ((context) => resetPassword(context)),
              ),
              SettingsTile.navigation(
                title: const Text('계정 비활성화'),
                leading: const Icon(Icons.person_remove),
                onPressed: ((context) {}),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('앱 설정'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('알림 설정'),
                leading: const Icon(Icons.notifications),
                onToggle: ((context) {}),
                initialValue: true,
              ),
              SettingsTile.navigation(
                title: const Text('언어 설정'),
                leading: const Icon(Icons.language),
                onPressed: ((context) {}),
              ),
              SettingsTile.switchTile(
                title: const Text('다크 모드 설정'),
                leading: const Icon(Icons.dark_mode),
                onToggle: ((context) {}),
                initialValue: false,
              ),
            ],
          ),
          SettingsSection(
            title: const Text('앱 정보'),
            tiles: [
              SettingsTile.navigation(
                title: const Text('튜토리얼 다시 보기'),
                leading: const Icon(Icons.menu_book_outlined),
                onPressed: ((context) {}),
              ),
              SettingsTile(
                title: const Text('앱 버전'),
                value: const Text('1.0.0'),
                leading: const Icon(Icons.info_outline),
                // onPressed: ((context) {}),
              ),
              SettingsTile.navigation(
                title: const Text('서비스 이용 약관'),
                leading: const Icon(Icons.help_outline_outlined),
                onPressed: ((context) {}),
              ),
              SettingsTile.navigation(
                title: const Text('오픈소스 라이선스'),
                leading: const Icon(Icons.code),
                onPressed: ((context) {}),
              ),
            ],
          ),
        ],
      ),
    );
  }

// 비밀번호 변경
  void resetPassword(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text('비밀번호 변경'),
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
                          return '패스워드를 입력해주세요.';
                        }
                        if (value.length < 6) {
                          return '6글자 이상 입력해주세요.';
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
                          return '패스워드를 입력해주세요.';
                        }
                        if (value.length < 6) {
                          return '6글자 이상 입력해주세요.';
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
                          return '패스워드를 입력해주세요.';
                        }
                        if (value.length < 6) {
                          return '6글자 이상 입력해주세요.';
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
}
