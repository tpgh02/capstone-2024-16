import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dodo/const/server.dart';
import 'package:dodo/components/c_room.dart';
import 'package:dodo/components/c_title.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

Future<List<RoomOfCategory>> fetchCategory(String category) async {
  final response = await http.get(
      Uri.parse(
          '$serverUrl/api/v1/room/get-rooms-by-category?category=$category'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
      });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

    List<RoomOfCategory> categoryRooms =
        jsonData.map((json) => RoomOfCategory.fromJson(json)).toList();
    log("카테고리별 모아보기 연결 완료");
    return categoryRooms;
  } else {
    throw Exception('Failed to load room list');
  }
}

class RoomOfCategory {
  final int roomId;
  final String room_title;
  final image;
  final int maxUser;
  final int nowUser;
  final String endDay;
  final String periodicity;
  final String? room_pwd;
  final String? info;
  final bool canChat;
  final String room_type;
  final String certificationType;
  final int frequency;
  final List<dynamic>? tag;

  RoomOfCategory({
    required this.roomId,
    required this.room_title,
    required this.image,
    required this.maxUser,
    required this.nowUser,
    required this.endDay,
    required this.periodicity,
    required this.room_pwd,
    required this.info,
    required this.canChat,
    required this.room_type,
    required this.certificationType,
    required this.frequency,
    required this.tag,
  });

  factory RoomOfCategory.fromJson(dynamic json) {
    return RoomOfCategory(
      roomId: json['roomId'],
      room_title: json['name'],
      image: json['image'],
      maxUser: json['maxUser'],
      nowUser: json['nowUser'],
      endDay: json['endDay'],
      periodicity: json['periodicity'],
      room_pwd: json['pwd'],
      info: json['info'],
      canChat: json['canChat'],
      room_type: json['roomType'],
      certificationType: json['certificationType'],
      frequency: json['frequency'],
      tag: json['tag'],
    );
  }
}

class categoryPage extends StatefulWidget {
  final String category;
  final String cateKor;
  const categoryPage(
      {super.key, required this.category, required this.cateKor});

  @override
  State<categoryPage> createState() => _categoryPageState();
}

class _categoryPageState extends State<categoryPage> {
  late Future<List<RoomOfCategory>>? futureCategoryRooms;

  @override
  void initState() {
    super.initState();
    futureCategoryRooms = fetchCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: SingleChildScrollView(
        child: Column(
          children: [
            c_title("${widget.cateKor}"),
            FutureBuilder<List<RoomOfCategory>>(
              future: futureCategoryRooms,
              builder: (context, snapshot) {
                // 서버 연결 로딩 및 실패 시
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4),
                      const Center(child: CircularProgressIndicator()),
                    ],
                  );
                } else if (snapshot.hasError) {
                  log("카테고리별 인증방 연결 실패: ${snapshot.error}");
                  return Center(
                    child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.38),
                        const Text(
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
                  // 카테고리에 인증방 X
                  if (snapshot.data?.length == 0) {
                    return Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.38),
                        const Text(
                          '카테고리에 그룹이 존재하지 않습니다.\n그룹을 새로 만들거나 가입해 보세요!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black45,
                            fontFamily: 'bm',
                            fontSize: 20,
                          ),
                        )
                      ],
                    );
                  } else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: snapshot.data!.map((RoomOfCategory) {
                          return c_room(
                              roomId: RoomOfCategory.roomId,
                              room_title: RoomOfCategory.room_title,
                              image: RoomOfCategory.image ??
                                  {
                                    "id": 1,
                                    "url":
                                        "https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png"
                                  },
                              maxUser: RoomOfCategory.maxUser,
                              nowUser: RoomOfCategory.nowUser,
                              endDay: RoomOfCategory.endDay,
                              periodicity: RoomOfCategory.periodicity,
                              room_pwd: RoomOfCategory.room_pwd,
                              info: RoomOfCategory.info,
                              canChat: RoomOfCategory.canChat,
                              room_type: RoomOfCategory.room_type,
                              certificationType:
                                  RoomOfCategory.certificationType,
                              frequency: RoomOfCategory.frequency,
                              tag: RoomOfCategory.tag);
                        }).toList(),
                      ),
                    );
                  }
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
