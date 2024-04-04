import 'package:dodo/components/todo.dart';
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
  List<int> top = <int>[];
  List<int> bottom = <int>[0];
  @override
  Widget build(BuildContext context) {
    return Container(
        //height: 500, //어떻게 하면 네비게이션 바 뒤로 넣을 수 있을 지 고민해보기...
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
                //color: Colors.yellow,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                height: 300,
                child:
                    //오늘도 도전의 스크롤하는 부분
                    CustomScrollView(
                  slivers: <Widget>[
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int idx) {
                          return postContainer(
                            postList[idx]['room_title'],
                            postList[idx]['room_img'],
                          );
                        }, childCount: postList.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ))
                  ],
                ),
              ),
            ),
          ],
        )));
  }

  Container postContainer(title, img_root) {
    return Container(
      margin: const EdgeInsets.all(10),
      alignment: Alignment.center,
      child: todo(title, img_root),
    );
  }
}
