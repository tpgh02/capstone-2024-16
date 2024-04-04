import 'package:dodo/components/room_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListState();
}

class _RoomListState extends State<RoomListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      appBar: _roomListAppBar(),
      backgroundColor: LIGHTGREY,
      floatingActionButton: appendRoom(),
      body: const SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            room_list(num: 0),
            room_list(num: 1),
            room_list(num: 2),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _roomListAppBar() {
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
        padding: const EdgeInsets.fromLTRB(30, 20, 0, 0),
        child: const Text(
          '내가 가입한 그룹',
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontFamily: "bm",
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  Container appendRoom() {
    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.all(20),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: PRIMARY_COLOR,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
