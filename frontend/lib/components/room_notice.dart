import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class RoomNotice extends StatefulWidget {
  final String room_title;
  final String? room_notice;
  final bool is_manager;
  const RoomNotice({
    super.key,
    required this.room_title,
    this.room_notice,
    required this.is_manager,
  });

  @override
  State<RoomNotice> createState() => _roomNoticeState();
}

class _roomNoticeState extends State<RoomNotice> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showEntireNotice();
      },
      child: Container(
        height: 80,
        width: MediaQuery.of(context).size.width,
        constraints: const BoxConstraints(minHeight: 50),
        decoration: ShapeDecoration(
          color: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: POINT_COLOR,
              strokeAlign: BorderSide.strokeAlignInside,
              width: 2,
            ),
          ),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 공지 아이콘
            ClipOval(
              child: Container(
                color: PRIMARY_COLOR,
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.announcement_outlined,
                  color: Color.fromARGB(235, 255, 255, 255),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),

            // 공지 텍스트
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        text: widget.room_notice ?? "등록된 공지사항이 없습니다.",
                        style: const TextStyle(
                          color: POINT_COLOR,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 상단 공지사항 전체 보기
  void showEntireNotice() {
    showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          backgroundColor: LIGHTGREY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(
            "${widget.room_title}의 공지사항",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: POINT_COLOR),
          ),
          // 공지 내용
          content: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: widget.room_notice != null
                  ? Text(
                      widget.room_notice!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w500),
                    )
                  : const Text(
                      "등록된 공지사항이 없습니다.",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
            ),
          ),

          // 하단 버튼
          actions: <Widget>[
            widget.is_manager
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: POINT_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      side: const BorderSide(
                        color: POINT_COLOR,
                        width: 1.0,
                      ),
                    ),
                    child: const Text(
                      "수정",
                      style: TextStyle(
                          color: Color.fromARGB(226, 255, 255, 255),
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox(height: 0.1),

            // 창 닫기
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: POINT_COLOR,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(
                  color: POINT_COLOR,
                  width: 1.0,
                ),
              ),
              child: const Text("닫기",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }),
    );
  }
}
