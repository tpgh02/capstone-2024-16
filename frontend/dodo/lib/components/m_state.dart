import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

//main 화면에서 상태 멘트를 날려주는 컴포넌트

class m_state extends StatelessWidget {
  final String state;
  //사용예시) m_stste("더 분발하세요")
  const m_state(this.state);

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 30);
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              textStyle: const TextStyle(fontSize: 20),
              minimumSize: Size(500, 100),
            ),
            onPressed: () {
              statedialog(context, 70);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "$state",
                //스타일은 위에 지정해둠.
                style: style,
              ),
            )));
  }
}

//팝업 띄우는 함수
void statedialog(context, state) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //오늘의 todo 달성률을 보여주는 팝업
            const Text(
              "오늘의 달성률",
              style: TextStyle(fontFamily: "kcc", fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "$state%",
              style: const TextStyle(fontFamily: 'kcc', fontSize: 80),
            ),
            const SizedBox(
              height: 10,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ));
    },
  );
}
