import 'package:flutter/material.dart';

class m_state extends StatelessWidget {
  final String state;

  const m_state(this.state);

  @override
  Widget build(BuildContext context) {
    final TextStyle style =
        TextStyle(color: Colors.white, fontFamily: "kcc", fontSize: 30);
    return Center(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff1cb5e0),
              textStyle: const TextStyle(fontSize: 20),
              minimumSize: Size(500, 100),
            ),
            onPressed: () {
              statedialog(context);
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "$state",
                style: style,
              ),
            )));
  }
}

void statedialog(context) {
  int? state = 70;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("달성률 $state%"),
            SizedBox(
              height: 100,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ));
    },
  );
}
