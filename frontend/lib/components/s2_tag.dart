import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class s2_tag extends StatefulWidget {
  final List<dynamic>? tag;
  const s2_tag({super.key, required this.tag});

  @override
  State<s2_tag> createState() => _s2_tag();
}

class _s2_tag extends State<s2_tag> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: widget.tag!.map((hashtag) {
            return Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              //width: 100,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  border: Border.all(color: DARKGREY, width: 1)),
              child: Text(
                "${hashtag}",
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: "bm",
                  //color: Colors.black54,
                ),
              ),
            );
          }).toList(),
        ));
  }
}
