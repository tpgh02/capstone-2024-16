import 'dart:convert';
import 'dart:developer';
import 'package:dodo/const/server.dart';
import 'package:http/http.dart' as http;
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

Future<CertiDetail> fetchCertiDetail(int certificationId) async {
  final response = await http.get(
      Uri.parse('$serverUrl/api/v1/certification/detail/${certificationId}'),
      headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
      });

  if (response.statusCode == 200) {
    log('Certification Detail: Connected!');
    return CertiDetail.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Room Main: fail to connect');
  }
}

class CertiDetail {
  final image;
  final int? voteUp;
  final int? voteDown;
  final int? voteUpMax;
  final int? voteDownMax;
  final String? certificationStatus;
  final String? myVoteStatus;

  const CertiDetail(
      {required this.image,
      required this.voteUp,
      required this.voteDown,
      required this.voteUpMax,
      required this.voteDownMax,
      required this.certificationStatus,
      required this.myVoteStatus});

  factory CertiDetail.fromJson(dynamic json) {
    return CertiDetail(
        image: json['image'],
        voteUp: json['voteUp'],
        voteDown: json['voteDown'],
        voteUpMax: json['voteUpMax'],
        voteDownMax: json['voteDownMax'],
        certificationStatus: json['certificationStatus'],
        myVoteStatus: json['myVoteStatus']);
  }
}

class RoomCertiVote extends StatefulWidget {
  final List<dynamic> certificationIdList;
  final int room_id;
  final String user_name;
  const RoomCertiVote(
      {super.key,
      required this.certificationIdList,
      required this.room_id,
      required this.user_name});

  @override
  State<RoomCertiVote> createState() => _RoomCertiVoteState();
}

class _RoomCertiVoteState extends State<RoomCertiVote> {
  late Future<List<CertiDetail>>? futureCertiDetails;

  @override
  void initState() {
    super.initState();
    futureCertiDetails = listToFuture();
  }

  Future<List<CertiDetail>>? listToFuture() async {
    List<Future<CertiDetail>> listFutureDetail = [];

    // 각 certification Id를 불러와 fetch 후 list에 저장
    for (var i = 0; i < widget.certificationIdList.length; i++) {
      Future<CertiDetail> certiDetailIndex =
          fetchCertiDetail(widget.certificationIdList[i]);
      listFutureDetail.add(certiDetailIndex);
    }

    // 데이터 타입 가공
    List<CertiDetail>? certiDetails = await Future.wait(listFutureDetail);
    return certiDetails;
  }

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
            FutureBuilder<List<CertiDetail>>(
                future: futureCertiDetails,
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
                    return Flexible(
                        child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: List.generate(
                                snapshot.data!.length,
                                (index) {
                                  log("${snapshot.data![index].image['url']}");
                                  return Container(
                                      margin: const EdgeInsets.only(bottom: 5),
                                      width: 180,
                                      height: 180,
                                      child: Image.network(
                                          snapshot.data![index].image['url'],
                                          fit: BoxFit.cover));
                                },
                              ),
                            )));
                  } else {
                    return const Text('No data available');
                  }
                }),
            const SizedBox(height: 30),

            // 투표 바
            FutureBuilder<List<CertiDetail>>(
                future: futureCertiDetails,
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
                    num voteupOverVoteupmax = snapshot.data![0].voteUp! == 0
                        ? 0
                        : snapshot.data![0].voteUp! /
                            snapshot.data![0].voteUpMax!;
                    num votedownmaxOverVoteupmax =
                        snapshot.data![0].voteDownMax! /
                            snapshot.data![0].voteUpMax!;
                    num votedownOverVotedownmax =
                        snapshot.data![0].voteDown! == 0
                            ? 0
                            : snapshot.data![0].voteDown! /
                                snapshot.data![0].voteDownMax!;

                    return Column(
                      children: [
                        // 찬성
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async {
                                String voteURL =
                                    '$serverUrl/api/v1/certification/vote';
                                for (var i = 0;
                                    i < widget.certificationIdList.length;
                                    i++) {
                                  final response = await http.post(
                                      Uri.parse(voteURL),
                                      headers: {
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                        'Authorization':
                                            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
                                      },
                                      body: jsonEncode({
                                        "certificationId":
                                            widget.certificationIdList[i],
                                        "voteStatus": "UP"
                                      }));
                                  try {
                                    if (response.statusCode == 200) {
                                      log("찬성 투표 성공");
                                    } else {
                                      log("Error: ${response.body}");
                                    }
                                  } catch (e) {
                                    log(response.body);
                                    log('$e');
                                    throw Exception('네트워크 오류가 발생했습니다.');
                                  }
                                }
                                Navigator.of(context).pop();
                              },
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  width: MediaQuery.of(context).size.width *
                                      0.35 *
                                      voteupOverVoteupmax,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: PRIMARY_COLOR,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Text(
                                "${snapshot.data![0].voteUp} / ${snapshot.data![0].voteUpMax}",
                                style: const TextStyle(
                                    color: POINT_COLOR,
                                    fontFamily: "bm",
                                    fontSize: 18)),
                          ],
                        ),

                        // 반대
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () async {
                                String voteURL =
                                    '$serverUrl/api/v1/certification/vote';
                                for (var i = 0;
                                    i < widget.certificationIdList.length;
                                    i++) {
                                  final response = await http.post(
                                      Uri.parse(voteURL),
                                      headers: {
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                        'Authorization':
                                            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
                                      },
                                      body: jsonEncode({
                                        "certificationId":
                                            widget.certificationIdList[i],
                                        "voteStatus": "DOWN"
                                      }));
                                  try {
                                    if (response.statusCode == 200) {
                                      log("반대 투표 성공");
                                    } else {
                                      log("Error: ${response.body}");
                                    }
                                  } catch (e) {
                                    log(response.body);
                                    log('$e');
                                    throw Exception('네트워크 오류가 발생했습니다.');
                                  }
                                }

                                Navigator.of(context).pop();
                              },
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
                                  width: MediaQuery.of(context).size.width *
                                      0.35 *
                                      votedownmaxOverVoteupmax,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  height: 25,
                                  width: MediaQuery.of(context).size.width *
                                      0.35 *
                                      votedownmaxOverVoteupmax *
                                      votedownOverVotedownmax,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color.fromARGB(
                                        255, 239, 104, 104),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Text(
                                "${snapshot.data![0].voteDown} / ${snapshot.data![0].voteDownMax}",
                                style: const TextStyle(
                                    color: POINT_COLOR,
                                    fontFamily: "bm",
                                    fontSize: 18)),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const Text('No data available');
                  }
                }),
          ],
        ),
      ),
    );
  }
}
