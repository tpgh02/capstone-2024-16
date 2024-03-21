import 'package:dodo/components/s2_hotroom.dart';
import 'package:dodo/components/s2_tag.dart';
import 'package:dodo/components/s_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class search2Page extends StatefulWidget {
  const search2Page({super.key});

  @override
  State<search2Page> createState() => _searchPageState();
}

class _searchPageState extends State<search2Page> {
  final widgetkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final tagList = ['운동', '주 3회', '수영', '필라테스'];
    int idx = 0;
    TextEditingController _search = TextEditingController();
    //Futrue<QuerySnapshot> futureSearchResults; //DB에서 가져오려는 거

    //검색창에 적었던 거 지우기
    emptyTextFromField() {
      _search.clear();
    }

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
                        emptyTextFromField();
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: POINT_COLOR,
                      )),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _search,
                        decoration: InputDecoration(
                          hintText: '검색어를 입력하세요',
                          hintStyle: TextStyle(
                            color: DARKGREY,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: POINT_COLOR,
                              width: 5,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: PRIMARY_COLOR,
                              width: 5,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: POINT_COLOR,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                            fontFamily: 'kcc',
                            fontSize: 18,
                            color: Colors.black),
                        //onFieldSubmitted: controlSerching,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "핫 인증방 추천",
                  style: TextStyle(
                      fontFamily: "bm", fontSize: 20, color: DARKGREY),
                ),
              ),
              s2_hotroom(),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "추천 검색 태그",
                  style: TextStyle(
                      fontFamily: "bm", fontSize: 20, color: DARKGREY),
                ),
              ),

              s2_tag(),
            ],
          ),
        ),
      ),
    );
  }
}
