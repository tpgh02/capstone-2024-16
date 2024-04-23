import 'package:dodo/components/room_group.dart';
import 'package:dodo/components/room_main.dart';
import 'package:flutter/material.dart';

class room_list extends StatefulWidget {
  final String room_title;
  final int room_id;
  final String room_type;
  final String room_img;
  final int room_mem;
  final int room_maxmem;
  final bool canChat;
  final bool is_manager;
  const room_list(
      {super.key,
      required this.room_title,
      required this.room_id,
      required this.room_type,
      required this.room_img,
      required this.room_mem,
      required this.room_maxmem,
      required this.canChat,
      required this.is_manager});

  @override
  State<room_list> createState() => _roomListState();
}

class _roomListState extends State<room_list> {
  @override
  Widget build(BuildContext context) {
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
                      widget.room_img,
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
                        if (widget.room_type == "default") {
                          return room_main(
                            room_title: widget.room_title,
                            room_id: widget.room_id,
                            room_mem: widget.room_mem,
                            room_maxmem: widget.room_maxmem,
                            canChat: widget.canChat,
                            is_manager: widget.is_manager,
                          );
                        } else {
                          return room_group(
                            room_title: widget.room_title,
                            room_id: widget.room_id,
                            room_mem: widget.room_mem,
                            room_maxmem: widget.room_maxmem,
                            canChat: widget.canChat,
                            is_manager: widget.is_manager,
                          );
                        }
                      }));
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.room_title,
                          style: const TextStyle(
                            fontFamily: "bm",
                            fontSize: 25,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.people),
                            Text(' ${widget.room_mem}/${widget.room_maxmem}'),
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
