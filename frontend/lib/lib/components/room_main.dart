import 'package:flutter/material.dart';
import 'package:dodo/const/colors.dart';

class room_main extends StatefulWidget {
  final String? room_title;
  final int? room_mem;
  final int? room_maxmem;
  const room_main(
      {super.key,
      required this.room_title,
      required this.room_mem,
      required this.room_maxmem});

  @override
  State<room_main> createState() => _roomMainState();
}

class _roomMainState extends State<room_main> {
  @override
  Widget build(BuildContext context) {
    String? room_title = widget.room_title;
    int? room_mem = widget.room_mem;
    // int? room_maxmem = widget.room_maxmem;

    return Scaffold(
      appBar: _roomMainAppBar(room_title),
      backgroundColor: LIGHTGREY,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            // 목표 기한
            _d_day(room_title),
            Container(
              margin: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 도전 완료 사용자 수
                  _certificated_person(room_mem),
                  // 인증하기 버튼

                  _certification_button(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _roomMainAppBar(String? title) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        width: 390,
        height: 80,
        // Border Line
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0x7F414C58),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: LIGHTGREY,
              leading: const BackButton(
                color: PRIMARY_COLOR,
              ),
              title: Text(
                "$title",
                style: const TextStyle(
                  color: PRIMARY_COLOR,
                  fontFamily: "bm",
                  fontSize: 30,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: PRIMARY_COLOR,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: PRIMARY_COLOR,
                    size: 35,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _d_day(String? title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(199, 193, 208, 214),
      ),
      height: 100,
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Row(
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            size: 40,
          ),
          const SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$title의 목표기한",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "D - 30",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Column _certificated_person(int? mem) {
    return Column(
      children: [
        const Text(
          "이번 주의 도전을\n완료한 사람은?",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: POINT_COLOR, fontSize: 21, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
              "1/$mem",
              style: const TextStyle(
                  color: POINT_COLOR,
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              " 명",
              style: TextStyle(
                  color: POINT_COLOR,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  SizedBox _certification_button() {
    return SizedBox(
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: PRIMARY_COLOR,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.all(10),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              '인증하기',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
