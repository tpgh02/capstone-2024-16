import 'package:dodo/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class Msg {
  int roomId;
  int userId;
  String message;
  String time;

  Msg({
    required this.roomId,
    required this.userId,
    required this.message,
    required this.time,
  });
}

List<dynamic> messageList = [];

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
  List<dynamic> messages = List.empty();
  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
        config: StompConfig(
            url: wsURL,
            onConnect: onConnectCallback,
            beforeConnect: () async {
              print('waiting to connect...');
              await Future.delayed(const Duration(milliseconds: 200));
              print('connecting...');
            },
            onWebSocketError: (dynamic error) => print(error.toString())));
    stompClient.activate();
  }

  void onConnectCallback(StompFrame frame) {
    stompClient.subscribe(
      destination: '/sub/chat/room/${widget.roomId}',
      headers: {},
      callback: (frame) {
        Map<String, dynamic> obj = json.decode(frame.body!);
        Msg msg = Msg(
          roomId: obj['roomId'],
          userId: obj['userId'],
          message: obj['message'],
          time: obj['time'],
        );
        setState(() {
          messageList.add(msg);
        });
        print(msg);
        print(frame.body);
        messages = jsonDecode(frame.body!).reversed.toList();
      },
    );
  }

  void sendMessage() {
    final sendMsg = textEditingController.text;
    if (sendMsg.isNotEmpty) {
      stompClient.send(
        destination: '/pub',
        body: json.encode({
          'roomId': widget.roomId,
          'userId': widget.userId,
          'message': sendMsg,
          'time': '12:30',
        }),
      );
      textEditingController.clear();
      messageList.add({
        'roomId': widget.roomId,
        'userId': widget.userId,
        'message': sendMsg,
        'time': '12:30',
      });
      print("send message");
      print(messageList);
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
            // 채팅 스크린
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 160,
                padding: const EdgeInsets.fromLTRB(6, 20, 0, 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    // Map<String, dynamic> item = messageList[index];
                    return ListTile(
                      title: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${widget.userId}'),
                              Text(messageList[index]['message']),
                            ],
                          )),
                    );
                  },
                ),
              ),
            ),
            _TextInputForm(),
          ],
        ),
      ),
    );
  }

  // AppBAr
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
              // maxLines: null,
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
                  color: POINT_COLOR,
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
