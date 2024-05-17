import 'package:dodo/components/roomuser_profile.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class RoomUserSuccess extends StatelessWidget {
  final int roomUserId;
  final String user_name;
  final String user_img;
  final int upload_imgs;
  final int required_imgs;
  final bool is_manager;
  final String certificationType;

  const RoomUserSuccess(
      this.roomUserId,
      this.user_name,
      this.user_img,
      this.upload_imgs,
      this.required_imgs,
      this.is_manager,
      this.certificationType);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: PRIMARY_COLOR,
      ),
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // 유저 프로필 사진
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => RoomUserProfile(
                  roomUserId: roomUserId,
                  is_manager: is_manager,
                ),
              );
            },
            child: SizedBox(
              width: 70,
              height: 70,
              child: ClipOval(
                child: Image.network(
                  user_img,
                  fit: BoxFit.cover,
                ),
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
                        color: Color(0xffefefef),
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  Row(
                    children: [
                      Text(
                        '$upload_imgs / $required_imgs',
                        style: const TextStyle(
                          color: Color(0xffefefef),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Color(0xffefefef),
            size: 50,
          ),
        ],
      ),
    );
  }
}
