import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class m2Tabbar extends StatefulWidget {
  const m2Tabbar({Key? key}) : super(key: key);

  @override
  State<m2Tabbar> createState() => _m2TabbarState();
}

class _m2TabbarState extends State<m2Tabbar>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 0,

    /// 탭 변경 애니메이션 시간
    animationDuration: const Duration(milliseconds: 200),
  );

  List dayoff = ['1month', '3month', '6month'];
  String month = '1month';
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  int state = 40;

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: _tabBar(),
        ),
        TableCalendar(
          onDaySelected: onDaySelected,
          selectedDayPredicate: (day) {
            return isSameDay(selectedDate, day);
          },
          focusedDay: selectedDate,
          firstDay: DateTime(2024),
          lastDay: DateTime(2025),
          headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(fontFamily: 'bm', fontSize: 20)),
        ),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Text(
            "이번 달성률 : ",
            style: TextStyle(fontFamily: "bm", fontSize: 20),
          ),
          Text(
            "$state%",
            style: const TextStyle(fontFamily: "bm", fontSize: 30),
          )
        ])
      ],
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
                style: const TextStyle(fontFamily: 'bm', fontSize: 20),
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
