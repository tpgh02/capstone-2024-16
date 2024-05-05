import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class Room_cr extends StatefulWidget {
  const Room_cr({super.key});

  @override
  State<Room_cr> createState() => _Room_crState();
}

class _Room_crState extends State<Room_cr> {
  List _roomname = ['운동', '기상', '공부'];
  Object? _select = '운동';
  TextEditingController _title = TextEditingController();
  TextEditingController _tag = TextEditingController();
  TextEditingController _comments = TextEditingController();
  TextEditingController _peoples = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: LIGHTGREY,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            width: 390,
            height: 80,
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
              '일반 인증방 생성',
              style: TextStyle(
                color: PRIMARY_COLOR,
                fontFamily: "bm",
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              //인증방 제목
              SizedBox(
                height: 48,
                child: TextField(
                  controller: _title,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20, fontFamily: 'bma'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: PRIMARY_COLOR),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: '인증방 제목',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        color: POINT_COLOR, fontSize: 18, fontFamily: 'bm'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //카테고리 선택
              Container(width: double.infinity, child: _roomBtn()),
              const SizedBox(
                height: 20,
              ),
              //해시태그 ( 선택 )
              SizedBox(
                height: 48,
                child: TextField(
                  controller: _tag,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20, fontFamily: 'bma'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: PRIMARY_COLOR),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: '해시태그 ( 선택 )',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        color: POINT_COLOR, fontSize: 18, fontFamily: 'bm'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //인증방 소개 (200자 미만)
              SizedBox(
                height: 48,
                child: TextField(
                  controller: _comments,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20, fontFamily: 'bma'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: PRIMARY_COLOR),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: '인증방 소개 (200자 미만)',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        color: POINT_COLOR, fontSize: 18, fontFamily: 'bm'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //최대 인원 수
              SizedBox(
                height: 48,
                child: TextField(
                  controller: _peoples,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "bma",
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: const BorderSide(color: PRIMARY_COLOR),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: '최대 인원 수 (숫자만 입력)',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        color: POINT_COLOR, fontSize: 18, fontFamily: 'bm'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //비밀번호 (입력시 비밀방으로 생성)
              SizedBox(
                height: 48,
                child: TextField(
                  obscureText: true,
                  controller: _password,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 20, fontFamily: 'bma'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: PRIMARY_COLOR),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    labelText: '비밀번호 (입력시 비밀방으로 생성)',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                        color: POINT_COLOR, fontSize: 18, fontFamily: 'bm'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //이전, 다음 버튼
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text("이전",
                        style: TextStyle(color: PRIMARY_COLOR)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: PRIMARY_COLOR,
                        elevation: 2,
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black,
                        side: BorderSide(color: PRIMARY_COLOR),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: const Text(
                      "다음",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Widget _roomBtn() {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: PRIMARY_COLOR, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton(
          value: _select,
          underline: const SizedBox.shrink(),
          focusColor: LIGHTGREY,
          iconEnabledColor: PRIMARY_COLOR,
          icon: const Icon(Icons.arrow_drop_down),
          items: _roomname.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value,
                    style: TextStyle(fontFamily: 'bm', fontSize: 20),
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
