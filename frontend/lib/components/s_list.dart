import 'package:dodo/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class s_list extends StatefulWidget {
  const s_list({super.key});

  // const s_list(this.menu);
  // final String menu;

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
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            //운동 카테고리
            Opacity(
              opacity: 1,
              child: Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                  "../assets/images/turtle_noradius.png")),
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
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [Text("참여중"), Text("112,788명 활동중")],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //식단
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                                "../assets/images/turtle_noradius.png")),
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
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [Text("참여중"), Text("112,788명 활동중")],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            //공부 카테고리
            Container(
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                                "../assets/images/turtle_noradius.png")),
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
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [Text("참여중"), Text("112,788명 활동중")],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            //기타 카테고리
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                                "../assets/images/turtle_noradius.png")),
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
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [Text("참여중"), Text("112,788명 활동중")],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
