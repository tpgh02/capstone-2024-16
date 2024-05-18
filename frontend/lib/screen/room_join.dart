import 'package:dodo/components/s2_tag.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class room_join extends StatefulWidget {
  final int roomId;
  final String room_title;
  final image;
  final int maxUser;
  final int nowUser;
  final String endDay;
  final String periodicity;
  final String? room_pwd;
  final String? info;
  final bool canChat;
  final String room_type;
  final String certificationType;
  final int frequency;
  final List<dynamic>? tag;
  const room_join(
      {super.key,
      required this.roomId,
      required this.room_title,
      required this.image,
      required this.maxUser,
      required this.nowUser,
      required this.endDay,
      required this.periodicity,
      required this.room_pwd,
      required this.info,
      required this.canChat,
      required this.room_type,
      required this.certificationType,
      required this.frequency,
      required this.tag});

  @override
  State<room_join> createState() => _room_joinState();
}

class _room_joinState extends State<room_join> {
  // Map room = {
  //   "room_title": "자취요리왕",
  //   "room_cap": "거북이도도",
  //   "room_mem": "10",
  //   "room_maxmem": "20",
  //   "room_txt": "자취가 아닌 세계를 울릴 비룡이 되는 그날까지...",
  // };
  @override
  Widget build(BuildContext context) {
    String certiInfo = "${widget.periodicity} ${widget.frequency}회";
    if (widget.certificationType == 'VOTE') {
      certiInfo += ", 투표";
    } else {
      certiInfo += ", 방장 승인";
    }

    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //appbar
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: DARKGREY)),
                color: Colors.white,
              ),
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: POINT_COLOR,
                            size: 40,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                            "${widget.room_title}",
                            style: const TextStyle(
                                fontFamily: 'kcc',
                                fontSize: 25,
                                color: POINT_COLOR),
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    // Container(
                    //   alignment: Alignment.bottomRight,
                    //   child: const Text(
                    //     "12명이 함께하는 중",
                    //     style: TextStyle(
                    //         fontFamily: 'kcc',
                    //         fontSize: 15,
                    //         color: POINT_COLOR),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),

            //body
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(widget.image['url'])),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Text(
                          //   "${room['room_cap']}",
                          //   style: const TextStyle(
                          //       color: POINT_COLOR,
                          //       fontFamily: 'bm',
                          //       fontSize: 20),
                          // ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: PRIMARY_COLOR,
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${widget.nowUser} / ${widget.maxUser}명",
                              style: const TextStyle(
                                  fontFamily: "bm",
                                  fontSize: 15,
                                  color: PRIMARY_COLOR),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //방소개
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "방 소개",
                      style: TextStyle(fontSize: 18, fontFamily: 'bma'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: widget.info == null || widget.info == ""
                        ? const Text(
                            "소개가 없습니다.",
                            style: TextStyle(fontFamily: 'bm', fontSize: 18),
                          )
                        : Text(
                            "${widget.info}",
                            style:
                                const TextStyle(fontFamily: 'bm', fontSize: 18),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //목표기한
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "목표 기한",
                      style: TextStyle(fontSize: 18, fontFamily: 'bma'),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    //height: 50,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "${widget.endDay.split("T")[0]}까지",
                      style: const TextStyle(fontSize: 18, fontFamily: 'bm'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //인증 방식
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "인증 방식",
                      style: TextStyle(fontSize: 18, fontFamily: 'bma'),
                    ),
                  ),

                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    //height: 50,
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      certiInfo,
                      style: const TextStyle(fontSize: 18, fontFamily: 'bm'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  //인증여부
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "AI 인증 여부",
                          style: TextStyle(fontSize: 20, fontFamily: 'bma'),
                        ),
                      ),
                      Opacity(
                        opacity: 0.6, //비활성화라 살짝 투명하게 보이도록 함
                        child: CupertinoSwitch(
                          value: widget.room_type == 'AI' ? true : false,
                          activeColor: PRIMARY_COLOR,
                          onChanged: (bool? value) {},
                        ),
                      ),
                    ],
                  ),

                  //채팅 여부
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "채팅 여부",
                          style: TextStyle(fontSize: 20, fontFamily: 'bma'),
                        ),
                      ),
                      Opacity(
                        opacity: 0.6,
                        child: CupertinoSwitch(
                          value: widget.canChat,
                          activeColor: PRIMARY_COLOR,
                          onChanged: (bool? value) {},
                        ),
                      ),
                    ],
                  ),

                  // 비밀방 여부
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "비밀방 여부",
                          style: TextStyle(fontSize: 20, fontFamily: 'bma'),
                        ),
                      ),
                      Opacity(
                        opacity: 0.6,
                        child: CupertinoSwitch(
                          value:
                              widget.room_pwd == null || widget.room_pwd == ""
                                  ? false
                                  : true,
                          activeColor: PRIMARY_COLOR,
                          onChanged: (bool? value) {},
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  //인증 방식
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "이 방의 해시태그",
                      style: TextStyle(fontSize: 20, fontFamily: 'bma'),
                    ),
                  ),
                  widget.tag == null ||
                          widget.tag!.length == 0 ||
                          widget.tag!.isEmpty
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                              Text(
                                "태그가 없습니다.",
                                style:
                                    TextStyle(fontFamily: 'bm', fontSize: 18),
                              )
                            ])
                      : s2_tag(
                          tag: widget.tag,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: //바닥 버튼
          widget.nowUser == widget.maxUser
              ? Container(
                  width: double.infinity,
                  height: 70,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0), // 왼쪽 위 모서리
                      topRight: Radius.circular(20.0), // 오른쪽 위 모서리
                    ),
                    color: Color.fromARGB(131, 173, 173, 173), // 버튼 배경색
                  ),
                  child: const Center(
                    child: Text(
                      '인원이 모두 찼습니다.',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'kcc',
                          fontSize: 20), // 버튼 텍스트 색상
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: 70,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0), // 왼쪽 위 모서리
                      topRight: Radius.circular(20.0), // 오른쪽 위 모서리
                    ),
                    color: PRIMARY_COLOR, // 버튼 배경색
                  ),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      '가입하기',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'kcc',
                          fontSize: 20), // 버튼 텍스트 색상
                    ),
                  ),
                ),
    );
  }
}
