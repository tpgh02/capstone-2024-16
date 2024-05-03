//import 'package:dodo/const/colors.dart';
//import 'package:dodo/components/certification.dart';
import 'dart:convert';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/buy_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Map> fetchBuy(int creatureId) async {
  Map<String, dynamic> requestBody = {
    'creatureId': creatureId,
  };
  final response = await http.post(
    Uri.parse(serverUrl + '/api/v1/creature/purchase'),
    headers: {
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
    },
    body: jsonEncode(requestBody),
  );

  try {
    if (response.statusCode == 200) {
      print('연결 성공!');
      Map responseData = json.decode(response.body);
      // Map responseData = jsonDecode(
      //     utf8.decode(response.bodyBytes));
      print('$responseData');
      return responseData;
    } else {
      // 에러가 있는 경우 처리
      throw Exception('구매 요청이 실패했습니다. 마일리지가 부족합니다');
    }
  } catch (e) {
    print('네트워크 오류: $e');
    throw Exception('네트워크 오류가 발생했습니다');
  }
}

//소유하고 있는 방들의 각각 컴포넌트를 생성
class items extends StatefulWidget {
  final int cost;
  final String img;
  final String name;
  final String info;
  final int c_id;

  const items(this.cost, this.img, this.name, this.info, this.c_id);

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  @override
  Widget build(BuildContext context) {
    //late Future<List<Buy>>? futureStore;

    return InkWell(
      onTap: () {
        //누르면 팝업 생성하는 함수
        itemsdialog(context, widget.cost, widget.img, widget.name, widget.info,
            widget.c_id);
      },
      child:
          //사진을 둥글게 만들 수 있는 함수
          Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: 70,
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      widget.img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  //color: Colors.blue,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.attach_money_rounded,
                        color: Colors.amber,
                      ),
                      Text(
                        "${widget.cost}",
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
void itemsdialog(context, int cost, String img, String name, info, int c_id) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: Container(
        margin: const EdgeInsets.all(8),
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
              style: const TextStyle(fontFamily: "bm", fontSize: 25),
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
                const Icon(
                  Icons.attach_money_rounded,
                  color: Colors.amber,
                ),
                Text(
                  '$cost',
                  style: const TextStyle(fontFamily: "bma", fontSize: 25),
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
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(150, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    side: BorderSide(
                      color: PRIMARY_COLOR,
                      width: 3,
                    ),
                  ),
                  child: Text(
                    "닫기",
                    style: TextStyle(
                        color: Colors.black, fontSize: 25, fontFamily: 'bm'),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();

                    fetchBuy(c_id).then((data) {
                      print("오케이");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => buyPage(img, name)));
                    }).catchError((error) {
                      print("에러$error");
                    });
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
