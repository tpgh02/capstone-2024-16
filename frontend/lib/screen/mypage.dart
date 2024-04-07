import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:image_picker/image_picker.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  XFile? _pickedFile;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: Column(
        children: [
          _info(),
          _button(),
          const SizedBox(
            height: 8,
          ),
          const MyPageSetting(),
        ],
      ),
    );
  }

  // 상단 프로필
  Widget _info() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Row(
        children: [
          // 프로필 사진
          Flexible(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const Image(
                    image: AssetImage('assets/images/Turtle_noradius.png'),
                  ),
                ),
              ),
            ),
          ),

          // 닉네임
          Expanded(
            child: SizedBox(
              width: 150,
              child: Text(
                'Username',
                style: const TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                // softWrap: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 프로필 수정
          Expanded(
              flex: 1,
              child: MyPageButton(
                  onTap: () => editProfileDialog(), label: "프로필 수정")),
          const SizedBox(
            width: 15,
          ),
          // 로그아웃
          Expanded(
            flex: 1,
            child: MyPageButton(onTap: () => logoutDialog(), label: "로그아웃"),
          ),
        ],
      ),
    );
  }

  // 프로필 수정 다이얼로그
  void editProfileDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "프로필 수정",
            style: TextStyle(fontWeight: FontWeight.bold, color: POINT_COLOR),
          ),
          content: Row(
            children: [
              // if (_pickedFile == null)
              // 프로필 사진 및 수정
              Flexible(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const Image(
                              image: AssetImage(
                                  'assets/images/Turtle_noradius.png')),
                        ),
                      ),
                    ),
                    // 카메라 아이콘
                    Positioned(
                      bottom: 5,
                      right: 25,
                      child: InkWell(
                        onTap: () => showModalBottomSheet(
                            context: context,
                            builder: ((builder) => editProfilePic())),
                        child: const Icon(
                          Icons.camera_enhance,
                          color: PRIMARY_COLOR,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 닉네임
              Expanded(
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: PRIMARY_COLOR,
                          width: 5.0,
                        ),
                      ),
                      labelText: ('변경할 닉네임'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
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
                "수정",
                style: TextStyle(fontWeight: FontWeight.bold),
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
  }

  // 프로필 사진 수정 팝업
  Widget editProfilePic() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '프로필 사진을 선택해주세요.',
              style: TextStyle(
                color: POINT_COLOR,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        color: POINT_COLOR,
                        size: 40,
                      ),
                      Text(
                        '카메라',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: POINT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.photo,
                        color: POINT_COLOR,
                        size: 40,
                      ),
                      Text(
                        '앨범',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: POINT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: POINT_COLOR,
                        size: 40,
                      ),
                      Text(
                        '기본 이미지',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: POINT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 로그아웃 팝업 창
  void logoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          content: const Text(
            '정말 로그아웃하시겠습니까?',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
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
                "네",
                style: TextStyle(fontWeight: FontWeight.bold),
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

// 프로필 수정 및 로그아웃 버튼
class MyPageButton extends StatelessWidget {
  final void Function()? onTap;
  final String label;

  const MyPageButton({super.key, this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    // throw UnimplementedError();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: PRIMARY_COLOR,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(100, 100, 100, 100),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(3, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 16, letterSpacing: 1.5, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

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
                onPressed: ((context) {}),
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

// 다크 모드 설정 -> 삭제 예정
  void darkModeDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text('다크 모드 설정'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            // 다크 모드 선택
            children: <Widget>[],
          ),
          actions: <Widget>[
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
                "확인",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }
}
