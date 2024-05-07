import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dodo/components/todo.dart';
import 'package:flutter/material.dart';
import 'package:dodo/const/server.dart';

//m_state 아래부터 네비게이션 바 위까지 구성
//안의 방들은 todo.dart 파일에 있음

Future<List<MyRoom_Main>> fetchRoomsMain() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/room/list'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<MyRoom_Main> RoomsMain =
        jsonData.map((json) => MyRoom_Main.fromJson(json)).toList();
    log("Main todo: Connected!");
    return RoomsMain;
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

class m_todo extends StatefulWidget {
  const m_todo({super.key});

  @override
  State<m_todo> createState() => _m_todoState();
}

class _m_todoState extends State<m_todo> {
  // final postList = [
  //   {"room_title": "자취요리왕", "room_img": "assets/images/cook.jpg"},
  //   {"room_title": "오운완", "room_img": "assets/images/turtle_noradius.png"},
  //   {"room_title": "H.O.T", "room_img": "assets/images/turtle_noradius.png"},
  // ];
  // List<int> top = <int>[];
  // List<int> bottom = <int>[0];
  late Future<List<MyRoom_Main>>? futureRoomListMain;

  @override
  void initState() {
    super.initState();
    futureRoomListMain = fetchRoomsMain();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //어떻게 하면 네비게이션 바 뒤로 넣을 수 있을 지 고민해보기...
        height: MediaQuery.of(context).size.height - 335,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              '오늘도 도전',
              style: TextStyle(fontFamily: "kcc", fontSize: 20),
            ),
            Container(
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height - 400,
                child: FutureBuilder<List<MyRoom_Main>>(
                  future: futureRoomListMain,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: CircularProgressIndicator()),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      log("메인 인증방 리스트 연결 실패: ${snapshot.data.toString()}");
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      if (snapshot.data?.length == 0) {
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
                        return CustomScrollView(
                          slivers: <Widget>[
                            SliverGrid(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int idx) {
                                return postContainer(
                                    snapshot.data![idx].room_title.toString(),
                                    snapshot.data![idx].room_img['url']
                                        .toString(),
                                    snapshot.data![idx].room_id);
                              }, childCount: snapshot.data!.length),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                              ),
                            )
                          ],
                        );
                      }
                    } else {
                      return const Text('No data available');
                    }
                  },
                ),
                //오늘도 도전의 스크롤하는 부분
                //     CustomScrollView(
                //   slivers: <Widget>[
                //     SliverGrid(
                //       delegate: SliverChildBuilderDelegate(
                //           (BuildContext context, int idx) {
                //         return postContainer(postList[idx]['room_title'],
                //             postList[idx]['room_img'], 1);
                //       }, childCount: postList.length),
                //       gridDelegate:
                //           const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //       ),
                //     )
                //   ],
                // ),
              ),
            ),
          ],
        )));
  }

  Container postContainer(title, img_root, room_id) {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: todo(title, img_root, room_id),
    );
  }
}
