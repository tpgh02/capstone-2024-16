import 'package:dodo/components/m2_tabbar.dart';
import 'package:flutter/material.dart';

class m2_board extends StatefulWidget {
  final roomId;
  final Key? key;
  const m2_board({required this.roomId, this.key}) : super(key: key);

  @override
  State<m2_board> createState() => _m2_board();
}

class _m2_board extends State<m2_board> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                //spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3)),
          ],
        ),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            m2Tabbar(roomId: widget.roomId), //데이터 전달하기
          ],
        )));
  }
}
