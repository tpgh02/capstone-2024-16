import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/material.dart';
import 'package:dodo/token_storage.dart'; // TokenStorage 추가

class UserName {
  final String name;

  UserName({required this.name});

  factory UserName.fromJson(dynamic json) {
    return UserName(name: json['name']);
  }
}

Future<UserName> fetchUserName() async {
  final tokenStorage = TokenStorage(); // TokenStorage 인스턴스 생성
  final token = await tokenStorage.getToken(); // 토큰 가져오기

  // 토큰이 제대로 가져와졌는지 로그로 확인
  log('Fetched token: $token');

  if (token == null) {
    throw Exception('Token is null');
  }

  final response = await http.get(
    Uri.parse('$serverUrl/api/v1/users/simple-profile'),
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU', //$token',
    },
  );

  log('Response status code: ${response.statusCode}');
  log('Response body: ${utf8.decode(response.bodyBytes)}');

  if (response.statusCode == 200) {
    log('Main title: Connected!');
    return UserName.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Main title: fail to connect');
  }
}

class m_title extends StatefulWidget {
  const m_title({super.key});

  @override
  _m_titleState createState() => _m_titleState();
}

class _m_titleState extends State<m_title> {
  late Future<UserName> myusername;

  @override
  void initState() {
    super.initState();
    myusername = fetchUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                '안녕하세요,',
                style: TextStyle(
                  fontFamily: "kcc",
                  fontSize: 20,
                  color: DARKGREY,
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder<UserName>(
                    future: myusername,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        log("Main title: Error - ${snapshot.error.toString()}");
                        return const Text(
                          "서버 연결 실패",
                          style: TextStyle(
                            fontFamily: "kcc",
                            fontSize: 40,
                            color: PRIMARY_COLOR,
                          ),
                        );
                      } else if (snapshot.hasData) {
                        return Text(
                          "김도도", //snapshot.data!.name,
                          style: const TextStyle(
                            fontFamily: "kcc",
                            fontSize: 40,
                            color: PRIMARY_COLOR,
                          ),
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                  Text(
                    ' 님',
                    style: TextStyle(
                      fontFamily: "kcc",
                      fontSize: 30,
                      color: DARKGREY,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
