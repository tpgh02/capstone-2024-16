import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/room_join.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class c_room extends StatefulWidget {
  final int num;
  const c_room({super.key, required this.num});

  @override
  State<c_room> createState() => _c_roomState();
}

class _c_roomState extends State<c_room> {
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
      "room_txt":
          "오늘의 운동을 인증했단 의미로 어쩌고 저쩌고 너가 해라 운동 안하면 큰일나오늘의 운동을 인증했단 의미로 어쩌고 저쩌고 너가 해라 운동 안하면 큰일나",
    },
    {
      "room_title": "H.O.T",
      "room_cap": "강타",
      "room_mem": "10",
      "room_maxmem": "20",
      "room_txt": "세계를 강타할 핫 바디 ㄱㄱ",
    },
  ];
  @override
  Widget build(BuildContext context) {
    int num = widget.num;
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => room_join())); //postList[0])));
        },
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "${postList[num]["room_title"]}",
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
                    "${postList[num]["room_cap"]}",
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
                    "${postList[num]["room_mem"]} / ${postList[num]["room_maxmem"]}명",
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
                "${postList[num]["room_txt"]}",
                style: const TextStyle(
                    fontFamily: "bm", fontSize: 15, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
