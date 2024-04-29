import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class RoomUserProfile extends StatefulWidget {
  final String user_name;
  final String user_img;
  final bool is_manager;

  const RoomUserProfile({
    super.key,
    required this.user_name,
    required this.user_img,
    required this.is_manager,
  });

  @override
  State<RoomUserProfile> createState() => _RoomUserProfileState();
}

class _RoomUserProfileState extends State<RoomUserProfile> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: LIGHTGREY,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 프로필 사진 및 닉네임
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 프로필 사진
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 18, 20),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          widget.user_img,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                // 닉네임
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                      widget.user_name,
                      style: const TextStyle(
                        color: POINT_COLOR,
                        fontFamily: 'bm',
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            widget.is_manager
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 권한 위임
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 35,
                        width: 90,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: POINT_COLOR,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            '권한 위임',
                            style: TextStyle(
                              color: Color.fromARGB(226, 255, 255, 255),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      // 강퇴
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 34,
                        width: 90,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 255, 98, 87),
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            '강 퇴',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      // 창 닫기
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 34,
                        width: 90,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: POINT_COLOR,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: const BorderSide(
                              color: POINT_COLOR,
                              width: 1.0,
                            ),
                          ),
                          child: const Text(
                            '닫기',
                            style: TextStyle(
                              color: POINT_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // 창 닫기
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 34,
                        width: 90,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: POINT_COLOR,
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: const BorderSide(
                              color: POINT_COLOR,
                              width: 1.0,
                            ),
                          ),
                          child: const Text(
                            '닫기',
                            style: TextStyle(
                              color: POINT_COLOR,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
            // 권한 위임
          ],
        ),
        // widget.is_manager ? Text('manager') : Text('not manager'),
      ),
    );
  }
}
