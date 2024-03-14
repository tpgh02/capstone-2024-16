import 'package:dodo/components/m_todo.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class roomList extends StatefulWidget {
  const roomList({super.key});

  @override
  State<roomList> createState() => _roomListState();
}

class _roomListState extends State<roomList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 2;
  bool _showAppBar = true;

  // 다른 탭으로 이동하면 상단바 노출되지 않게 처리
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _showAppBar = _selectedIndex == 2;
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    // _tabController.addListener(
    //     () => setState(() => _selectedIndex = _tabController.index));
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
      appBar: PreferredSize(
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
      ),
      backgroundColor: LIGHTGREY,
    );
  }
}
