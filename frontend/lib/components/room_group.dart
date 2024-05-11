import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dodo/components/c_dialog.dart';
import 'package:dodo/components/room_chatscreen.dart';
import 'package:dodo/components/roomuser_list.dart';
import 'package:dodo/components/roomset_basic.dart';
import 'package:dodo/components/roomset_manager.dart';
import 'package:flutter/material.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:horizontal_stepper_step/horizontal_stepper_step.dart';

Future<RoomInfo_Group> fetchGroupRoomInfo(int room_id) async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/room/in/$room_id'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  log('$serverUrl/api/v1/room/in/$room_id');
  if (response.statusCode == 200) {
    log('Group Room Main: Connected!');
    return RoomInfo_Group.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Group Room Main: fail to connect');
  }
}

class RoomInfo_Group {
  final int room_id;
  final String room_title;
  final int maxUser;
  final int nowUser;
  final String endDay;
  final String? periodicity; // final String periodicity;
  final String? room_pwd;
  final String category;
  final String? info;
  final bool canChat;
  final int? numOfVoteSuccess;
  final int? numOfVoteFail;
  final String room_type;
  final String certificationType;
  final int frequency;
  final List<dynamic>? tag; // final String tag;
  final bool isManager;
  final int numOfGoal;
  final List<dynamic> goal;
  // final bool isFull;

  RoomInfo_Group(
      {required this.room_id,
      required this.room_title,
      required this.maxUser,
      required this.nowUser,
      required this.endDay,
      required this.periodicity,
      required this.room_pwd,
      required this.category,
      required this.info,
      required this.canChat,
      required this.numOfVoteSuccess,
      required this.numOfVoteFail,
      required this.room_type,
      required this.certificationType,
      required this.frequency,
      required this.tag,
      required this.isManager,
      required this.numOfGoal,
      required this.goal});

  factory RoomInfo_Group.fromJson(dynamic json) {
    return RoomInfo_Group(
        room_id: json['roomId'],
        room_title: json['name'],
        maxUser: json['maxUser'],
        nowUser: json['nowUser'],
        endDay: json['endDay'],
        periodicity: json['periodicity'],
        room_pwd: json['pwd'],
        category: json['category'],
        info: json['info'],
        canChat: json['canChat'],
        numOfVoteSuccess: json['numOfVoteSuccess'],
        numOfVoteFail: json['numOfVoteFail'],
        room_type: json['roomType'],
        certificationType: json['certificationType'],
        frequency: json['frequency'],
        tag: json['tag'],
        isManager: json['isManager'],
        numOfGoal: json['numOfGoal'],
        goal: json['goal']);
  }
}

class room_group extends StatefulWidget {
  final int room_id;
  const room_group({
    super.key,
    required this.room_id,
  });

  @override
  State<room_group> createState() => _roomMainState();
}

class _roomMainState extends State<room_group> {
  Future<RoomInfo_Group>? nowGroupRoomInfo;

  @override
  void initState() {
    super.initState();
    nowGroupRoomInfo = fetchGroupRoomInfo(widget.room_id);
  }

