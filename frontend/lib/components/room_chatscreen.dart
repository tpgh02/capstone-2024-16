import 'dart:developer';
import 'package:dodo/components/room_notice.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dodo/const/server.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

Future<List<ReceivedMsg>> fetchReceivedMsg(int roomId) async {
  final response = await http
      .get(Uri.parse('$serverUrl/chat/room-messages/$roomId'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<ReceivedMsg> nowMsgs =
        jsonData.map((json) => ReceivedMsg.fromJson(json)).toList();
    log("Chatting: Connected!");
    return nowMsgs;
  } else {
    throw Exception('Failed to load chatting room');
  }
}

// future message class
class ReceivedMsg {
  final int userId;
  final String message;
  final String time;

  const ReceivedMsg(
      {required this.userId, required this.message, required this.time});

  factory ReceivedMsg.fromJson(dynamic json) {
    return ReceivedMsg(
        userId: json['userId'], message: json['message'], time: json['time']);
  }
}

// pub/sub message class
class Msg {
  int userId;
  String message;

  Msg({
    required this.userId,
    required this.message,
  });
}

class RoomChatScreen extends StatefulWidget {
  final String room_title;
  final bool is_manager;
  final int roomId;
  final int userId;
  const RoomChatScreen(
      {super.key,
      required this.room_title,
      required this.is_manager,
      required this.roomId,
      required this.userId});

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  final String wsURL = "ws://43.200.176.111:8080/ws-stomp";
  late StompClient stompClient;
  final TextEditingController textEditingController = TextEditingController();
  late Future<List<ReceivedMsg>>? futureMsgList;

  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
        config: StompConfig(
            url: wsURL,
            onConnect: onConnectCallback,
            beforeConnect: () async {
              log('waiting to connect...');
              await Future.delayed(const Duration(milliseconds: 200));
              log('connecting...');
            },
            onWebSocketError: (dynamic error) => print(error.toString())));
    stompClient.activate();
    futureMsgList = fetchReceivedMsg(widget.roomId);
  }

  void onConnectCallback(StompFrame frame) {
    stompClient.subscribe(
      destination: '/sub/chat/room/${widget.roomId}',
      headers: {},
      callback: (frame) {
        Map<String, dynamic> obj = json.decode(frame.body!);
        Msg msg = Msg(
          userId: obj['userId'],
          message: obj['message'],
        );
        log("sub msg: ${msg.message}, frame: ${frame.body}");
      },
    );
  }

  void sendMessage() {
    final sendMsg = textEditingController.text;
    if (sendMsg.isNotEmpty) {
      // time indication
      DateTime dt = DateTime.now();
      String hour = '${dt.hour}';
      String minute = '${dt.minute}';
      if (hour.length == 1) {
        hour = '0$hour';
      }
      if (minute.length == 1) {
        minute = '0$minute';
      }
      // send
      stompClient.send(
        destination: '/pub/chat/sendMessage/${widget.roomId}',
        body: json.encode({
          'userId': widget.userId,
          'message': sendMsg,
        }),
      );
      textEditingController.clear();
      log("send message");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roomMainAppBar(widget.room_title, manager: widget.is_manager),
      backgroundColor: LIGHTGREY,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 공지
            RoomNotice(
              room_title: widget.room_title,
              room_notice: "${widget.room_title}의 채팅방 공지사항",
              is_manager: widget.is_manager,
            ),

            // 채팅 스크린
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(6, 20, 0, 20),
                child: FutureBuilder<List<ReceivedMsg>>(
                    future: futureMsgList,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: CircularProgressIndicator()),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        log("채팅방 연결 실패: ${snapshot.error}");
                        return const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '서버 연결에 실패하였습니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontFamily: 'bm',
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (snapshot.hasData) {
                        log("${snapshot.data?.length}");
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              String sendDate = snapshot.data![index].time
                                  .split('T')[0]
                                  .substring(2);
                              String sendTime = snapshot.data![index].time
                                  .split('T')[1]
                                  .split('.')[0]
                                  .substring(0, 5);

                              return ListTile(
                                title: Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 10, 15, 10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // user id
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  '${widget.userId} :',
                                                  style: const TextStyle(
                                                    color: POINT_COLOR,
                                                    fontFamily: 'bm',
                                                  ),
                                                ),
                                              ),

                                              // time indication
                                              Text(
                                                "$sendDate $sendTime",
                                                style: const TextStyle(
                                                  color: POINT_COLOR,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(),

                                          // message
                                          Text(
                                            "${snapshot.data![index].message}", //messageList[index]['message'],
                                            style: const TextStyle(
                                              color: POINT_COLOR,
                                              fontSize: 20,
                                            ),
                                          )
                                        ])),
                              );
                            });
                      } else {
                        return const Text('No data available');
                      }
                    }),
              ),
            ),
            _TextInputForm(),
          ],
        ),
      ),
    );
  }

  // AppBar
  PreferredSizeWidget _roomMainAppBar(String title, {bool manager = false}) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Container(
        width: 390,
        height: 80,
        // Border Line
        decoration: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 2,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Color(0x7F414C58),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              backgroundColor: LIGHTGREY,
              leading: const BackButton(
                color: PRIMARY_COLOR,
              ),
              title: Text(
                "$title 채팅방",
                style: const TextStyle(
                  color: PRIMARY_COLOR,
                  fontFamily: "bm",
                  fontSize: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 하단 입력창
  Widget _TextInputForm() {
    return SafeArea(
      bottom: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 50),
        decoration: ShapeDecoration(
          color: Colors.white70,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: POINT_COLOR,
              strokeAlign: BorderSide.strokeAlignInside,
              width: 2,
            ),
          ),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            TextField(
              controller: textEditingController,
              maxLength: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(10),
                hintText: ('메시지를 입력하세요.'),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
            Positioned(
              bottom: 4,
              right: -6,
              child: IconButton(
                onPressed: () {
                  sendMessage();
                },
                icon: const Icon(
                  Icons.send,
                  color: PRIMARY_COLOR,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    stompClient.deactivate();
    textEditingController.dispose();
    super.dispose();
  }
}
