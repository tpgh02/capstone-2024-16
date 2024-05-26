import 'dart:developer';

import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/overview_sea.dart';
import 'package:flutter/material.dart';

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
        log("${widget.img}");
        showDemo(context, overview_sea(widget.c_id, widget.img));
      },
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: widget.isActivate ? Colors.grey : Colors.white,
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              width: 70,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Opacity(
                  opacity: widget.isActivate ? 0.4 : 1,
                  child: Image.network(
                    widget.img,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                "${widget.name}",
                style: TextStyle(
                    fontFamily: "bm",
                    fontSize: 20,
                    color: widget.isActivate ? Colors.black54 : POINT_COLOR),
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
