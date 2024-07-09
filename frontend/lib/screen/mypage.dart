import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/mypage_settings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:dodo/screen/login_screen.dart';
import 'package:dodo/token_storage.dart';
import 'package:http_parser/http_parser.dart';

Future<MyInfo> fetchMyInfo_GET() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/users/me'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });

  if (response.statusCode == 200) {
    log('Mypage: Connected!: ${utf8.decode(response.bodyBytes)}');
    return MyInfo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Mypage: fail to connect');
  }
}

Future<String> fetchMyInfo_POST(Map<String, dynamic> form) async {
  var mypagePostUrl = '$serverUrl/api/v1/users/user-update';
  final mypagePostresponse = await http.post(
    Uri.parse(mypagePostUrl),
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(form),
  );
  try {
    if (mypagePostresponse.statusCode == 200) {
      var responseData = utf8.decode(mypagePostresponse.bodyBytes);
      log('Mypage: Success to Post : $responseData');
      return responseData;
    } else {
      log('닉네임 변경 실패: ${mypagePostresponse.body}');
      throw Exception('닉네임 변경에 실패했습니다');
    }
  } catch (e) {
    log(mypagePostresponse.body);
    log('$e');
    throw Exception('네트워크 오류가 발생했습니다');
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
  final ImagePicker _picker = ImagePicker();
  late File? _pickedImage = File('assets/images/turtle_noradius.png');

  @override
  void initState() {
    super.initState();
    myInfo = fetchMyInfo_GET();
    _pickedImage = File('assets/images/turtle_noradius.png');
  }

  void getNewImage(ImageSource source) async {
    final XFile? selectedImage = await _picker.pickImage(source: source);
    if (selectedImage != null) {
      setState(() {
        _pickedImage = File(selectedImage.path);
      });
      log("이미지 선택함: $_pickedImage");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: FutureBuilder<MyInfo>(
        future: myInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator()),
              ],
            );
          } else if (snapshot.hasError) {
            log("Mypage: Error ${snapshot.data}");
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '서버 연결에 실패하였습니다.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black45,
                      fontFamily: 'bm',
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            // image url, 닉네임
            String imageurl = snapshot.data!.image['url'].toString();
            String nickname = snapshot.data!.name.toString();

            return Column(
              children: [
                _info(imageurl, nickname),
                _button(imageurl, nickname),
                const SizedBox(
                  height: 8,
                ),
                const MyPageSetting(),
              ],
            );
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }

  // 상단 프로필
  Widget _info(String imageurl, String nickname) {
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
                  child: Image.network(imageurl, fit: BoxFit.cover),
                ),
              ),
            ),
          ),

          // 닉네임
          Expanded(
            child: SizedBox(
              width: 200,
              child: Text(
                nickname,
                style: const TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              editNicknameDialog(imageurl, nickname);
            },
            icon: const Icon(Icons.edit),
            color: PRIMARY_COLOR,
          ),
        ],
      ),
    );
  }

  Widget _button(String imageurl, String nickname) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 프로필 수정
          Expanded(
              flex: 1,
              child: MyPageButton(
                  onTap: () async {
                    editProfileDialog(imageurl, nickname);
                  },
                  label: "프로필 사진 수정")),
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

  void editNicknameDialog(String imageurl, String nickname) {
    TextEditingController nicknameController =
        TextEditingController(text: nickname);

    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "닉네임 수정",
            style: TextStyle(fontWeight: FontWeight.bold, color: POINT_COLOR),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
              style: const TextStyle(
                color: Color(0xff4f4f4f),
                fontSize: 15,
              ),
              controller: nicknameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: POINT_COLOR),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: POINT_COLOR),
                  ),
                  hintText: '닉네임',
                  labelStyle:
                      const TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
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
          actions: <Widget>[
            // 수정 버튼
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> nicknameData = {
                  "name": nicknameController.text,
                  "introduceMessage": " ",
                  'image': {'id': 1, 'url': imageurl}
                };
                fetchMyInfo_POST(nicknameData).then((data) {
                  log("닉네임 변경 성공");
                }).catchError((e) {
                  log("닉네임 변경 에러: $e");
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

  // 프로필 수정 다이얼로그
  void editProfileDialog(String imageurl, String nickname) {
    log("$_pickedImage");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text(
            "프로필 사진 수정",
            style: TextStyle(fontWeight: FontWeight.bold, color: POINT_COLOR),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_pickedImage != File('assets/images/turtle_noradius.png'))
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
                              child: Image.network(
                                imageurl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // 카메라 아이콘
                        Positioned(
                          bottom: 5,
                          right: 35,
                          child: InkWell(
                            onTap: () => showModalBottomSheet(
                                context: context,
                                builder: ((builder) =>
                                    editProfilePic(nickname))),
                            child: const Icon(
                              Icons.camera_enhance,
                              color: PRIMARY_COLOR,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
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
                              child: Image.file(File(_pickedImage!.path)),
                            ),
                          ),
                        ),
                        // 카메라 아이콘
                        Positioned(
                          bottom: 5,
                          right: 35,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: ((builder) =>
                                      editProfilePic(nickname)));
                            },
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
              ],
            ),
          ),
          actions: <Widget>[
            // 수정 버튼
            ElevatedButton(
              onPressed: () async {
                if (_pickedImage != File('assets/images/turtle_noradius.png')) {
                  await patchProfilePic(_pickedImage, nickname);
                }
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
  Widget editProfilePic(String nickname) {
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
                  onPressed: () async {
                    getNewImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
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
                  onPressed: () async {
                    patchBasicPic(nickname);
                    Navigator.of(context).pop();
                  },
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

  Future<dynamic> patchProfilePic(File? input, String nickname) async {
    log('프로필 사진 수정: $input');
    var dio = Dio();
    var imageUrl = '$serverUrl/api/v1/users/user-update';
    MultipartFile toEditImage;
    if (input != null) {
      toEditImage = MultipartFile.fromFileSync(input.path,
          contentType: MediaType("image", "jpg"));
    } else {
      throw Exception('이미지 파일이 유효하지 않습니다.');
    }

    FormData formData = FormData.fromMap({'img': toEditImage});

    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      dio.options.headers = {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
      };

      final imageEditResponse = await dio.post(imageUrl,
          data: formData, options: Options(contentType: 'multipart/form-data'));

      if (imageEditResponse.statusCode == 200) {
        log('성공적으로 업로드했습니다: $imageEditResponse');
      } else {
        log('서버로부터 잘못된 응답이 도착했습니다. 상태 코드: ${imageEditResponse.statusCode}');
      }
    } catch (e) {
      log("프사 변경 에러 발생: $e");
      return null;
    }
  }

  Future<dynamic> patchBasicPic(String nickname) async {
    log('프로필 사진 삭제');
    var dio = Dio();
    var imageUrl = '$serverUrl/api/v1/users/user-update';

    FormData formData = FormData.fromMap({
      'img':
          'https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png',
    });

    try {
      dio.options.contentType = 'multipart/form-data';
      dio.options.maxRedirects.isFinite;

      dio.options.headers = {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
      };

      final response = await dio.post(imageUrl, data: formData);

      if (response.statusCode == 200) {
        // final responseData = response.data;
        // final imageUrl = responseData["image"]["url"];
        log('성공적으로 업로드했습니다');
        //return imageUrl;
      } else {
        log('서버로부터 잘못된 응답이 도착했습니다. 상태 코드: ${response.statusCode}');
        //return null;
      }
    } catch (e) {
      log("프사 변경 에러 발생: $e");
      return null;
    }
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
              onPressed: () async {
                await TokenStorage().deleteToken();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => loginPage(),
                  ),
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
