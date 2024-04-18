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

//방 가입시 나오는 팝업창(테스트 용도로 제작)
void statedialog(context, state) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: Container(
        margin: EdgeInsets.all(8),
        width: 400,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Text(
              "가입이 승인되었습니다",
              style: TextStyle(fontFamily: "bm", fontSize: 30),
            ),
            const SizedBox(
              height: 15,
            ),
            // Text(
            //   "$state%",
            //   style: const TextStyle(fontFamily: 'kcc', fontSize: 80),
            // ),
            Image.asset(
              "../assets/images/turtle.png",
              scale: 2,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "대단해요!",
              style: TextStyle(fontFamily: "bma", fontSize: 25),
            ),
            const Text(
              "앞으로도 멋진 모습 기대할게요!",
              style: TextStyle(fontFamily: "bma", fontSize: 25),
            ),
            const SizedBox(
              height: 15,
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
