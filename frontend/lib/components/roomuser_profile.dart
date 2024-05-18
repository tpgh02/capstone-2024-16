import 'dart:convert';
import 'dart:developer';
import 'package:dodo/screen/main_screen.dart';
import 'package:http/http.dart' as http;
import 'package:dodo/const/server.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

Future<RoomUserInfo> fetchUserProfile(int roomUserId) async {
  final response = await http.get(
      Uri.parse('$serverUrl/api/v1/report/room-profile/$roomUserId'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
      });
  if (response.statusCode == 200) {
    log('Room User Profile: Connected!');
    return RoomUserInfo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Room Main: fail to connect');
  }
}

// Future<verifyMe> fetchUserId() async {
//   final response =
//       await http.get(Uri.parse('$serverUrl/api/v1/users/me'), headers: {
//     'Authorization':
//         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
//   });
//   if (response.statusCode == 200) {
//     log('VerifyMe: Connected!');
//     return verifyMe.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
//   } else {
//     throw Exception('Mypage: fail to connect');
//   }
// }

class RoomUserInfo {
  final int roomUserId;
  final String userName;
  final image;
  final String? since;
  final int? success;
  final int? allSuccess;
  final int? lately;
  final int? allLately;

  RoomUserInfo(
      {required this.roomUserId,
      required this.userName,
      required this.image,
      required this.since,
      required this.success,
      required this.allSuccess,
      required this.lately,
      required this.allLately});

  factory RoomUserInfo.fromJson(dynamic json) {
    return RoomUserInfo(
        roomUserId: json['roomUserId'],
        userName: json['userName'],
        image: json['image'],
        since: json['since'],
        success: json['success'],
        allSuccess: json['allSuccess'],
        lately: json['lately'],
        allLately: json['allLately']);
  }
}

// class verifyMe {
//   final int userId;
//   final String name;

//   verifyMe({required this.userId, required this.name});

//   factory verifyMe.fromJson(dynamic json) {
//     return verifyMe(userId: json['userId'], name: json['name']);
//   }
// }

class RoomUserProfile extends StatefulWidget {
  final int roomId;
  final int userId;
  final int roomUserId;
  final bool is_manager;

  const RoomUserProfile(
      {super.key,
      required this.roomId,
      required this.userId,
      required this.roomUserId,
      required this.is_manager});

  @override
  State<RoomUserProfile> createState() => _RoomUserProfileState();
}

class _RoomUserProfileState extends State<RoomUserProfile> {
  Future<RoomUserInfo>? nowUserInfo;
  // Future<verifyMe>? isMe;

