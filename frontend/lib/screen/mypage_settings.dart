import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/mypage_appinfo.dart';
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
                onPressed: ((context) => deactivateAccountDialog(context)),
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
                onPressed: ((context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TermsOfService()));
                }),
              ),
              SettingsTile.navigation(
                title: const Text('오픈소스 라이선스'),
                leading: const Icon(Icons.code),
                onPressed: ((context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OpenSourceLicense()));
                }),
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
      barrierDismissible: false,
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

  // 계정 비활성화하기
  void deactivateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            '정말 계정을 비활성화하시겠습니까?',
            style: TextStyle(
              color: POINT_COLOR,
              fontSize: 20,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Text(
              '※ 계정을 비활성화할 경우, 데이터는 복구할 수 없습니다.',
              style: TextStyle(
                color: POINT_COLOR,
                fontSize: 15,
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                // 계정 비활성화 전 비밀번호 확인
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
                              "계정을 비활성화하려면 비밀번호를 입력하세요.",
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
                                    hintText: '비밀번호를 입력하세요.',
                                    labelStyle: const TextStyle(
                                        color: Color(0xff4f4f4f), fontSize: 18),
                                    filled: true,
                                    fillColor: const Color(0xffEDEDED)),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return '비밀번호를 입력하세요.';
                                  }
                                  // if (value != room_pwd) {
                                  //   return '비밀번호가 틀립니다.';
                                  // }
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
