import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/main2_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class galleryPage extends StatefulWidget {
  const galleryPage({super.key});

  @override
  State<galleryPage> createState() => _searchPageState();
}

class _searchPageState extends State<galleryPage> {
  final widgetkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // final tagList = ['운동', '주 3회', '수영', '필라테스'];
    // int idx = 0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //상단 부분
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: POINT_COLOR,
                    ),
                  ),
                  const Text(
                    "사진첩",
                    style: TextStyle(
                        fontFamily: 'bm', fontSize: 30, color: POINT_COLOR),
                  ),
                ],
              ),
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const main2Page()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                    child: const Text(
                      "이미지로 다운받기",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'bm', fontSize: 20),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
