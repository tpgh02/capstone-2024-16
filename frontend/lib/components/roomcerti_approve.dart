//import 'package:dodo/components/certification.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class RoomCertiApprove extends StatefulWidget {
  const RoomCertiApprove({
    super.key,
  });

  @override
  State<RoomCertiApprove> createState() => _RoomCertiApproveState();
}

class _RoomCertiApproveState extends State<RoomCertiApprove> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: LIGHTGREY,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Certification("test"),
            const SizedBox(height: 30),
            // 승인 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '승인',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 239, 104, 104),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.fromLTRB(10, 15, 20, 15),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.block,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '거절',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
