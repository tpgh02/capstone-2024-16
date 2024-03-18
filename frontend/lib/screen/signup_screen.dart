import 'dart:convert';

import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/findpass_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

Future<data> fetchInfo(Map<String, String> userData) async {
  var url = 'http://43.203.195.126:8080/api/v1/users/register';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      print('회원가입 성공!');
      return data.fromJson(json.decode(response.body));
    } else {
      print('회원가입 실패: ${response.body}');
      throw Exception('회원가입에 실패했습니다');
    }
  } catch (e) {
    print('네트워크 오류: $e');
    throw Exception('네트워크 오류가 발생했습니다');
  }
}

class data {
  final String type;
  final String email;
  final String username;
  final String password1;
  final String password2;

  data(
      {required this.type,
      required this.email,
      required this.username,
      required this.password1,
      required this.password2});

  factory data.fromJson(Map<dynamic, dynamic> json) {
    return data(
      type: 'password',
      email: json["id"],
      username: json["userName"],
      password1: json["account"],
      password2: json["balance"],
    );
  }
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: PRIMARY_COLOR,
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size(300, 70),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    TextEditingController _email = TextEditingController();
    TextEditingController _username = TextEditingController();
    TextEditingController _password1 = TextEditingController();
    TextEditingController _password2 = TextEditingController();

    // var dev_data = jsonDecode(data);
    // var type = dev_data[0];
    // var email = dev_data[1];
    // var username = dev_data[2];
    // var password1 = dev_data[3];
    // var password2 = dev_data[4];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          width: 100,
          height: 100,
          alignment: Alignment.topRight,
          padding: const EdgeInsets.fromLTRB(0, 30, 30, 0),
          child: const Image(
            image: AssetImage('../assets/images/logo.png'),
            width: 110,
            height: 110,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Form(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Text(
                    '회원가입',
                    style: TextStyle(fontFamily: 'kcc', fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //이메일
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          //borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        labelText: '이메일 주소',
                        filled: true,
                        fillColor: Color(0xffEDEDED),
                        labelStyle:
                            TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  //사용자이름
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _username,
                      keyboardType: TextInputType.name,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          //borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        labelText: '사용자이름',
                        filled: true,
                        fillColor: const Color(0xffEDEDED),
                        labelStyle: TextStyle(color: DARKGREY, fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //비밀번호
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _password1,
                      keyboardType: TextInputType.visiblePassword,
                      style: const TextStyle(fontSize: 20),
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          //borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        labelText: '비밀번호',
                        filled: true,
                        fillColor: Color(0xffEDEDED),
                        labelStyle:
                            TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //비밀번호 확인
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _password2,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontSize: 20),
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          //borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        labelText: '비밀번호확인',
                        filled: true,
                        fillColor: Color(0xffEDEDED),
                        labelStyle:
                            TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: style,
                    onPressed: () {
                      Map<String, String> userData = {
                        'type': 'password',
                        'email': _email.text,
                        'username': _username.text,
                        'password1': _password1.text,
                        'password2': _password2.text,
                      };
                      fetchInfo(userData).then((data) {
                        print("회원가입 완");
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => findpassPage()));
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.bottomRight,
            child: Image.asset('assets/images/turtle.png',
                width: 150,
                height: 150, //175
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter),
          ),
        ],
      ),
    );
  }
}
