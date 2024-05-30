import 'package:dodo/components/c_dialog.dart';
import 'package:flutter/material.dart';

//소유하고 있는 방들의 각각 컴포넌트를 생성
class todo extends StatefulWidget {
  final String room_name;
  final String room_img;
  final int room_id;
  final String room_status;

  const todo(this.room_name, this.room_img, this.room_id, this.room_status);

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {
  @override
  Widget build(BuildContext context) {
    print("${widget.room_status}");
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
              widget.room_status == "SUCCESS"
                  ? {}
                  : showDialog(
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
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  widget.room_status == "SUCCESS"
                      ? Colors.black.withOpacity(0.6)
                      : Colors.black.withOpacity(0.25), // 어두운 필터 색상과 투명도 설정
                  BlendMode.darken, // BlendMode 설정
                ),
                child: Image.network(
                  widget.room_img,
                  fit: BoxFit.cover,
                ),
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
            style: TextStyle(
                fontFamily: "bm",
                fontSize: 22,
                color: widget.room_status == "SUCCESS"
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white),
          ),
        ),
        widget.room_status == "SUCCESS"
            ? Container(
                alignment: Alignment.center,
                //margin: const EdgeInsets.all(value)
                child: const Text(
                  "완료",
                  style: TextStyle(
                      fontFamily: "bm", fontSize: 25, color: Colors.white),
                ),
              )
            : Container(),
      ],
    );
  }
}
