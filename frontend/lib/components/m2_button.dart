import 'package:dodo/components/m2_tabbar.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class m2_button extends StatefulWidget {
  const m2_button({super.key});

  @override
  State<m2_button> createState() => _m2_button();
}

class _m2_button extends State<m2_button> {
  final postList = [
    {"room_title": "자취요리왕", "room_img": "assets/images/cook.jpg"},
    {"room_title": "오운완", "room_img": "assets/images/turtle_noradius.png"},
    {"room_title": "H.O.T", "room_img": "assets/images/turtle_noradius.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), color: Colors.white),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  "리포트를 받고 싶다면?",
                  style: TextStyle(fontFamily: "bm", fontSize: 25),
                ),
                Icon(
                  Icons.local_post_office_sharp,
                  color: Colors.blue,
                  size: 100,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "보러가기",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'bm',
                            fontSize: 20),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                      ),
                    )),
              ],
            )));
  }
}
