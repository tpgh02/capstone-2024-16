import 'dart:convert';
import 'package:dodo/components/items.dart';
import 'package:dodo/components/s2_hotroom.dart';
import 'package:dodo/components/s2_tag.dart';
import 'package:dodo/components/s_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main2_screen.dart';
import 'package:dodo/screen/search_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<List<Store>> fetchStore() async {
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  };
  final response =
      await http.get(Uri.parse(serverUrl + '/api/v1/creature/store'));
  response.headers.addAll(headers);
  if (response.statusCode == 200) {
    // return Store.fromJson(jsonDecode(response.body)); //한국어 깨짐
    Iterable storeList =
        jsonDecode(utf8.decode(response.bodyBytes)); //한국어 깨지는 걸 방지하기 위함
    List<Store> stores =
        storeList.map((storeJson) => Store.fromJson(storeJson)).toList();
    return stores;
  } else {
    throw Exception('Failed to load album');
  }
}

class Store {
  final int price;
  final String name;
  final String info;
  final image;
  final int creatureId;

  const Store({
    required this.price,
    required this.name,
    required this.info,
    required this.image,
    required this.creatureId,
  });

  factory Store.fromJson(dynamic json) {
    return Store(
      price: json['price'],
      name: json['name'],
      info: json['info'],
      image: json['image'],
      creatureId: json['creatureId'],
    );
  }
}

class storePage extends StatefulWidget {
  const storePage({super.key});

  @override
  State<storePage> createState() => _searchPageState();
}

class _searchPageState extends State<storePage> {
  final widgetkey = GlobalKey();
  late Future<List<Store>>? futureStore;

  @override
  void initState() {
    super.initState();
    futureStore = fetchStore();
  }

  @override
  Widget build(BuildContext context) {
    int idx = 0;
    return Scaffold(
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
                ],
              ),

              Container(
                child: FutureBuilder<List<Store>>(
                    future: futureStore,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!.map((store) {
                            String imageurl = store.image['url'];
                            print(imageurl);
                            return Column(
                              children: [
                                Text('${store.info}'),
                                Text('${store.creatureId}'),
                                Text('Name: ${store.name}'),
                                Text('Price: ${store.price}'),
                                // Image 위젯 사용 시 network 또는 asset 메서드를 사용
                                // Network 이미지일 경우
                                Image.network('${imageurl}'),
                                // Asset 이미지일 경우
                                // Image.asset(store.image),
                                // 추가적으로 필요한 정보 출력
                              ],
                            );
                          }).toList(),
                        );
                        // var imageroot = snapshot.data!.image;
                        // int imageid = imageroot['id'];
                        // String imageurl = imageroot['url'];
                        // return Column(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text('Name: ${snapshot.data!.name}'),
                        //     Text('Price: ${snapshot.data!.price}'),
                        //     Text('Info: ${snapshot.data!.info}'),
                        //     Text('Image: ${imageid}'),
                        //     Image.asset(imageurl),
                        //     Text('${snapshot.data!.creatureId}'),
                        //   ],
                        // );
                      } else {
                        return Text('No data available');
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container postContainer(title, _root, name, info) {
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: items(title, _root, name, info),
    );
  }
}
