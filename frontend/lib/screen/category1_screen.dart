import 'package:dodo/components/c_room.dart';
import 'package:dodo/components/c_title.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class category1Page extends StatefulWidget {
  const category1Page({super.key});

  @override
  State<category1Page> createState() => _category1PageState();
}

class _category1PageState extends State<category1Page> {
  final widgetkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHTGREY,
        body: const Column(
          children: [
            c_title("운동"),
            c_room(num: 0),
            c_room(num: 1),
            c_room(num: 2),
          ],
        ));
  }
}
