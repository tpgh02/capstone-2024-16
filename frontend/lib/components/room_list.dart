import 'package:flutter/material.dart';

class room_list extends StatefulWidget {
  final int num;
  const room_list({super.key, required this.num});

  @override
  State<room_list> createState() => _roomListState();
}

class _roomListState extends State<room_list> {
  final postList = [
    {
      "room_title": "자취요리왕",
      "room_img": "assets/images/cook.jpg",
    },
    {
      "room_title": "오운완",
      "room_img": "assets/images/turtle_noradius.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    int num = widget.num;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: SizedBox(
            height: 100,
            child: Row(
              children: [
                // 인증방 썸네일 이미지
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipOval(
                    child: Image.asset(
                      "${postList[num]["room_img"]}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // 방 제목 및 속성
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(child: Text('히히'));
                          });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "${postList[num]["room_title"]}",
                          style: const TextStyle(
                            fontFamily: "bm",
                            fontSize: 25,
                          ),
                        ),
                        Text('방 속성'),
                      ],
                    ),
                  ),
                ),
                // 도장
                Text('도장'),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

//   Widget roomList() {
//     return const Padding(
//       padding: EdgeInsets.all(20),
//       child: SizedBox(
//         height: 80,
//         child: Row(
//           children: [
//             Text('이미지'),
//             SizedBox(width: 15),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('$room_name'),
//                   Text('방 설명'),
//                 ],
//               ),
//             ),
//             Text('도장'),
//           ],
//         ),
//       ),
//     );
//   }
}
