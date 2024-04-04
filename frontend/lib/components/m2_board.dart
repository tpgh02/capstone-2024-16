import 'package:dodo/components/m2_tabbar.dart';
import 'package:flutter/material.dart';

class m2_board extends StatefulWidget {
  const m2_board({super.key});

  @override
  State<m2_board> createState() => _m2_board();
}

class _m2_board extends State<m2_board> {
  final postList = [
    {"room_title": "자취요리왕", "room_img": "assets/images/cook.jpg"},
    {"room_title": "오운완", "room_img": "assets/images/turtle_noradius.png"},
    {"room_title": "H.O.T", "room_img": "assets/images/turtle_noradius.png"},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        child: const SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            m2Tabbar(),
          ],
        )));
  }
}
