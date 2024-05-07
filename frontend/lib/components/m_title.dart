import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/material.dart';

Future<UserName> fetchUserName() async {
  final response = await http
      .get(Uri.parse('$serverUrl/api/v1/users/simple-profile'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    log('Main title: Connected!');
    return UserName.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Main title: fail to connect');
  }
}

class UserName {
  final String name;

  UserName({required this.name});

  factory UserName.fromJson(dynamic json) {
    return UserName(name: json['name']);
  }
}

// ignore: must_be_immutable
class m_title extends StatelessWidget {
  m_title({super.key});
  Future<UserName>? myusername;

  void init() {
    myusername = fetchUserName();
  }

  @override
  Widget build(BuildContext context) {
    init();
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
                        fontFamily: "kcc", fontSize: 20, color: DARKGREY),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FutureBuilder<UserName>(
                        future: myusername,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: CircularProgressIndicator()),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            log("Main title: Error - ${snapshot.data.toString()}");
                            return const Text("서버 연결 실패",
                                style: TextStyle(
                                    fontFamily: "kcc",
                                    fontSize: 40,
                                    color: PRIMARY_COLOR));
                          } else if (snapshot.hasData) {
                            return Text(snapshot.data!.name.toString(),
                                style: const TextStyle(
                                    fontFamily: "kcc",
                                    fontSize: 40,
                                    color: PRIMARY_COLOR));
                          } else {
                            return const Text('No data available');
                          }
                        },
                      ),
                      // Text('$name',
                      //     style: const TextStyle(
                      //         fontFamily: "kcc",
                      //         fontSize: 40,
                      //         color: PRIMARY_COLOR)),
                      Text(
                        ' 님',
                        style: TextStyle(
                            fontFamily: "kcc", fontSize: 30, color: DARKGREY),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
