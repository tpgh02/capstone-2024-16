import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class s2_tag extends StatefulWidget {
  const s2_tag({super.key});

  @override
  State<s2_tag> createState() => _s2_tag();
}

class _s2_tag extends State<s2_tag> {
  //임시로 둔 데이터
  final tagList = ['운동', '주 3회', '수영', '필라테스'];
  int idx = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(10),
          //width: 100,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
              border: Border.all(color: DARKGREY, width: 1)),
          child: Text(
            "${tagList[idx]}",
            style: const TextStyle(
              fontSize: 15,
              fontFamily: "bm",
              //color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
