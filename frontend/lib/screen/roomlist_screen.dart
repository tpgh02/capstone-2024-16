import 'package:custom_floating_action_button/custom_floating_action_button.dart';
import 'package:dodo/components/room_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/AIroom_cr.dart';
import 'package:dodo/screen/Room_cr.dart';
import 'package:flutter/material.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListState();
}

class _RoomListState extends State<RoomListPage> {
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
        body: roomList.isNotEmpty
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: roomList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return room_list(
                          room_title: roomList[index]["room_title"],
                          room_id: roomList[index]["room_id"],
                          room_pwd: roomList[index]["room_pwd"],
                          room_type: roomList[index]["room_type"],
                          room_img: roomList[index]["room_img"],
                          room_mem: roomList[index]["room_mem"],
                          room_maxmem: roomList[index]["room_maxmem"],
                          canChat: roomList[index]["canChat"],
                          is_manager: roomList[index]["is_manager"],
                          certificationType: roomList[index]
                              ["certificationType"],
                        );
                      },
                    ),
                  ],
                ),
              )
            // 가입한 방 없을 때
            : const Center(
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
              ),
      ),
      options: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AIroom_cr()));
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
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
                      MaterialPageRoute(builder: (context) => Room_cr()));
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                '그룹 인증방 생성',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'bma', fontSize: 20),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () {},
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
