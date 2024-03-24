import 'package:dodo/components/room_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class roomListPage extends StatefulWidget {
  const roomListPage({super.key});

  @override
  State<roomListPage> createState() => _roomListState();
}

class _roomListState extends State<roomListPage>
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
            room_list(
              room_name: "자취요리왕",
              room_img: "assets/images/cook.jpg",
            ),
            room_list(
                room_name: "오운완",
                room_img: "assets/images/turtle_noradius.png"),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _roomListAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(80),
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

  FloatingActionButton appendRoom() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: PRIMARY_COLOR,
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}
