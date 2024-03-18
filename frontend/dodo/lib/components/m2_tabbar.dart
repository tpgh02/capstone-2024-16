import 'package:flutter/material.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({Key? key}) : super(key: key);

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 200),
  );
  List dayoff = ['1month', '3month', '6month'];

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _tabBar(),
    );
  }

  Widget _tabBar() {
    return TabBar(
      overlayColor: MaterialStatePropertyAll(Colors.blue.shade100),
      splashBorderRadius: BorderRadius.circular(20),
      controller: tabController,
      tabs: dayoff.map(
        (value) {
          return DropdownMenuItem(
            value: value,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                value,
                style: TextStyle(fontFamily: 'bm', fontSize: 20),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
