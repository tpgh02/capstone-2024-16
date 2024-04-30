//import 'package:dodo/const/colors.dart';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dodo/components/c_dialog.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//소유하고 있는 방들의 각각 컴포넌트를 생성
class todo extends StatefulWidget {
  final String room_name;
  final String room_img;

  const todo(this.room_name, this.room_img);

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {
  @override
  Widget build(BuildContext context) {
    int room_id = 1;
    return Stack(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () {
              //누르면 팝업 생성하는 함수
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return c_dialog(room_id);
                },
              );
            },
            child:
                //사진을 둥글게 만들 수 있는 함수
                ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.room_img,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        //방 이름을 사진 위에 얹는 부분
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.fromLTRB(15, 15, 50, 50),
          child: Text(
            "${widget.room_name}",
            style: const TextStyle(
                fontFamily: "bm", fontSize: 25, color: Colors.white),
          ),
        )
      ],
    );
  }
}
