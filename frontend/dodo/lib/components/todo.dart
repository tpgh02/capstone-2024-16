//import 'package:dodo/const/colors.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

//소유하고 있는 방들의 각각 컴포넌트를 생성
class todo extends StatelessWidget {
  final String room_name;
  final Image room_img;

  const todo(this.room_name, this.room_img);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            //color: Colors.amber,
          ),
          child: InkWell(
            onTap: () {
              //누르면 팝업 생성하는 함수
              tododialog(context);
            },
            child:
                //사진을 둥글게 만들 수 있는 함수
                ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: room_img,
            ),
          ),
        ),
        //방 이름을 사진 위에 얹는 부분
        Container(
          //color: Colors.amber,
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            "$room_name",
            style: const TextStyle(
                fontFamily: "bm", fontSize: 25, color: POINT_COLOR),
          ),
        )
      ],
    );
  }
}

//팝업 생성하는 함수 - 다이얼로그
void tododialog(context) {
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
            //여기는 그 인증하는 곳으로 이어졌으면 함. 밑에는 일단 예시
            const Text("사진 넣으셨는지~"),
            const SizedBox(
              height: 100,
            ),
            IconButton(
              onPressed: () {
                //팝업 지우기
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
