import 'package:dodo/components/s_list.dart';
import 'package:dodo/const/colors.dart';
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
  @override
  Widget build(BuildContext context) {
    TextEditingController _search = TextEditingController();
    //Futrue<QuerySnapshot> futureSearchResults; //DB에서 가져오려는 거

    emptyTheTextFromField() {
      _search.clear();
    }

    return Scaffold(
        body: Stack(
      children: [
        Container(
            // width: double.infinity,
            // height: double.infinity,
            alignment: Alignment.bottomCenter,
            color: LIGHTGREY,
            child: Image.asset("../assets/images/turtle_w_e.png")),
        SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: TextFormField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: '검색어를 입력하세요',
                        hintStyle: TextStyle(
                          color: DARKGREY,
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: POINT_COLOR,
                            width: 5,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: PRIMARY_COLOR,
                            width: 5,
                          ),
                        ),
                        //filled: true,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.search,
                            color: POINT_COLOR,
                          ),
                        ),
                      ),
                      style: TextStyle(
                          fontFamily: 'kcc', fontSize: 18, color: Colors.black),
                      //onFieldSubmitted: controlSerching,
                    ),
                  ),
                  const s_list(),
                ],
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
