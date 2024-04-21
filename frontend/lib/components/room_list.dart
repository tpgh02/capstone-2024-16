import 'package:dodo/components/room_group.dart';
import 'package:dodo/components/room_main.dart';
import 'package:flutter/material.dart';

class room_list extends StatefulWidget {
  final int num;
  const room_list({super.key, required this.num});

  @override
  State<room_list> createState() => _roomListState();
}

class _roomListState extends State<room_list> {
  final List<dynamic> postList = [
    {
      "room_title": "자취요리왕",
      "room_id": 1,
      "room_type": "default",
      "room_img": "assets/images/cook.jpg",
      "room_mem": 10,
      "room_maxmem": 20,
      "canChat": true,
      "is_manager": true,
    },
    {
      "room_title": "오운완",
      "room_id": 2,
      "room_type": "default",
      "room_img": "assets/images/turtle_noradius.png",
      "room_mem": 5,
      "room_maxmem": 20,
      "canChat": false,
      "is_manager": false,
    },
    {
      "room_title": "H.O.T",
      "room_id": 3,
      "room_type": "group",
      "room_img": "assets/images/turtle_noradius.png",
      "room_mem": 10,
      "room_maxmem": 20,
      "canChat": true,
      "is_manager": true,
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        if (postList[num]["room_type"] == "default") {
                          return room_main(
                            room_title: postList[num]["room_title"],
                            room_id: postList[num]["room_id"],
                            room_mem: postList[num]["room_mem"],
                            room_maxmem: postList[num]["room_maxmem"],
                            canChat: postList[num]["canChat"],
                            is_manager: postList[num]["is_manager"],
                          );
                        } else {
                          return room_group(
                            room_title: postList[num]["room_title"],
                            room_id: postList[num]["room_id"],
                            room_mem: postList[num]["room_mem"],
                            room_maxmem: postList[num]["room_maxmem"],
                            canChat: postList[num]["canChat"],
                            is_manager: postList[num]["is_manager"],
                          );
                        }
                      }));
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
                        Row(
                          children: [
                            const Icon(Icons.people),
                            Text(
                                ' ${postList[num]["room_mem"]}/${postList[num]["room_maxmem"]}'),
                          ],
                        ),
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
