import 'dart:convert';

import 'package:dodo/components/I_items.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<List<Inven>> fetchInven() async {
  final response = await http
      .get(Uri.parse(serverUrl + '/api/v1/creature/inventory'), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

    List<Inven> invens = jsonData.map((json) => Inven.fromJson(json)).toList();
    return invens;
  } else {
    throw Exception('Failed to load inventory');
  }
}

class Inven {
  final int price;
  final String name;
  final String info;
  final String image;
  final bool activate;
  final int creatureId;

  const Inven({
    required this.price,
    required this.name,
    required this.info,
    required this.image,
    required this.activate,
    required this.creatureId,
  });

  factory Inven.fromJson(dynamic json) {
    return Inven(
      price: json['price'],
      name: json['name'],
      info: json['info'],
      image: json['imageUrl'],
      activate: json["isActivate"],
      creatureId: json['creatureId'],
    );
  }
}

class InvenPage extends StatefulWidget {
  const InvenPage({Key? key}) : super(key: key);

  @override
  State<InvenPage> createState() => _searchPageState();
}

class _searchPageState extends State<InvenPage> {
  final widgetkey = GlobalKey();
  late Future<List<Inven>>? futureInven;

  @override
  void initState() {
    super.initState();
    futureInven = fetchInven();
  }

  @override
  void dispose() {
    super.dispose();
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
                    "보관함",
                    style: TextStyle(
                        fontFamily: 'bm', fontSize: 30, color: POINT_COLOR),
                  ),
                ],
              ),
              Container(
                height: 500,
                child: FutureBuilder<List<Inven>>(
                  future: futureInven,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
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
                          //color: Colors.yellow,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(20),
                          height: 195,

                          child: CustomScrollView(
                            slivers: <Widget>[
                              SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int idx) {
                                    final inven = snapshot.data![idx];
                                    return postContainer(
                                        inven.price,
                                        inven.image,
                                        inven.name,
                                        inven.info,
                                        inven.activate,
                                        (inven.creatureId) ?? 1);
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

  Container postContainer(title, _root, name, info, bool active, c_id) {
    return Container(
      margin: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: i_items(title, _root, name, info, active, c_id),
    );
  }
}
