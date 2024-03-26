import 'package:dodo/components/c_room.dart';
import 'package:dodo/components/c_title.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class category3Page extends StatefulWidget {
  const category3Page({super.key});

  @override
  State<category3Page> createState() => _category3PageState();
}

class _category3PageState extends State<category3Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHTGREY,
        body: const Column(
          children: [
            c_title('공부'),
            c_room(num: 0),
            c_room(num: 1),
            c_room(num: 2),
          ],
        ));
  }
}
