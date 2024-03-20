import 'package:dodo/components/m2_board.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class main2Page extends StatefulWidget {
  const main2Page({super.key});

  @override
  State<main2Page> createState() => _main2PageState();
}

class _main2PageState extends State<main2Page> {
  List _roomname = ['오.운.완', '지금 일어나지 않으면...', '자취요리왕'];
  Object? _select = '오.운.완';
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                margin: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    _roomBtn(),
                    const SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "에서 나는?",
                      style: TextStyle(
                          fontSize: 30, fontFamily: 'kcc', color: POINT_COLOR),
                    ),
                  ],
                ),
              ),
              m2_board(),
              TableCalendar(
                onDaySelected: onDaySelected,
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDate, day);
                },
                focusedDay: selectedDate,
                firstDay: DateTime(2024),
                lastDay: DateTime(2025),
                headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(fontFamily: 'bm', fontSize: 20)),
              ),
            ],
          )),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  Widget _roomBtn() {
    return DropdownButton(
      value: _select,
      items: _roomname.map(
        (value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              value,
              style: TextStyle(fontFamily: 'bm', fontSize: 20),
            ),
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(() {
          _select = value;
        });
      },
    );
  }
}
