import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

//main 화면에서 상태 멘트를 날려주는 컴포넌트

class m_state extends StatelessWidget {
  final state;
  //사용예시) m_stste("더 분발하세요")
  const m_state(this.state);

  @override
  Widget build(BuildContext context) {
    const TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 25);
    final week = ["15", "16", "17", "18", "19", "20", "21"];
    return Column(
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
              minimumSize: Size(500, 100),
              elevation: 5, //그림자
            ),
            onPressed: () {
              statedialog(context, 70);
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "주간목표",
                    //스타일은 위에 지정해둠.
                    style: style,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < state.length; i++)
                        Container(
                          margin: const EdgeInsets.all(10),
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                state[i] == 0 ? Colors.grey[400] : Colors.white,
                          ),
                          child: Center(
                            child: state[i] == 0
                                ? Text(
                                    week[i],
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'kcc',
                                        color: Colors.black38),
                                  )
                                : Image.asset(
                                    'assets/images/turtle.png', // 이미지 파일 경로
                                    width: 30,
                                    height: 30,
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
