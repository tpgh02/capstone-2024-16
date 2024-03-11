import 'package:flutter/material.dart';

class m_title extends StatelessWidget {
  final String name;

  const m_title(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
        //color: Colors.yellow,
        child: Padding(
            //mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  //color: Colors.amber,
                  child: Text(
                    '안녕하세요,',
                    style: TextStyle(fontFamily: "kcc", fontSize: 20),
                  ),
                ),
                Container(
                  //color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('$name',
                          style: TextStyle(
                              fontFamily: "kcc",
                              fontSize: 40,
                              color: Color(0xff1cb5e0))),
                      Text(
                        '님',
                        style: TextStyle(fontFamily: "kcc", fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
