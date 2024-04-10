import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class RoomUserDefault extends StatelessWidget {
  final String user_name;
  final String user_img;
  final int upload_imgs;
  final int required_imgs;

  const RoomUserDefault(
      this.user_name, this.user_img, this.upload_imgs, this.required_imgs);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(199, 193, 208, 214),
      ),
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // 유저 프로필 사진
          SizedBox(
            width: 70,
            height: 70,
            child: ClipOval(
              child: Image.asset(
                user_img,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 15),
          // 유저 이름 및 속성
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    user_name,
                    style: const TextStyle(
                        color: POINT_COLOR,
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        '$upload_imgs / $required_imgs',
                        style: const TextStyle(
                          color: POINT_COLOR,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
