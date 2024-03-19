import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class m_title extends StatelessWidget {
  final String name;

  const m_title(this.name);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '안녕하세요,',
                    style: TextStyle(
                        fontFamily: "kcc", fontSize: 20, color: DARKGREY),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('$name',
                          style: const TextStyle(
                              fontFamily: "kcc",
                              fontSize: 40,
                              color: PRIMARY_COLOR)),
                      Text(
                        '님',
                        style: TextStyle(
                            fontFamily: "kcc", fontSize: 30, color: DARKGREY),
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
