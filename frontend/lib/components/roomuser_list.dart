import 'package:flutter/material.dart';
import 'package:dodo/components/roomuser_success.dart';
import 'package:dodo/components/roomuser_default.dart';
import 'package:dodo/components/roomuser_tocheck.dart';

class RoomUserList extends StatefulWidget {
  final bool is_manager;
  const RoomUserList({super.key, required this.is_manager});

  @override
  State<RoomUserList> createState() => _roomUserState();
}

class _roomUserState extends State<RoomUserList> {
  final userList = [
    {
      "user_name": "User1",
      "user_img": "assets/images/cook.jpg",
      "success": 0,
      "wait": 1,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User2",
      "user_img": "assets/images/cook.jpg",
      "success": 0,
      "wait": 2,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User3",
      "user_img": "assets/images/cook.jpg",
      "success": 1,
      "wait": 1,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User4",
      "user_img": "assets/images/cook.jpg",
      "success": 3,
      "wait": 0,
      "max": 3,
      "certification": true,
    },
    {
      "user_name": "User5",
      "user_img": "assets/images/cook.jpg",
      "success": 0,
      "wait": 3,
      "max": 3,
      "certification": false,
    },
    {
      "user_name": "User6",
      "user_img": "assets/images/cook.jpg",
      "success": 3,
      "wait": 0,
      "max": 3,
      "certification": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromARGB(199, 193, 208, 214),
            ),
            height: MediaQuery.of(context).size.height - 390,
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
            child: CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int idx) {
                      final success = userList[idx]['success']! as int;
                      final wait = userList[idx]['wait']! as int;
                      if ((success + wait) != userList[idx]['max']) {
                        return userContainer_default(
                            userList[idx]['user_name']!,
                            userList[idx]['user_img']!,
                            (success + wait),
                            userList[idx]['max']!);
                      } else {
                        if (success == userList[idx]['max']) {
                          return userContainer_success(
                              userList[idx]['user_name']!,
                              userList[idx]['user_img']!,
                              (success + wait),
                              userList[idx]['max']!);
                        } else {
                          return userContainer_tocheck(
                              userList[idx]['user_name']!,
                              userList[idx]['user_img']!,
                              (success + wait),
                              userList[idx]['max']!);
                        }
                      }
                    },
                    childCount: userList.length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container userContainer_default(name, img_root, upload, required) {
    return Container(
      alignment: Alignment.center,
      child:
          RoomUserDefault(name, img_root, upload, required, widget.is_manager),
    );
  }

  Container userContainer_tocheck(name, img_root, upload, required) {
    return Container(
      alignment: Alignment.center,
      child:
          RoomUserToCheck(name, img_root, upload, required, widget.is_manager),
    );
  }

  Container userContainer_success(name, img_root, upload, required) {
    return Container(
      alignment: Alignment.center,
      child:
          RoomUserSuccess(name, img_root, upload, required, widget.is_manager),
    );
  }
}
