import 'package:dodo/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class RoomChatScreen extends StatefulWidget {
  final String room_title;
  final bool is_manager;
  final int roomID;
  final int userID;
  const RoomChatScreen(
      {super.key,
      required this.room_title,
      required this.is_manager,
      required this.roomID,
      required this.userID});

  @override
  State<RoomChatScreen> createState() => _RoomChatScreenState();
}

class _RoomChatScreenState extends State<RoomChatScreen> {
  late StompClient stompClient;
  final TextEditingController textEditingController = TextEditingController();
  List<dynamic> messages = List.empty();
  final String webSocketUrl = 'http://43.200.176.111:8080/';

  @override
  void initState() {
    super.initState();
    stompClient = StompClient(
        config: StompConfig.sockJS(
            url: webSocketUrl,
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
    // setState(() {});
    stompClient.subscribe(
      destination: '/topic/chatting/${widget.roomID}',
      headers: {},
      callback: (frame) {
        print(frame.body);
        messages = jsonDecode(frame.body!).reversed.toList();
      },
    );
  }

  void sendMessage() {
    final sendMsg = textEditingController.text;
    if (sendMsg.isNotEmpty) {
      stompClient.send(
        destination: '/app/chatting/${widget.roomID}',
        // 수정 필요
        body: json.encode({'data': sendMsg, 'userId': widget.userID}),
      );
      textEditingController.clear();
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
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> item = messages[index];
                    return ListTile(
                      title: Text(item['data']),
                    );
                    // Map<String, dynamic> item = messages[index];
                    // return GestureDetector(
                    //   child: Card(
                    //     child: Text(
                    //       item[index].content,
                    //       textAlign: item[index].uuid =
                    //           myUuid ? TextAlign.right : TextAlign.left,
                    //     ),
                    //   ),
                    // );
                  },
                ),
              ),
              //
            ),
            // Expanded(
            //   child: GestureDetector(
            //     onTap: () {},
            //     child: Align(
            //       alignment: Alignment.topCenter,
            //       child: Text(room_title),
            //     ),
            //   ),
            // ),
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
              maxLines: null,
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
}
