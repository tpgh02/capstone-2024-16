import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:dodo/components/room_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/AIroom_cr.dart';
import 'package:dodo/screen/Groproom_cr.dart';
import 'package:dodo/screen/Room_cr.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<List<MyRoom>> fetchRooms() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/room/list'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

    List<MyRoom> Rooms = jsonData.map((json) => MyRoom.fromJson(json)).toList();
    log("인증방 리스트 연결 완료");
    return Rooms;
  } else {
    throw Exception('Failed to load room list');
  }
}

class MyRoom {
  final String room_title;
  final int room_id;
  final String? room_pwd;
  final room_img;
  final int room_mem;
  final int room_maxmem;
  final String room_type;
  final bool is_manager;

  const MyRoom({
    required this.room_title,
    required this.room_id,
    required this.room_pwd,
    required this.room_img,
    required this.room_mem,
    required this.room_maxmem,
    required this.room_type,
    required this.is_manager,
  });

  factory MyRoom.fromJson(dynamic json) {
    return MyRoom(
      room_title: json['name'],
      room_id: json['roomId'],
      room_pwd: json['password'],
      room_img: json['image'],
      room_mem: json['nowUser'],
      room_maxmem: json['maxUser'],
      room_type: json['roomType'],
      is_manager: json['isManager'],
    );
  }
}

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListState();
}

class _RoomListState extends State<RoomListPage> {
  late Future<List<MyRoom>>? futureRoomList;

  @override
  void initState() {
    super.initState();
    futureRoomList = fetchRooms();
  }

  final List<dynamic> roomList = [
    {
      "room_title": "자취요리왕",
      "room_id": 1,
      "room_pwd": null,
      "room_type": "default",
      "room_img": "assets/images/cook.jpg",
      "room_mem": 10,
      "room_maxmem": 20,
      "canChat": true,
      "is_manager": true,
      "certificationType": "VOTE",
    },
    {
      "room_title": "오운완",
      "room_id": 2,
      "room_pwd": "1234",
      "room_type": "AI",
      "room_img": "assets/images/turtle_noradius.png",
      "room_mem": 5,
      "room_maxmem": 20,
      "canChat": false,
      "is_manager": false,
      "certificationType": "AI",
    },
    {
      "room_title": "H.O.T",
      "room_id": 3,
      "room_pwd": null,
      "room_type": "group",
      "room_img": "assets/images/turtle_noradius.png",
      "room_mem": 10,
      "room_maxmem": 20,
      "canChat": true,
      "is_manager": true,
      "certificationType": "APPROVE",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomFloatingActionButton(
      body: Scaffold(
        appBar: _roomListAppBar(),
        backgroundColor: LIGHTGREY,
        //floatingActionButton: appendRoom(),
        body: FutureBuilder<List<MyRoom>>(
          future: futureRoomList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.hasError) {
              log("인증방 리스트 연결 실패: ${snapshot.error}");
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
              if (snapshot.data?.length == 0) {
                log('가입한 방이 없습니다.');
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '아직 가입한 그룹이 없습니다.\n그룹을 새로 만들거나 가입해 보세요!',
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
              } else {
                log('가입한 방이 존재합니다.');
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Column(
                        children: snapshot.data!.map((MyRoom) {
                          return room_list(
                            room_title: MyRoom.room_title.toString(),
                            room_id: MyRoom.room_id,
                            room_pwd: MyRoom.room_pwd?.toString(),
                            room_type: MyRoom.room_type.toString(),
                            room_img: MyRoom.room_img != null
                                ? MyRoom.room_img['url'].toString()
                                : "https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png",
                            room_mem: MyRoom.room_mem,
                            room_maxmem: MyRoom.room_maxmem,
                            canChat: true,
                            is_manager: MyRoom.is_manager,
                            certificationType: "VOTE",
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
      options: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Text(
                'AI인증방 생성',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'bma', fontSize: 20),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AIroom_cr()));
                },
                child: Image.asset(
                  "assets/images/AI인증방생성.png",
                  fit: BoxFit.cover,
                  scale: 9,
                )),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Text(
                '일반 인증방 생성',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'bma', fontSize: 20),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Room_cr()));
                },
                child: Image.asset(
                  "assets/images/일반인증방생성.png",
                  fit: BoxFit.cover,
                  scale: 9,
                )),
          ],
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: const Text(
                '그룹 인증방 생성',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'bma', fontSize: 20),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Groproom_cr()));
                },
                child: Image.asset(
                  "assets/images/그룹인증방생성.png",
                  fit: BoxFit.cover,
                  scale: 9,
                )),
          ],
        ),
      ],
      type: CustomFloatingActionButtonType.verticalUp,
      floatinButtonColor: PRIMARY_COLOR,
      openFloatingActionButton: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
      closeFloatingActionButton: const Icon(
        Icons.close,
        color: Colors.white,
        size: 30,
      ),
      spaceFromBottom: 10,
      barrierDismissible: false,
      backgroundColor: Colors.black.withOpacity(0.6),
    );
  }

  PreferredSizeWidget _roomListAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        width: 390,
        height: 80,
        // Border Line
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0x7F414C58),
            ),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
        child: const Text(
          '내가 가입한 그룹',
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontFamily: "bm",
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  // Container appendRoom() {
  //   return Container(
  //     width: 70,
  //     height: 70,
  //     alignment: Alignment.bottomRight,
  //     color: PRIMARY_COLOR,
  //     margin: const EdgeInsets.all(20),
  //     child: const Icon(
  //       Icons.plus_one,
  //       color: Colors.white,
  //     ),

  //     // FloatingActionButton(
  //     //   onPressed: () {
  //     //     // Navigator.push(
  //     //     //     context, MaterialPageRoute(builder: (context) => appendRoom2()));
  //     //   },
  //     //   backgroundColor: PRIMARY_COLOR,
  //     //   elevation: 1,
  //     //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  //   );
  // }
}
