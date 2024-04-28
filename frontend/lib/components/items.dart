//import 'package:dodo/const/colors.dart';
//import 'package:dodo/components/certification.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/buy_screen.dart';
import 'package:flutter/material.dart';

//소유하고 있는 방들의 각각 컴포넌트를 생성
class items extends StatelessWidget {
  final int cost;
  final String img;
  final String name;
  final String info;

  const items(this.cost, this.img, this.name, this.info);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //누르면 팝업 생성하는 함수
        itemsdialog(context, cost, img, name, info);
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
                    child: Image.network(
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
void itemsdialog(context, int cost, String img, String name, info) {
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
            const SizedBox(
              height: 15,
            ),
            Image.network(
              img,
              scale: 4,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: TextStyle(fontFamily: "bm", fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              info,
              style: TextStyle(fontFamily: "bma", fontSize: 25),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.attach_money_rounded,
                  color: Colors.amber,
                ),
                Text(
                  '$cost',
                  style: TextStyle(fontFamily: "bma", fontSize: 25),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            //버튼존
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "닫기",
                    style: TextStyle(
                        color: Colors.black, fontSize: 25, fontFamily: 'bm'),
                  ),
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(150, 50),
                    //backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                      color: PRIMARY_COLOR,
                      width: 3,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => buyPage(img, name)));
                  },
                  child: Text(
                    "구매",
                    style: TextStyle(
                        color: Colors.white, fontSize: 25, fontFamily: 'bm'),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: PRIMARY_COLOR,
                    fixedSize: Size(150, 50),
                  ),
                )
              ],
            ),
          ],
        ),
      ));
    },
  );
}
