import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class main2Page extends StatelessWidget {
  //const main2Page({super.key});

  @override
  Widget build(BuildContext context) {
    final List _roomname = ['오.운.완', '지금 일어나지 않으면...', '자취요리왕'];
    String _select = '오.운.완';
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: DropdownButton(
          value: _select,
          items: _roomname.map(
            (value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            },
          ).toList(),
          onChanged: (value) {
            //뭐가 문젠데 다 해줬잖아 setState()가 안뜸.
            // setState(() {
            //   dropDownValue = value!;
            // });
          },
        ),
      ),
    );
  }
}