  final userList = [
    {
      "user_name": "User1",
      "user_id": 1,
      "user_img": "assets/images/cook.jpg",
      "success": 0,
      "wait": 1,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User2",
      "user_id": 2,
      "user_img": "assets/images/cook.jpg",
      "success": 0,
      "wait": 2,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User3",
      "user_id": 3,
      "user_img": "assets/images/cook.jpg",
      "success": 1,
      "wait": 1,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User4",
      "user_id": 4,
      "user_img": "assets/images/cook.jpg",
      "success": 3,
      "wait": 0,
      "max": 3,
      "certification": true,
    },
    {
      "user_name": "User5",
      "user_id": 5,
      "user_img": "assets/images/cook.jpg",
      "success": 0,
      "wait": 3,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User6",
      "user_id": 6,
      "user_img": "assets/images/cook.jpg",
      "success": 3,
      "wait": 0,
      "max": 3,
      "certification": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    int room_id = widget.room_id;

    return FutureBuilder<RoomInfo_Group>(
        future: nowGroupRoomInfo,
        builder: (context, snapshot) {
          // 연결중
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: PreferredSize(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppBar(
                        backgroundColor: LIGHTGREY,
                        leading: const BackButton(
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: LIGHTGREY,
              body: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }
          // 연결 에러
          else if (snapshot.hasError) {
            log("Group Room: Error - ${snapshot.data.toString()}");
            return Scaffold(
              appBar: PreferredSize(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppBar(
                        backgroundColor: LIGHTGREY,
                        leading: const BackButton(
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: LIGHTGREY,
              body: const Center(
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
              ),
            );
          }

          // 서버 연결 성공
          else if (snapshot.hasData) {
            final String nowRoomTitle = snapshot.data!.room_title;
            final bool nowIsManager = snapshot.data!.isManager;
            log("room id: ${snapshot.data!.room_id}");
            log("title: $nowRoomTitle");
            log("maxUser: ${snapshot.data!.maxUser}");
            log("nowUser: ${snapshot.data!.nowUser}");
            log("endDay: ${snapshot.data!.endDay}");
            log("periodicity: ${snapshot.data!.periodicity}");
            log("room_pwd: ${snapshot.data!.room_pwd}");
            log("category: ${snapshot.data!.category}");
            log("info: ${snapshot.data!.info}");
            log("canChat: ${snapshot.data!.canChat}");
            log("numOfVoteSuccess: ${snapshot.data!.numOfVoteSuccess}");
            log("numOfVoteFail: ${snapshot.data!.numOfVoteFail}");
            log("room_type: ${snapshot.data!.room_type}");
            log("certification: ${snapshot.data!.certificationType}");
            log("frequency: ${snapshot.data!.frequency}");
            log("tag: ${snapshot.data!.tag}");
            log("isManager: $nowIsManager");
            log("numOfGoal: ${snapshot.data!.numOfGoal}");
            log("goal: ${snapshot.data!.goal}");
            return Scaffold(
              appBar: _roomMainAppBar(
                  nowRoomTitle,
                  snapshot.data!.info,
                  snapshot.data!.canChat,
                  snapshot.data!.room_pwd,
                  snapshot.data!.nowUser,
                  snapshot.data!.maxUser,
                  snapshot.data!.tag,
                  snapshot.data!.periodicity,
                  snapshot.data!.frequency,
                  snapshot.data!.category,
                  snapshot.data!.certificationType,
                  manager: nowIsManager),
              backgroundColor: LIGHTGREY,
              floatingActionButton: snapshot.data!.canChat
                  ? chattingRoom(nowRoomTitle, nowIsManager, room_id, 1)
                  : null,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    // 목표 기한
                    _progressBar(snapshot.data!.goal, snapshot.data!.numOfGoal,
                        snapshot.data!.endDay, snapshot.data!.isManager),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 17, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // 도전 완료 사용자 수
                          _certificated_person(snapshot.data!.nowUser),
                          // 인증하기 버튼
                          _certification_button(),
                        ],
                      ),
                    ),
                    RoomUserList(
                      room_id: room_id,
                      is_manager: nowIsManager,
                      certificationType: snapshot.data!.certificationType,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text('No data available');
          }
        });
  }

  PreferredSizeWidget _roomMainAppBar(
      String title,
      String? info,
      bool canChat,
      String? room_pwd,
      int nowUser,
      int maxUser,
      List<dynamic>? tag,
      String? periodicity,
      int frequency,
      String category,
      String certificationType,
      {bool manager = false}) {
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: LIGHTGREY,
              leading: const BackButton(
                color: PRIMARY_COLOR,
              ),
              title: Text(
                title,
                style: const TextStyle(
                  color: PRIMARY_COLOR,
                  fontFamily: "bm",
                  fontSize: 30,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: PRIMARY_COLOR,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (manager) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomSetting_Manager(
                              room_title: title,
                              info: info,
                              room_id: widget.room_id,
                              room_pwd: room_pwd,
                              room_mem: nowUser,
                              room_maxmem: maxUser,
                              canChat: canChat,
                              tag: tag),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RoomSetting_Basic(
                            room_title: title,
                            room_id: widget.room_id,
                            room_pwd: room_pwd,
                            canChat: canChat,
                            tag: tag,
                            periodicity: periodicity,
                            frequency: frequency,
                            category: category,
                            certificationType: certificationType,
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: PRIMARY_COLOR,
                    size: 35,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _progressBar(
      List<dynamic> goal, int numOfGoal, String endDay, bool isManager) {
    String endDate = endDay.split("T")[0];
    String endHour = endDay.split("T")[1].split(":")[0];
    String endMin = endDay.split("T")[1].split(":")[1];
    return GestureDetector(
      onTap: () {
        isManager ? log("manager") : null;
      },
      child: SizedBox(
        height: 118,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "지금 목표는? ",
              style: TextStyle(
                color: POINT_COLOR,
                fontFamily: 'bm',
                fontSize: 18,
              ),
            ),
            Text(
              "${goal[0]}",
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontFamily: 'bm',
                fontSize: 22,
              ),
            ),
            // progress bar
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: HorizontalStepper(
                totalStep: numOfGoal,
                completedStep: 0,
                selectedColor: PRIMARY_COLOR,
                backGroundColor: const Color.fromARGB(199, 193, 208, 214),
              ),
            ),
            // D-day

            Text(
              "$endDate $endHour:$endMin까지 도전",
              style: const TextStyle(
                color: POINT_COLOR,
                fontFamily: 'bm',
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Column _certificated_person(int? mem) {
    return Column(
      children: [
        const Text(
          "목표를 위해\n도전한 사람은?",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: POINT_COLOR, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              "1/$mem",
              style: const TextStyle(
                  color: POINT_COLOR,
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              " 명",
              style: TextStyle(
                  color: POINT_COLOR,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox _certification_button() {
    return SizedBox(
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(10),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return c_dialog(widget.room_id); //room_id
            },
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '인증하기',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container chattingRoom(String title, bool manager, int roomID, int userID) {
    return Container(
      height: 80,
      width: 80,
      margin: const EdgeInsets.all(5),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoomChatScreen(
                room_title: title,
                is_manager: manager,
                roomId: roomID,
                userId: userID,
              ),
            ),
          );
        },
        backgroundColor: PRIMARY_COLOR,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(
            color: Color(0xffefefef),
            width: 3,
          ),
        ),
        child: const Icon(
          Icons.chat,
          color: Color(0xffefefef),
          size: 35,
        ),
      ),
    );
  }
}
