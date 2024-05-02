import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/mypage_settings.dart';
import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

Future<MyInfo> fetchMyInfo() async {
  final response =
      await http.get(Uri.parse(serverUrl + '/api/v1/users/me'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjR9.eHgurhGH1zPWmWxZdZZzMo_9PJaZKk5XrSpz0IA83ZM'
  });

  if (response.statusCode == 200) {
    print('Mypage: Connected!');
    print(json.decode(response.body));
    return MyInfo.fromJson(json.decode(response.body));
  } else {
    throw Exception('Mypage: fail to connect');
  }
}

class MyInfo {
  final int userId;
  final String authenticationType;
  final String email;
  final String name;
  final int mileage;
  final String introduceMessage;
  final image;

  MyInfo(
      {required this.userId,
      required this.authenticationType,
      required this.email,
      required this.name,
      required this.mileage,
      required this.introduceMessage,
      required this.image});

  factory MyInfo.fromJson(dynamic json) {
    return MyInfo(
        userId: json["userId"],
        authenticationType: json["authenticationType"],
        email: json["email"],
        name: json["name"],
        mileage: json["mileage"],
        introduceMessage: json["introduceMessage"],
        image: json["image"]);
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Future<MyInfo>? myInfo;

  @override
  void initState() {
    super.initState();
    myInfo = fetchMyInfo();
  }

  @override
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
                child: FutureBuilder<MyInfo>(
                  future: myInfo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      print("Mypage: Error " + snapshot.data.toString());
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // image url
                      String imageurl = snapshot.data!.image['url'].toString();
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(imageurl),
                      );
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
              ),
            ),
          ),

          // 닉네임
          Expanded(
            child: SizedBox(
              width: 200,
              child: FutureBuilder<MyInfo>(
                future: myInfo,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print("Mypage: Error " + snapshot.data.toString());
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    String nickname = snapshot.data!.name.toString();
                    return Text(
                      nickname,
                      style: const TextStyle(
                          color: PRIMARY_COLOR,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
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
    TextEditingController nicknameController = TextEditingController();
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
          content: FutureBuilder<MyInfo>(
            future: myInfo,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                print("Mypage: Error " + snapshot.data.toString());
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // 닉네임 확인 시 controller 내부에 닉네임 삽입
                nicknameController =
                    TextEditingController(text: snapshot.data!.name.toString());
                // image url
                String imageurl = snapshot.data!.image['url'].toString();

                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      // if (_pickedFile == null)
                      // 프로필 사진 및 수정
                      Flexible(
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 30, 0),
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(imageurl)),
                              ),
                            ),
                            // 카메라 아이콘
                            Positioned(
                              bottom: 5,
                              right: 35,
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
                        child: TextFormField(
                          style: const TextStyle(
                            color: Color(0xff4f4f4f),
                            fontSize: 15,
                          ),
                          controller: nicknameController,
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
                              hintText: '닉네임',
                              labelStyle: const TextStyle(
                                  color: Color(0xff4f4f4f), fontSize: 18),
                              filled: true,
                              fillColor: const Color(0xffEDEDED)),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return '닉네임을 입력해주세요.';
                            }
                            if (value.length < 2) {
                              return '2글자 이상 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Text('No data available');
              }
            },
          ),
          actions: <Widget>[
            // 수정 버튼
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
                "수정",
                style: TextStyle(
                    color: Color.fromARGB(226, 255, 255, 255),
                    fontWeight: FontWeight.bold),
              ),
            ),

            // 닫기 버튼
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
