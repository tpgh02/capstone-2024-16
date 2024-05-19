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
  // final int? voteUp;
  // final int? voteDown;
  // final int? voteUpMax;
  // final int? voteDownMax;
  final String? certificationStatus;
  // final String? myVoteStatus;

  const CertiDetail({
    required this.image,
    // required this.voteUp,
    // required this.voteDown,
    // required this.voteUpMax,
    // required this.voteDownMax,
    required this.certificationStatus,
    // required this.myVoteStatus
  });

  factory CertiDetail.fromJson(dynamic json) {
    return CertiDetail(
        image: json['image'], certificationStatus: json['certificationStatus']);
  }
}

class RoomCertiApprove extends StatefulWidget {
  final List<dynamic> certificationIdList;
  final int room_id;
  final String user_name;
  const RoomCertiApprove(
      {super.key,
      required this.certificationIdList,
      required this.room_id,
      required this.user_name});

  @override
  State<RoomCertiApprove> createState() => _RoomCertiApproveState();
}

class _RoomCertiApproveState extends State<RoomCertiApprove> {
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
              padding: const EdgeInsets.all(20),
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
                    FutureBuilder<List<CertiDetail>>(
                        future: futureCertiDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
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
                            return Column(
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
                            );
                          } else {
                            return const Text('No data available');
                          }
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
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
