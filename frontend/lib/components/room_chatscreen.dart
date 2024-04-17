import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class RoomChatScreen extends StatelessWidget {
  final String room_title;
  final bool is_manager;
  const RoomChatScreen(
      {super.key, required this.room_title, required this.is_manager});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _roomMainAppBar(room_title, manager: is_manager),
      backgroundColor: LIGHTGREY,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(room_title),
              ),
            ),
          ),
          _TextInputForm(),
        ],
      ),
    );
  }

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
}

// 하단 입력창
class _TextInputForm extends StatelessWidget {
  const _TextInputForm({super.key});

  @override
  Widget build(BuildContext context) {
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
            const TextField(
              // focusNode:
              // onChanged:
              // controller:
              maxLength: null,
              maxLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
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
                onPressed: () {},
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

class Chatting extends StatefulWidget {
  final String chat_ID;
  final String user_ID;
  const Chatting({super.key, required this.chat_ID, required this.user_ID});

  @override
  ChattingState createState() => ChattingState();
}

class ChattingState extends State<Chatting> {
  List<dynamic> message = List.empty();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView();
  }
}
