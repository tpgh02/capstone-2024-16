import 'dart:convert';
import 'dart:developer';
import 'package:dodo/components/m2_board.dart';
import 'package:dodo/components/m2_button.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<MyRoom_Main>> fetchRoomsMain() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/room/list'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<MyRoom_Main> roomsMain =
        jsonData.map((json) => MyRoom_Main.fromJson(json)).toList();
    log("Main2 : Connected!");
    return roomsMain;
    // final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    // List<String> roomTitles =
    //     jsonData.map((json) => json['name'] as String).toList();
    // log("Main todo: Connected!");
    // return roomTitles;
  } else {
    throw Exception('Failed to load room list in main');
  }
}

class MyRoom_Main {
  final String room_title;
  final int room_id;
  final room_img;

  const MyRoom_Main(
      {required this.room_title,
      required this.room_id,
      required this.room_img});

  factory MyRoom_Main.fromJson(dynamic json) {
    return MyRoom_Main(
      room_title: json['name'],
      room_id: json['roomId'],
      room_img: json['image'],
    );
  }
}

class main2Page extends StatefulWidget {
  const main2Page({super.key});

  @override
  State<main2Page> createState() => _main2PageState();
}

class _main2PageState extends State<main2Page> {
  late Future<List<MyRoom_Main>> _roomsMainFuture;
  MyRoom_Main? _selectedRoom;

  @override
  void initState() {
    super.initState();
    _initializeData(); // initState에서 데이터 초기화 메서드 호출
  }

  // 데이터 초기화 메서드
  void _initializeData() async {
    _roomsMainFuture = fetchRoomsMain();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const mainPage()),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: POINT_COLOR,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FutureBuilder<List<MyRoom_Main>>(
                      future: _roomsMainFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return DropdownButton(
                            value: _selectedRoom,
                            items: (snapshot.data ?? []).map((room) {
                              return DropdownMenuItem(
                                value: room,
                                child: Text(
                                  room.room_title,
                                  style: const TextStyle(
                                      fontFamily: 'bm', fontSize: 20),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRoom = value as MyRoom_Main?;
                              });
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "에서 나는?",
                      style: TextStyle(
                          fontSize: 22, fontFamily: 'kcc', color: POINT_COLOR),
                    ),
                  ],
                ),
              ),
              FutureBuilder<List<MyRoom_Main>>(
                future: _roomsMainFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print("Error: ${snapshot.error}");
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<MyRoom_Main>? rooms = snapshot.data;
                    if (rooms != null && rooms.isNotEmpty) {
                      // final int roomId =
                      //     rooms[0].room_id; // 예시로 첫 번째 방의 room_id를 가져옴
                      print("main2 Room ID: ${_selectedRoom?.room_id}");
                      return m2_board(roomId: _selectedRoom?.room_id ?? 1);
                    } else {
                      print("등록되어 있는 인증방이 없습니다");
                      return Text("등록되어 있는 인증방이 없습니다");
                    }
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: const m2_button(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
