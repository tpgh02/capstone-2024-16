//import 'package:dodo/const/colors.dart';
//import 'package:dodo/components/certification.dart';
import 'dart:convert';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/buy_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class i_items extends StatefulWidget {
  final int cost;
  final String img;
  final String name;
  final String info;
  final int c_id;

  const i_items(this.cost, this.img, this.name, this.info, this.c_id);

  @override
  State<i_items> createState() => _itemsState();
}

class _itemsState extends State<i_items> {
  bool turn = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //누르면 좌표입력하기
        setState() {
          turn = !turn;
          print("turn");
        }
      },
      child: Container(
        width: double.infinity,
        height: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: turn ? Colors.grey : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              //alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: 70,
              height: 90,
              //color: Colors.red,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              //color: Colors.blue,
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money_rounded,
                    color: Colors.amber,
                  ),
                  Text(
                    "${widget.cost}",
                    style: const TextStyle(
                        fontFamily: "bm", fontSize: 25, color: Colors.black),
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
