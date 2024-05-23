import 'dart:developer';

import 'package:dodo/components/l_title.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/findpass_screen.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:dodo/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dodo/token_storage.dart';

class loginPage extends StatefulWidget {
  final int? userId;
  const loginPage({Key? key, this.userId}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

Future<String> fetchInfo(BuildContext context, Map<String, String> form) async {
  var url = serverUrl + '/api/v1/users/login';
  final response = await http.post(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(form),
  );
  try {
    if (response.statusCode == 200) {
      print('로그인 성공!');
      Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      String token = responseData['token'];
      log('response token: $token'); //log 찍는 걸로 차후에 변경하기
      return token;
    } else {
      String errorMessage =
          jsonDecode(utf8.decode(response.bodyBytes))['message'];
      print('로그인 실패: $errorMessage');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: LIGHTGREY,
            title: const Text('로그인 실패'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
      throw Exception('로그인에 실패했습니다');
    }
  } catch (e) {
    print(response.body);
    print('$e');

    throw Exception('네트워크 오류가 발생했습니다');
  }
}

class _loginPageState extends State<loginPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool? _isEnabled = true;
  bool _obscurePassword = true;
  final tokenStorage = TokenStorage();
  dynamic userInfo = '';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  Future<void> _asyncMethod() async {
    userInfo = await tokenStorage.getToken();
    if (userInfo != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => mainPage(token: userInfo),
        ),
      );
    } else {
      print('로그인이 필요합니다');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          width: 100,
          height: 100,
          alignment: Alignment.topRight,
          padding: const EdgeInsets.fromLTRB(0, 30, 30, 0),
          child: const Image(
            image: AssetImage('assets/images/logo.png'),
            width: 110,
            height: 110,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                key: _globalKey,
                autovalidateMode: _autovalidateMode,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const l_title('로그인'),

                    const SizedBox(
                      height: 30,
                    ),

                    // 구글 로그인
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: const Color(0xff1CB5E0),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(140, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Google로 로그인'),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    // 또는

                    Row(
                      children: [
                        Flexible(
                          child: Divider(
                            thickness: 1,
                            height: 1,
                            color: LIGHTGREY,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: const Text(
                            '또는',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Divider(
                            thickness: 1,
                            height: 1,
                            color: LIGHTGREY,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    //이메일주소
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      style: const TextStyle(
                        color: Color(0xff4f4f4f),
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          labelText: '이메일 주소',
                          labelStyle: const TextStyle(
                              color: Color(0xff4f4f4f), fontSize: 18),
                          // prefixIcon: Icon(Icons.email_rounded),
                          filled: true,
                          fillColor: const Color(0xffEDEDED)),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !isEmail(value.trim())) {
                          return '이메일을 입력해주세요';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    //패스워드
                    TextFormField(
                      enabled: _isEnabled,
                      controller: _password,
                      obscureText: _obscurePassword,
                      style: const TextStyle(
                        color: Color(0xff4f4f4f),
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        labelText: '비밀번호',
                        labelStyle: const TextStyle(
                            color: Color(0xff4f4f4f), fontSize: 18),
                        filled: true,
                        fillColor: const Color(0xffEDEDED),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return '패스워드를 입력해주세요';
                        }
                        if (value.length < 6) {
                          return '6글자 이상 입력해주세요';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),

                    // 로그인 버튼
                    ElevatedButton(
                      onPressed: () {
                        if (_globalKey.currentState!.validate()) {
                          Map<String, String> userData = {
                            "type": "password",
                            "email": _email.text,
                            "password": _password.text
                          };
                          fetchInfo(context, userData).then((data) async {
                            print("메인으로 넘어감");
                            print(data);
                            await tokenStorage.saveToken(data); // 토큰 저장
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => mainPage(token: data),
                              ),
                            );
                          }).catchError((error) {
                            print("망할 에러$error");
                            print("$userData");
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(fontSize: 20),
                        backgroundColor: const Color(0xff1CB5E0),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(140, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('로그인'),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff464646),
                      ),
                      child: const Text(
                        '아이디가 없나요? 회원가입하기',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(
                      height: 5,
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const findpassPage()));
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xff464646),
                      ),
                      child: const Text(
                        '비밀번호를 잃어버렸나요?',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    // 하단 여백
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
