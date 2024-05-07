//import 'package:dodo/const/colors.dart';
//import 'package:dodo/components/certification.dart';
import 'dart:convert';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/buy_screen.dart';
import 'package:dodo/screen/overview_sea.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class i_items extends StatefulWidget {
  final int cost;
  final String img;
  final String name;
  final String info;
  final bool isActivate;
  final int c_id;

  const i_items(
      this.cost, this.img, this.name, this.info, this.isActivate, this.c_id);

  @override
  State<i_items> createState() => _i_itemsState();
}

class _i_itemsState extends State<i_items> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //누르면 좌표입력하기

        showDemo(context, overview_sea(widget.c_id));
      },
      child: Container(
        width: double.infinity,
        height: 1000,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.isActivate ? Colors.grey : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: 70,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.img,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              child: Row(
                children: [
                  const Icon(
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

  void showDemo(BuildContext ctx, Widget demo) {
    Navigator.of(ctx).push(MaterialPageRoute(builder: (ctx) => demo));
  }
}