  @override
  void initState() {
    super.initState();
    nowUserInfo = fetchUserProfile(widget.roomUserId);
    // isMe = fetchUserId();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: LIGHTGREY,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<RoomUserInfo>(
          future: nowUserInfo,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Center(child: CircularProgressIndicator())]);
            } else if (snapshot.hasError) {
              log("유저 프로필 연결 실패: ${snapshot.error}");
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(5, 30, 5, 30),
                    child: Text(
                      '서버 연결에 실패하였습니다.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'bm',
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
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
                ],
              );
            }

            // 서버 연결 성공
            else if (snapshot.hasData) {
              // log("----User Profile----");
              // log("room id: ${widget.roomId}");
              // log("user id: ${widget.userId}");
              // log("room user id: ${snapshot.data!.roomUserId}");
              // log("user name: ${snapshot.data!.userName}");
              // log("room user image: ${snapshot.data!.image}");
              // log("since: ${snapshot.data!.since}");
              // log("success: ${snapshot.data!.success}");
              // log("all success: ${snapshot.data!.allSuccess}");
              // log("lately: ${snapshot.data!.lately}");
              // log("allLately: ${snapshot.data!.allLately}");
              // log("----User Profile----");

              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
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
                              child: Image.network(
                                snapshot.data!.image['url'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 닉네임
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              '${snapshot.data!.userName}',
                              style: const TextStyle(
                                color: POINT_COLOR,
                                fontFamily: 'bm',
                                fontSize: 28,
                              ),
                            ),
                          ),
                          Text(
                            'Since ${snapshot.data!.since}',
                            style: const TextStyle(
                                color: POINT_COLOR,
                                fontFamily: 'bma',
                                fontSize: 15),
                          ),
                          Text(
                            '인증 성공 횟수: ${snapshot.data!.success}/${snapshot.data!.allSuccess}',
                            style: const TextStyle(
                                color: POINT_COLOR,
                                fontFamily: 'bma',
                                fontSize: 15),
                          ),
                          Text(
                            '최근 인증 횟수: ${snapshot.data!.lately}/${snapshot.data!.allLately}',
                            style: const TextStyle(
                                color: POINT_COLOR,
                                fontFamily: 'bma',
                                fontSize: 15),
                          ),
                        ],
                      )),
                    ],
                  ),

                  // 방장일 경우 권한 위임 및 강퇴 버튼 노출
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
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  delegate(context, snapshot.data!.userName);
                                },
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
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  repel(context, snapshot.data!.userName);
                                },
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
                                  '추방',
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
                              width: MediaQuery.of(context).size.width * 0.2,
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

                      // 방장 아닐 경우 창 닫기 버튼만 생성
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
                ],
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
      ),
    );
  }

  // 권한 위임
  void delegate(BuildContext context, String userName) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: LIGHTGREY,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              "정말 ${userName}님에게 방장 권한을 넘기시겠습니까?",
              style: const TextStyle(
                color: POINT_COLOR,
                fontSize: 20,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  String delegateURL =
                      '$serverUrl/api/v1/room/delegate?userId=${widget.userId}';
                  final response = await http.post(
                    Uri.parse(delegateURL),
                    headers: {
                      'Content-Type': 'application/json; charset=UTF-8',
                      'Authorization':
                          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
                    },
                    body: jsonEncode({"roomId": widget.roomId}),
                  );
                  try {
                    if (response.statusCode == 200) {
                      log("방장 권한 위임 성공");
                    } else
                      log("Error: ${response.body}");
                  } catch (e) {
                    log(response.body);
                    log('$e');
                    throw Exception('네트워크 오류가 발생했습니다.');
                  }

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const mainPage())); //창 닫기
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: POINT_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(
                    color: POINT_COLOR,
                    width: 1.0,
                  ),
                ),
                child: const Text(
                  "예",
                  style: TextStyle(
                      color: Color.fromARGB(226, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(); //창 닫기
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: POINT_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(
                    color: POINT_COLOR,
                    width: 1.0,
                  ),
                ),
                child: const Text("아니오",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }));
  }

  // 강퇴
  void repel(BuildContext context, String userName) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: ((context) {
          return AlertDialog(
            backgroundColor: LIGHTGREY,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              "정말 ${userName}님을 추방하시겠습니까?",
              style: const TextStyle(
                color: POINT_COLOR,
                fontSize: 20,
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  String replURL =
                      '$serverUrl/api/v1/room/repel?roomId=${widget.roomId}&userId=${widget.userId}';
                  final response =
                      await http.post(Uri.parse(replURL), headers: {
                    'Authorization':
                        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
                  });
                  try {
                    if (response.statusCode == 200) {
                      log("추방 성공");
                    }
                  } catch (e) {
                    log(response.body);
                    log('$e');
                    throw Exception('네트워크 오류가 발생했습니다.');
                  }

                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: POINT_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(
                    color: POINT_COLOR,
                    width: 1.0,
                  ),
                ),
                child: const Text(
                  "예",
                  style: TextStyle(
                      color: Color.fromARGB(226, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop(); //창 닫기
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: POINT_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  side: const BorderSide(
                    color: POINT_COLOR,
                    width: 1.0,
                  ),
                ),
                child: const Text("아니오",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        }));
  }
}
