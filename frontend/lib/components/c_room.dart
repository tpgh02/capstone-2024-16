import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/room_join.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class c_room extends StatefulWidget {
  final int roomId;
  final String room_title;
  final image;
  final int maxUser;
  final int nowUser;
  final String endDay;
  final String periodicity;
  final String? room_pwd;
  final String? info;
  final bool canChat;
  final String room_type;
  final String certificationType;
  final int frequency;
  final List<dynamic>? tag;

  const c_room(
      {super.key,
      required this.roomId,
      required this.room_title,
      required this.image,
      required this.maxUser,
      required this.nowUser,
      required this.endDay,
      required this.periodicity,
      required this.room_pwd,
      required this.info,
      required this.canChat,
      required this.room_type,
      required this.certificationType,
      required this.frequency,
      required this.tag});

  @override
  State<c_room> createState() => _c_roomState();
}

class _c_roomState extends State<c_room> {
  // final postList = [
  //   {
  //     "room_title": "자취요리왕",
  //     "room_cap": "거북이도도",
  //     "room_mem": "10",
  //     "room_maxmem": "20",
  //     "room_txt": "자취가 아닌 세계를 울릴 비룡이 되는 그날까지...",
  //   },
  //   {
  //     "room_title": "오운완",
  //     "room_cap": "김준현",
  //     "room_mem": "10",
  //     "room_maxmem": "20",
  //     "room_txt":
  //         "오늘의 운동을 인증했단 의미로 어쩌고 저쩌고 너가 해라 운동 안하면 큰일나오늘의 운동을 인증했단 의미로 어쩌고 저쩌고 너가 해라 운동 안하면 큰일나",
  //   },
  //   {
  //     "room_title": "H.O.T",
  //     "room_cap": "강타",
  //     "room_mem": "10",
  //     "room_maxmem": "20",
  //     "room_txt": "세계를 강타할 핫 바디 ㄱㄱ",
  //   },
  // ];
  @override
  Widget build(BuildContext context) {
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
                  builder: (context) => room_join(
                        roomId: widget.roomId,
                        room_title: widget.room_title,
                        image: widget.image,
                        maxUser: widget.maxUser,
                        nowUser: widget.nowUser,
                        endDay: widget.endDay,
                        periodicity: widget.periodicity,
                        room_pwd: widget.room_pwd,
                        info: widget.info,
                        canChat: widget.canChat,
                        room_type: widget.room_type,
                        certificationType: widget.certificationType,
                        frequency: widget.frequency,
                        tag: widget.tag,
                      ))); //postList[0])));
        },
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "${widget.room_title}",
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: "bm",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Container(
                //   alignment: Alignment.centerRight,
                //   child: Text(
                //     "manager",
                //     style: const TextStyle(
                //         fontFamily: "bm", fontSize: 15, color: PRIMARY_COLOR),
                //   ),
                // ),
                // const SizedBox(
                //   width: 5,
                // ),
                // const Icon(
                //   size: 5,
                //   Icons.circle,
                //   color: PRIMARY_COLOR,
                // ),
                // const SizedBox(
                //   width: 5,
                // ),
                const Icon(
                  Icons.person,
                  color: PRIMARY_COLOR,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${widget.nowUser} / ${widget.maxUser}명",
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
              child: widget.info == null || widget.info == ""
                  ? const Text(
                      "소개가 없습니다.",
                      style: TextStyle(
                          fontFamily: "bma", fontSize: 16, color: Colors.black),
                    )
                  : Text(
                      "${widget.info}",
                      style: const TextStyle(
                          fontFamily: "bma", fontSize: 16, color: Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
