//import 'package:dodo/const/colors.dart';
import 'package:dodo/components/certification.dart';
import 'package:flutter/material.dart';

//소유하고 있는 방들의 각각 컴포넌트를 생성
class items extends StatelessWidget {
  final String cost;
  final String img;

  const items(this.cost, this.img);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //누르면 팝업 생성하는 함수
        itemsdialog(context);
      },
      child:
          //사진을 둥글게 만들 수 있는 함수
          Stack(
        children: [
          Container(
            width: double.infinity,
            //height: double.infinity,

            //width: 80,
            height: 1000,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  //alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: 70,
                  height: 90,
                  //color: Colors.red,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Container(
                //   color: Colors.blue,
                //   height: 10,
                // ),
                Container(
                  //color: Colors.blue,
                  child: Row(
                    children: [
                      Icon(
                        Icons.attach_money_rounded,
                        color: Colors.amber,
                      ),
                      Text(
                        "$cost",
                        style: const TextStyle(
                            fontFamily: "bm",
                            fontSize: 25,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//팝업 생성하는 함수 - 다이얼로그
void itemsdialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: SizedBox(
        width: 300,
        //height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //여기는 그 인증하는 곳으로 이어졌으면 함. 밑에는 일단 예시
            const Text("사진 넣으셨는지~"),
            //Certification("test"),
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
