import 'package:flutter/material.dart';

class room_list extends StatefulWidget {
  final String room_name;
  final String room_img;

  const room_list({
    super.key,
    required this.room_name,
    required this.room_img,
  });

  @override
  State<room_list> createState() => _roomListState();
}

class _roomListState extends State<room_list> {
  @override
  Widget build(BuildContext context) {
    String roomName = widget.room_name;
    String roomImg = widget.room_img;

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
                      roomImg,
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
                          '$roomName',
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
