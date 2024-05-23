import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/gallery_screen.dart';
import 'package:dodo/screen/report_screen.dart';
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
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    //spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      "리포트를 받고 싶다면?",
                      style: TextStyle(fontFamily: "bm", fontSize: 25),
                    ),
                    const Icon(
                      Icons.local_post_office_sharp,
                      color: POINT_COLOR,
                      size: 100,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const reportPage()));
                          },
                          child: const Text(
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
                ))),
        const SizedBox(
          height: 10,
        ),
        Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    //spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 3)),
              ],
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const Text(
                      "사진을 받고 싶다면?",
                      style: TextStyle(fontFamily: "bm", fontSize: 25),
                    ),
                    const Icon(
                      Icons.photo,
                      color: POINT_COLOR,
                      size: 100,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                        width: double.infinity,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const galleryPage()));
                          },
                          child: const Text(
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
                ))),
      ],
    );
  }
}
