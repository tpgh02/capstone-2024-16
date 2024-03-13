import 'package:dodo/components/todo.dart';
//import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

//m_state 아래부터 네비게이션 바 위까지 구성
//안의 방들은 todo.dart 파일에 있음
class m_todo extends StatefulWidget {
  const m_todo({super.key});

  @override
  State<m_todo> createState() => _m_todoState();
}

class _m_todoState extends State<m_todo> {
  final postList = [
    {"room_title": "자취요리왕", "room_img": "assets/images/cook.jpg"},
    {"room_title": "오운완", "room_img": "assets/images/turtle_noradius.png"},
    {"room_title": "H.O.T", "room_img": "assets/images/turtle_noradius.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                color: Colors.yellow,
                height: 300,
                child: ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (BuildContext context, int idx) {
                    return postContainer(
                      postList[idx]['room_title'],
                      postList[idx]['room_img'],
                    );
                  },
                ),
              ),
            ),
          ],
        )));
  }

  Container postContainer(title, img_root) {
    return Container(
      child: Stack(
        children: [
          todo(title, img_root),
          //방 이름을 사진 위에 얹는 부분
          Container(
            //color: Colors.amber,
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              title,
              style: const TextStyle(
                  fontFamily: "bm", fontSize: 25, color: Colors.white),
            ),
          )
        ],
      ),
      //stack 끝
    );
  }
}
