import 'package:dodo/components/todo.dart';
import 'package:flutter/material.dart';

class m_todo extends StatelessWidget {
  //int? room_num;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Text(
                '오늘도 도전',
                style: TextStyle(fontFamily: "kcc", fontSize: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        child: todo(
                          "자취요리왕",
                          Image.asset(
                            "assets/images/cook.jpg",
                            fit: BoxFit.cover,
                          ),
                        )),
                    todo(
                      "no_name",
                      Image.asset(
                        "assets/images/Turtle_noradius.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ],
        ));
  }
}
