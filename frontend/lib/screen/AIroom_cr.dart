import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/AIroom_cr2.dart';
import 'package:flutter/material.dart';

class AIroom_cr extends StatefulWidget {
  const AIroom_cr({super.key});

  @override
  State<AIroom_cr> createState() => _AIroom_crState();
}

class _AIroom_crState extends State<AIroom_cr> {
  List _roomname = ['카테고리 더보기', '헬스', '기상', '공부'];
  Object? _select = '카테고리 더보기';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      appBar: PreferredSize(
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
          padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
          child: const Text(
            'AI 인증방 생성 주의사항',
            style: TextStyle(
              color: PRIMARY_COLOR,
              fontFamily: "bm",
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "- AI가 생성할 수 있는 인증방 종류는 다음과 같습니다 ",
              style: TextStyle(fontFamily: "bma", fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(width: double.infinity, child: _roomBtn()),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "- 만약 상단의 카테고리에 속하지 않는 인증방을 생성하고 싶을 경우, AI인증방이 아닌 일반 인증방을 생성하시는 것을 권장합니다.",
              style: TextStyle(fontFamily: "bma", fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "- AI인증은 정확하지 않을 수 있습니다.",
              style: TextStyle(fontFamily: "bma", fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                      foregroundColor: Colors.black,
                      shadowColor: Colors.black,
                      side: BorderSide(color: PRIMARY_COLOR),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  child:
                      const Text("이전", style: TextStyle(color: PRIMARY_COLOR)),
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AIroom_cr2()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      elevation: 2,
                      foregroundColor: Colors.black,
                      shadowColor: Colors.black,
                      side: BorderSide(color: PRIMARY_COLOR),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                  child: const Text(
                    "다음",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _roomBtn() {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR, width: 3),
          borderRadius: BorderRadius.circular(50)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          value: _select,
          underline: const SizedBox.shrink(),
          focusColor: LIGHTGREY,
          iconEnabledColor: POINT_COLOR,
          icon: const Icon(Icons.arrow_drop_down),
          items: _roomname.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value,
                    style: const TextStyle(fontFamily: 'bm', fontSize: 20),
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (value) {
            setState(() {
              _select = value;
            });
          },
        ),
      ),
    );
  }
}
