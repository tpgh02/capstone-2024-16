import 'package:dodo/screen/category_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class s_list extends StatefulWidget {
  const s_list({super.key});

  @override
  State<s_list> createState() => _s_listState();
}

class _s_listState extends State<s_list> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildCategory("GYM", "헬스"),
            buildCategory("EXERCISE", "운동"),
            buildCategory("WAKEUP", "기상"),
            buildCategory("STUDY", "학습"),
            buildCategory("DIET", "식단"),
            buildCategory("GROUP", "그룹"),
            buildCategory("ETC", "기타"),
          ],
        ),
      ),
    );
  }

  Widget buildCategory(String category, String cateKor) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => categoryPage(
                      category: category,
                      cateKor: cateKor,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset("assets/images/turtle_noradius.png")),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "$cateKor",
                  style: TextStyle(fontFamily: 'kcc', fontSize: 20),
                ),
              ],
            ),
            Visibility(
              visible: MediaQuery.of(context).size.width >
                  420, // 예를 들어, 화면 너비가 320보다 클 때만 아이콘 표시
              child: Container(
                color: Colors.white,
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text("참여중"),
                      ],
                    ),
                    const Text("112,788명 활동중")
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
