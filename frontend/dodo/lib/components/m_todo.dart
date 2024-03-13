import 'package:dodo/components/todo.dart';
import 'package:flutter/material.dart';

//m_state 아래부터 네비게이션 바 위까지 구성
//안의 방들은 todo.dart 파일에 있음
class m_todo extends StatelessWidget {
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
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        //todo로 타이틀이랑 사진을 전달
                        child: todo(
                          "자취요리왕",
                          Image.asset(
                            "assets/images/cook.jpg",
                            fit: BoxFit.cover,
                          ),
                        )),
                    Container(
                        margin: const EdgeInsets.all(10),
                        //todo로 타이틀이랑 사진을 전달
                        child: todo(
                          "no_name",
                          Image.asset(
                            "assets/images/Turtle_noradius.png",
                            fit: BoxFit.cover,
                          ),
                        )),
                  ],
                ),
              ]),
            ),
          ],
        )));
  }
}
