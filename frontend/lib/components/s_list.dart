import 'package:dodo/screen/category1_screen.dart';
import 'package:dodo/screen/category2_screen.dart';
import 'package:dodo/screen/category3_screen.dart';
import 'package:dodo/screen/category4_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class s_list extends StatefulWidget {
  const s_list({super.key});

  @override
  State<s_list> createState() => _s_listState();
}

class _s_listState extends State<s_list> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            //운동 카테고리
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => category1Page()));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                  "assets/images/turtle_noradius.png")),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "운동",
                          style: TextStyle(fontFamily: 'kcc', fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("참여중"),
                            ],
                          ),
                          const Text("112,788명 활동중")
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //식단 카테고리
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => category2Page()));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                  "assets/images/turtle_noradius.png")),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "식단",
                          style: TextStyle(fontFamily: 'kcc', fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("참여중"),
                            ],
                          ),
                          const Text("112,788명 활동중")
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //공부 카테고리
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => category3Page()));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                  "assets/images/turtle_noradius.png")),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "공부",
                          style: TextStyle(fontFamily: 'kcc', fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("참여중"),
                            ],
                          ),
                          const Text("112,788명 활동중")
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //기타 카테고리
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => category4Page()));
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                  "assets/images/turtle_noradius.png")),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "기타",
                          style: TextStyle(fontFamily: 'kcc', fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text("참여중"),
                            ],
                          ),
                          const Text("112,788명 활동중")
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
