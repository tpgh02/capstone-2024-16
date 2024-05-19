import 'dart:convert';
import 'dart:developer';
import 'package:dodo/const/server.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dodo/components/roomuser_success.dart';
import 'package:dodo/components/roomuser_default.dart';
import 'package:dodo/components/roomuser_tocheck.dart';

Future<List<Users>> fetchRoomUsers(int roomId) async {
  final response = await http
      .get(Uri.parse('$serverUrl/api/v1/certification/list/$roomId'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<Users> UsersList =
        jsonData.map((json) => Users.fromJson(json)).toList();
    log("Users List: Connected!");
    return UsersList;
  } else {
    throw Exception('Failed to load room list in main');
  }
}

class Users {
  final int userId;
  final int roomUserId;
  final List<dynamic> certificationIdList;
  final String userName;
  final userImage;
  final int max;
  final int? success;
  final int? wait;
  final bool certification;

  const Users(
      {required this.userId,
      required this.roomUserId,
      required this.certificationIdList,
      required this.userName,
      required this.userImage,
      required this.max,
      required this.success,
      required this.wait,
      required this.certification});

  factory Users.fromJson(dynamic json) {
    return Users(
        userId: json['userId'],
        roomUserId: json['roomUserId'],
        certificationIdList: json['certificationIdList'],
        userName: json['userName'],
        userImage: json['userImage'],
        max: json['max'],
        success: json['success'],
        wait: json['wait'],
        certification: json['certification']);
  }
}

class RoomUserList extends StatefulWidget {
  final int room_id;
  final bool is_manager;
  final String certificationType;
  const RoomUserList({
    super.key,
    required this.room_id,
    required this.is_manager,
    required this.certificationType,
  });

  @override
  State<RoomUserList> createState() => _roomUserState();
}

class _roomUserState extends State<RoomUserList> {
  late Future<List<Users>>? futureUsersList;
  late Future<int> futureIsme;

  @override
  void initState() {
    super.initState();
    futureUsersList = fetchRoomUsers(widget.room_id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<List<Users>>(
            future: futureUsersList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                log("유저 리스트 연결 실패: ${snapshot.error}");
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '서버 연결에 실패하였습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black45,
                          fontFamily: 'bm',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData) {
                // 유저가 없을 경우 처리
                if (snapshot.data?.length == 0) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '아직 가입한 사용자가 없습니다.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black45,
                            fontFamily: 'bm',
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // log("members: ${snapshot.data!.length}");
                  return Container(
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
                              final success = snapshot.data![idx].success;
                              final wait = snapshot.data![idx].wait;
                              if ((success! + wait!) <
                                  snapshot.data![idx].max) {
                                return userContainer_default(
                                    snapshot.data![idx].userId,
                                    snapshot.data![idx].roomUserId,
                                    snapshot.data![idx].userName,
                                    snapshot.data![idx].userImage['url'],
                                    (success + wait),
                                    snapshot.data![idx].max);
                              } else {
                                if (success == snapshot.data![idx].max ||
                                    snapshot.data![idx].certification == true) {
                                  return userContainer_success(
                                      snapshot.data![idx].userId,
                                      snapshot.data![idx].roomUserId,
                                      snapshot.data![idx].userName,
                                      snapshot.data![idx].userImage['url'],
                                      (success + wait),
                                      snapshot.data![idx].max);
                                } else {
                                  return userContainer_tocheck(
                                      snapshot.data![idx].certificationIdList,
                                      snapshot.data![idx].userId,
                                      snapshot.data![idx].roomUserId,
                                      snapshot.data![idx].userName,
                                      snapshot.data![idx].userImage['url'],
                                      (success + wait),
                                      snapshot.data![idx].max);
                                }
                              }
                            },
                            childCount: snapshot.data!.length,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                return const Text('No data available');
              }
            },
          ),
        ],
      ),
    );
  }

  Container userContainer_default(
      userId, roomUserId, name, img_root, upload, required) {
    return Container(
      alignment: Alignment.center,
      child: RoomUserDefault(widget.room_id, userId, roomUserId, name, img_root,
          upload, required, widget.is_manager, widget.certificationType),
    );
  }

  Container userContainer_tocheck(
      certificationlist, userId, roomUserId, name, img_root, upload, required) {
    return Container(
      alignment: Alignment.center,
      child: RoomUserToCheck(
          certificationlist,
          userId,
          roomUserId,
          widget.room_id,
          name,
          img_root,
          upload,
          required,
          widget.is_manager,
          widget.certificationType),
    );
  }

  Container userContainer_success(
      userId, roomUserId, name, img_root, upload, required) {
    return Container(
      alignment: Alignment.center,
      child: RoomUserSuccess(widget.room_id, userId, roomUserId, name, img_root,
          upload, required, widget.is_manager, widget.certificationType),
    );
  }
}
