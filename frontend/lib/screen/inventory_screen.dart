import 'package:dodo/components/items.dart';
import 'package:dodo/components/s2_hotroom.dart';
import 'package:dodo/components/s2_tag.dart';
import 'package:dodo/components/s_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/main2_screen.dart';
import 'package:dodo/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class invenPage extends StatefulWidget {
  const invenPage({super.key});

  @override
  State<invenPage> createState() => _searchPageState();
}

class _searchPageState extends State<invenPage> {
  final widgetkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final postList = [
      {"name": "미역", "cost": "10", "img": "assets/images/cook.jpg"},
      {"name": "돌", "cost": "10", "img": "assets/images/turtle_noradius.png"},
      {"name": "개불", "cost": "10", "img": "assets/images/turtle_noradius.png"},
      {"name": "미역", "cost": "10", "img": "assets/images/cook.jpg"},
      {"name": "돌", "cost": "10", "img": "assets/images/turtle_noradius.png"},
      {"name": "개불", "cost": "10", "img": "assets/images/turtle_noradius.png"},
      {"name": "미역", "cost": "10", "img": "assets/images/cook.jpg"},
      {"name": "돌", "cost": "10", "img": "assets/images/turtle_noradius.png"},
      {"name": "개불", "cost": "10", "img": "assets/images/turtle_noradius.png"},
    ];
    int idx = 0;
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
                    "보관함",
                    style: TextStyle(
                        fontFamily: 'bm', fontSize: 30, color: POINT_COLOR),
                  ),
                ],
              ),
              Container(
                // color: Colors.red,
                //padding: EdgeInsets.fromLTRB(150, 300, 150, 200),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 120,
                    height: 200,
                    child: Image.asset(
                        "../assets/images/sea.png"), //서버에서 받은 이미지로 부르기
                  ),
                ),
              ),
              Container(
                //color: Colors.yellow,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                height: 400,
                //height: double.maxFinite,
                //color: Colors.amber,
                child:
                    //오늘도 도전의 스크롤하는 부분
                    CustomScrollView(
                  slivers: <Widget>[
                    SliverGrid(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int idx) {
                          return postContainer(
                            postList[idx]['cost'],
                            postList[idx]['img'],
                          );
                        }, childCount: postList.length),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ))
                  ],
                ),
              ),
              Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => reportPage()));
                    },
                    child: Text(
                      "적용하기",
                      style: TextStyle(
                          color: Colors.white, fontFamily: 'bm', fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Container postContainer(title, _root) {
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: items(title, _root),
    );
  }
}
