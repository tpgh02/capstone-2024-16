import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class s2_hotroom extends StatefulWidget {
  const s2_hotroom({super.key});

  @override
  State<s2_hotroom> createState() => _s2_hotroom();
}

class _s2_hotroom extends State<s2_hotroom> {
  final postList = [
    {
      "room_title": "자취요리왕",
      "room_cap": "거북이도도",
      "room_mem": "10",
      "room_maxmem": "20",
      "room_txt": "자취가 아닌 세계를 울릴 비룡이 되는 그날까지...",
    },
    {
      "room_title": "오운완",
      "room_cap": "김준현",
      "room_mem": "10",
      "room_maxmem": "20",
    },
    {
      "room_title": "H.O.T",
      "room_cap": "강타",
      "room_mem": "10",
      "room_maxmem": "20",
    },
  ];
  int idx = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: DARKGREY, width: 1)),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "${postList[idx]["room_title"]}",
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: "bm",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${postList[idx]["room_cap"]}",
                    style: const TextStyle(
                        fontFamily: "bm", fontSize: 15, color: PRIMARY_COLOR),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  size: 5,
                  Icons.circle,
                  color: PRIMARY_COLOR,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.person,
                  color: PRIMARY_COLOR,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${postList[idx]["room_mem"]} / ${postList[idx]["room_maxmem"]}명",
                    style: const TextStyle(
                        fontFamily: "bm", fontSize: 15, color: PRIMARY_COLOR),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: DARKGREY,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                "${postList[idx]["room_txt"]}",
                style: const TextStyle(
                    fontFamily: "bm", fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ));
  }
}
