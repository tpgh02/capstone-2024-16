import 'package:flutter/material.dart';

class l_title extends StatelessWidget {
  final String title;

  const l_title(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Text(
            '$title',
            style: TextStyle(fontFamily: "kcc", fontSize: 30),
          ),
        ],
      ),
    );
  }
}
