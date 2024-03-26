import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class room_join extends StatefulWidget {
  const room_join({super.key}); //테스트용

  // final Map room;
  // const room_join(this.room);

  @override
  State<room_join> createState() => _room_joinState();
}

class _room_joinState extends State<room_join> {
  // late Map room;

  // @override
  // void initState() {
  //   super.initState();
  //   room = widget.room;
  // }
  Map room = {
    "room_title": "자취요리왕",
    "room_cap": "거북이도도",
    "room_mem": "10",
    "room_maxmem": "20",
    "room_txt": "자취가 아닌 세계를 울릴 비룡이 되는 그날까지...",
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: Column(
        children: [
          //appbar
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: DARKGREY)),
              color: Colors.white,
            ),
            height: 80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: POINT_COLOR,
                          size: 40,
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        room['room_title'],
                        style: const TextStyle(
                            fontFamily: 'kcc',
                            fontSize: 25,
                            color: POINT_COLOR),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: const Text(
                      "12명이 함께하는 중",
                      style: TextStyle(
                          fontFamily: 'kcc', fontSize: 15, color: POINT_COLOR),
                    ),
                  )
                ],
              ),
            ),
          ),
          //body
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                  "../assets/images/turtle_noradius.png")),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${room['room_cap']}",
                          style: TextStyle(color: POINT_COLOR),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          color: PRIMARY_COLOR,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${room["room_mem"]} / ${room["room_maxmem"]}명",
                            style: const TextStyle(
                                fontSize: 15, color: PRIMARY_COLOR),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //방소개
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "방 소개",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  //height: 50,
                  padding: EdgeInsets.all(10),
                  child: Text("${room["room_txt"]}"),
                ),
                const SizedBox(
                  height: 10,
                ),
                //목표기한
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "목표 기한",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  //height: 50,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "2024.06.01까지",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                //인증 방식
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "인증 방식",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  width: double.infinity,
                  //height: 50,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "AI, 방장 인증",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),

          //body
        ],
      ),
    );
  }
}
