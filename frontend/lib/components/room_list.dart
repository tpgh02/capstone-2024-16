import 'package:dodo/components/room_group.dart';
import 'package:dodo/components/room_main.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class room_list extends StatefulWidget {
  final String room_title;
  final int room_id;
  final String? room_pwd;
  final String room_type;
  final String room_img;
  final int room_mem;
  final int room_maxmem;
  final bool canChat;
  final bool is_manager;
  final String certificationType;
  const room_list({
    super.key,
    required this.room_title,
    required this.room_id,
    this.room_pwd,
    required this.room_type,
    required this.room_img,
    required this.room_mem,
    required this.room_maxmem,
    required this.canChat,
    required this.is_manager,
    required this.certificationType,
  });

  @override
  State<room_list> createState() => _roomListState();
}

class _roomListState extends State<room_list> {
  @override
  Widget build(BuildContext context) {
    print(widget.room_pwd);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
          child: SizedBox(
            height: 90,
            child: Row(
              children: [
                // 인증방 썸네일 이미지
                GestureDetector(
                  onTap: () {
                    widget.is_manager
                        ? showModalBottomSheet(
                            context: context,
                            builder: ((builder) => editRoomImg()))
                        : null;
                  },
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: ClipOval(
                      child: Image.network(
                        widget.room_img,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // 방 제목 및 속성
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            if (widget.room_type != "GROUP") {
                              return room_main(
                                room_title: widget.room_title,
                                room_id: widget.room_id,
                                room_pwd: widget.room_pwd,
                                room_type: widget.room_type,
                                room_mem: widget.room_mem,
                                room_maxmem: widget.room_maxmem,
                                canChat: widget.canChat,
                                is_manager: widget.is_manager,
                                certificationType: widget.certificationType,
                              );
                            } else {
                              return room_group(
                                room_title: widget.room_title,
                                room_id: widget.room_id,
                                room_pwd: widget.room_pwd,
                                room_type: widget.room_type,
                                room_mem: widget.room_mem,
                                room_maxmem: widget.room_maxmem,
                                canChat: widget.canChat,
                                is_manager: widget.is_manager,
                                certificationType: widget.certificationType,
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // 방 이름
                        Text(
                          widget.room_title,
                          style: const TextStyle(
                            fontFamily: "bm",
                            fontSize: 21,
                          ),
                        ),
                        // 방 속성
                        Row(
                          children: [
                            // 인원 수
                            const Icon(Icons.person),
                            Text(' ${widget.room_mem}/${widget.room_maxmem}'),

                            // 인증방 타입
                            widget.room_type == "GROUP"
                                ? const Padding(
                                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: Icon(
                                      Icons.group,
                                      size: 24,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0.1,
                                  ),

                            widget.room_type == "AI"
                                ? const Padding(
                                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: Icon(
                                      Icons.podcasts,
                                      size: 24,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0.1,
                                  ),

                            // 비밀방 여부
                            widget.room_pwd != null
                                ? const Padding(
                                    padding: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    child: Icon(
                                      Icons.lock,
                                      size: 18,
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0.1,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 도장
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black26, width: 1.5),
                  ),
                  width: 90,
                  height: 90,
                ),
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black38),
      ],
    );
  }

  // 그룹 이미지 수정 팝업
  Widget editRoomImg() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              '프로필 사진을 선택해주세요.',
              style: TextStyle(
                color: POINT_COLOR,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.photo,
                        color: POINT_COLOR,
                        size: 40,
                      ),
                      Text(
                        '앨범',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: POINT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Column(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: POINT_COLOR,
                        size: 40,
                      ),
                      Text(
                        '기본 이미지',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: POINT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
