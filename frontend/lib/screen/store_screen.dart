import 'dart:convert';
import 'dart:developer';
import 'package:dodo/components/items.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<MyInfo> fetchMyInfo_GET() async {
  final response =
      await http.get(Uri.parse('$serverUrl/api/v1/users/me'), headers: {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });

  if (response.statusCode == 200) {
    log('Mypage: Connected!: ${utf8.decode(response.bodyBytes)}');
    return MyInfo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Mypage: fail to connect');
  }
}

class MyInfo {
  final int mileage;

  MyInfo({required this.mileage});

  factory MyInfo.fromJson(dynamic json) {
    return MyInfo(
      mileage: json["mileage"],
    );
  }
}

Future<List<Store>> fetchStore() async {
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU',
    'Content-Type': 'application/json; charset=UTF-8',
  };

  final response = await http.get(
    Uri.parse(serverUrl + '/api/v1/creature/store'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    Iterable storeList =
        jsonDecode(utf8.decode(response.bodyBytes)); //한국어 깨지는 걸 방지하기 위함
    List<Store> stores =
        storeList.map((storeJson) => Store.fromJson(storeJson)).toList();
    log("상점은 서버 오케이");
    return stores;
  } else {
    log("상점이 문제여");
    log(jsonDecode(utf8.decode(response.bodyBytes)));
    throw Exception('Failed to load store data');
  }
}

class Store {
  final int price;
  final String name;
  final String info;
  final String imageurl;
  final int creatureId;
  final bool isOwn;

  const Store({
    required this.price,
    required this.name,
    required this.info,
    required this.imageurl,
    required this.creatureId,
    required this.isOwn,
  });

  factory Store.fromJson(dynamic json) {
    return Store(
      price: json['price'],
      name: json['name'],
      info: json['info'],
      imageurl: json['imageUrl'],
      creatureId: json['creatureId'],
      isOwn: json['isOwn'],
    );
  }
}

class storePage extends StatefulWidget {
  const storePage({super.key});

  @override
  State<storePage> createState() => _storePageState();
}

class _storePageState extends State<storePage> {
  final widgetkey = GlobalKey();
  late Future<List<Store>> futureStore;
  late Future<MyInfo> _myInfo;

  @override
  void initState() {
    super.initState();
    futureStore = fetchStore();
    _myInfo = fetchMyInfo_GET();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHTGREY,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //상단 부분
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: POINT_COLOR,
                    ),
                  ),
                  const Text(
                    "상점",
                    style: TextStyle(
                        fontFamily: 'bm', fontSize: 30, color: POINT_COLOR),
                  ),
                  Spacer(),
                  FutureBuilder<MyInfo>(
                    future: _myInfo,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final mileage = snapshot.data!.mileage;
                        final displayMileage =
                            mileage > 999 ? '999' : mileage.toString();

                        return ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                backgroundColor: LIGHTGREY,
                                title: Text(
                                  '잔여 포인트',
                                  style: TextStyle(
                                    fontFamily: "bm",
                                  ),
                                ),
                                content: Text(
                                  '$mileage',
                                  style: TextStyle(
                                    fontFamily: "bma",
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      '확인',
                                      style: TextStyle(
                                        fontFamily: "bm",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: const Icon(
                                  Icons.attach_money_rounded,
                                  color: Colors.white,
                                ),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                displayMileage,
                                style: TextStyle(
                                  color: POINT_COLOR,
                                  fontFamily: 'bm',
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Text('No data');
                      }
                    },
                  ),
                ],
              ),
              Container(
                height: 600,
                child: FutureBuilder<List<Store>>(
                  future: futureStore,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              '데이터가 존재하지 않습니다. 잠시 후 시도해주십시오',
                              style: TextStyle(
                                  fontFamily: "bm",
                                  fontSize: 20,
                                  color: DARKGREY),
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Text(
                                '데이터가 존재하지 않습니다. 잠시 후 시도해주십시오',
                                style: TextStyle(
                                    fontFamily: "bm",
                                    fontSize: 20,
                                    color: DARKGREY),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(20),
                          height: 195,
                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int idx) {
                                    final store = snapshot.data![idx];
                                    return postContainer(
                                        store.price,
                                        store.imageurl,
                                        store.name,
                                        store.info,
                                        store.creatureId,
                                        store.isOwn);
                                  },
                                  childCount: snapshot.data!.length,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 2 / 3,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: Text(
                          '데이터가 존재하지 않습니다. 잠시 후 시도해주십시오',
                          style: TextStyle(
                              fontFamily: "bm", fontSize: 20, color: DARKGREY),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container postContainer(price, _root, name, info, c_id, isOwn) {
    return Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: items(price, _root, name, info, c_id, isOwn));
  }
}
