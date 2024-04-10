import 'package:flutter/material.dart';
import 'package:dodo/components/roomuser_default.dart';

class RoomUserList extends StatefulWidget {
  const RoomUserList({super.key});

  @override
  State<RoomUserList> createState() => _roomUserState();
}

class _roomUserState extends State<RoomUserList> {
  final userList = [
    {
      "user_name": "User1",
      "user_img": "assets/images/cook.jpg",
      "upload_imgs": 1,
      "required_imgs": 3
    },
    {
      "user_name": "User2",
      "user_img": "assets/images/cook.jpg",
      "upload_imgs": 2,
      "required_imgs": 3
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                height: 600,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int idx) {
                          return userContainer(
                              userList[idx]['user_name']!,
                              userList[idx]['user_img']!,
                              userList[idx]['upload_imgs']!,
                              userList[idx]['required_imgs']!);
                        },
                        childCount: userList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container userContainer(name, img_root, upload, required) {
    return Container(
      alignment: Alignment.center,
      child: RoomUserDefault(name, img_root, upload, required),
    );
  }
}
