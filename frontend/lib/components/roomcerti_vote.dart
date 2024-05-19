import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class RoomCertiVote extends StatefulWidget {
  final int room_id;
  final String user_name;
  const RoomCertiVote(
      {super.key, required this.room_id, required this.user_name});

  @override
  State<RoomCertiVote> createState() => _RoomCertiVoteState();
}

class _RoomCertiVoteState extends State<RoomCertiVote> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: LIGHTGREY,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SizedBox(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.user_name,
                    style: const TextStyle(fontFamily: 'bm', fontSize: 25),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      children: List.generate(
                        3,
                        (index) {
                          return Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              color: PRIMARY_COLOR,
                              width: 180,
                              height: 180,
                              child: Text("${index + 1}"));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // 찬성
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_rounded),
                  iconSize: 40,
                  color: PRIMARY_COLOR,
                ),
                const SizedBox(width: 2),

                // progress bar
                Stack(
                  children: [
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4 * (3 / 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: PRIMARY_COLOR,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Text("3 / 5",
                    style: TextStyle(
                        color: POINT_COLOR, fontFamily: "bm", fontSize: 18)),
              ],
            ),

            // 반대
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.heart_broken_rounded),
                  iconSize: 40,
                  color: const Color.fromARGB(255, 239, 104, 104),
                ),
                const SizedBox(width: 2),

                // progress bar
                Stack(
                  children: [
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.4 * (3 / 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width *
                          0.4 *
                          (3 / 5) *
                          (1 / 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 239, 104, 104),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Text("1 / 3",
                    style: TextStyle(
                        color: POINT_COLOR, fontFamily: "bm", fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
