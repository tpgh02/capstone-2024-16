import 'package:dodo/components/s_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/search2_screen.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  final widgetkey = GlobalKey();
  String _enteredSearchQuery = '';
  @override
  void initState() {
    super.initState();
  }

  void _performSearch(String searchQuery) {
    setState(() {
      _enteredSearchQuery = searchQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              alignment: Alignment.bottomCenter,
              color: LIGHTGREY,
              child: Image.asset("assets/images/turtle_w_e.png")),
          SingleChildScrollView(
            child: Column(
              children: [
                // 누르면 버튼 효과
                Container(
                  margin: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      //한번 눌렀을 때 페이지 이동함
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => search2Page()));
                    },

                    // TextField인 척하는 컨테이너
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 50,
                      decoration: const UnderlineTabIndicator(
                          borderSide: BorderSide(color: POINT_COLOR, width: 5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _enteredSearchQuery.isEmpty
                                ? '검색어를 입력하세요'
                                : _enteredSearchQuery,
                            style: const TextStyle(
                                fontFamily: 'kcc',
                                color: POINT_COLOR,
                                fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.search,
                              color: POINT_COLOR,
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const s_list(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
