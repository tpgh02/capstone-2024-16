import 'package:dodo/components/c_dialog.dart';
import 'package:flutter/material.dart';

//소유하고 있는 방들의 각각 컴포넌트를 생성
class todo extends StatefulWidget {
  final String room_name;
  final String room_img;
  final int room_id;

  const todo(this.room_name, this.room_img, this.room_id);

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () {
              //누르면 팝업 생성하는 함수
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return c_dialog(widget.room_id);
                },
              );
            },
            child:
                //사진을 둥글게 만들 수 있는 함수
                ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.room_img,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        //방 이름을 사진 위에 얹는 부분
        Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.fromLTRB(15, 15, 15, 30),
          child: Text(
            widget.room_name,
            style: const TextStyle(
                fontFamily: "bm", fontSize: 22, color: Colors.white),
          ),
        )
      ],
    );
  }
}
