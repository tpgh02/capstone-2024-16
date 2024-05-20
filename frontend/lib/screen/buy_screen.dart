import 'dart:convert';

import 'package:dodo/components/l_title.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/login_screen.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:dodo/screen/sea_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class buyPage extends StatefulWidget {
  //const buyPage({super.key});
  final String img;
  final String name;

  const buyPage(this.img, this.name);

  @override
  State<buyPage> createState() => _buyPageState();
}

class _buyPageState extends State<buyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.network(
                  widget.img,
                  scale: 4,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "바다 꾸미는 중",
                  style: TextStyle(fontFamily: 'bma', fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => mainPage()));
                      },
                      child: Text(
                        "홈으로 가기",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'bm'),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: PRIMARY_COLOR,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "닫기",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontFamily: 'bm'),
                      ),
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(150, 50),
                        //backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: const BorderSide(
                          color: PRIMARY_COLOR,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset('assets/images/turtle_w_e.png',
                  fit: BoxFit.cover, alignment: Alignment.bottomCenter),
            ),
          ],
        ),
      ),
    );
  }
}
