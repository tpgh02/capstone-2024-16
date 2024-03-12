//import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class todo extends StatelessWidget {
  final String room_name;
  final Image room_img;

  const todo(this.room_name, this.room_img);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.amber),
        child: InkWell(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: room_img,
          ),
        ),
      ),
    );
  }
}
