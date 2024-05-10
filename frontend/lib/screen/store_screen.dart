import 'dart:convert';
import 'package:dodo/components/items.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
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
    //print(response.headers);
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
  final imageurl;
  final int creatureId;

  const Store({
    required this.price,
    required this.name,
    required this.info,
    required this.imageurl,
    required this.creatureId,
  });

  factory Store.fromJson(dynamic json) {
    return Store(
      price: json['price'],
      name: json['name'],
      info: json['info'],
      imageurl: json['imageUrl'],
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
                      return Container(
                        //color: Colors.yellow,
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
                                      store.creatureId);
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

  Container postContainer(price, _root, name, info, c_id) {
    return Container(
        margin: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: items(price, _root, name, info, c_id));
  }
}
