import 'package:flutter/material.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class room_main extends StatefulWidget {
  final String? room_title;
  const room_main({super.key, required this.room_title});

  @override
  State<room_main> createState() => _roomMainState();
}

class _roomMainState extends State<room_main> {
  @override
  Widget build(BuildContext context) {
    String? room_title = widget.room_title;
    return Scaffold(
      appBar: _roomMainAppBar(room_title),
      backgroundColor: LIGHTGREY,
    );
  }

  PreferredSizeWidget _roomMainAppBar(String? title) {
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
        child: Text(
          "$title",
          style: const TextStyle(
            color: PRIMARY_COLOR,
            fontFamily: "bm",
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
