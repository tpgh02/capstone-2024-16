import 'dart:convert';
import 'dart:developer';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/inventory_screen.dart';
import 'package:dodo/screen/store_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Items {
  final int seaCreatureId;
  final int coordinate_x;
  final int coordinate_y;
  final bool isActivate;
  final String imageUrl;

  Items({
    required this.seaCreatureId,
    required this.coordinate_x,
    required this.coordinate_y,
    required this.isActivate,
    required this.imageUrl,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      seaCreatureId: json['seaCreatureId'],
      coordinate_x: json['coordinate_x'],
      coordinate_y: json['coordinate_y'],
      isActivate: json['isActivate'],
      imageUrl: json['imageUrl'],
    );
  }
}

Future<List<Items>> fetchItems() async {
  final response = await http.get(
    Uri.parse(serverUrl + '/api/v1/creature/sea'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
    },
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<Items> Itemss = jsonData.map((json) => Items.fromJson(json)).toList();
    print(Itemss);
    log(jsonDecode(utf8.decode(response.bodyBytes)).toString());
    return Itemss;
  } else {
    throw Exception('Failed to load data');
  }
}

class seaPage extends StatefulWidget {
  @override
  State<seaPage> createState() => _seaPageState();
}

class _seaPageState extends State<seaPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Items>>(
      future: fetchItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            key: GlobalKey(),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.asset(
                    "assets/images/sea.png",
                    fit: BoxFit.cover,
                  ),
                ),
                for (var item in snapshot.data!)
                  Positioned(
                    left: item.coordinate_x.toDouble(),
                    top: item.coordinate_y.toDouble(),
                    child: Container(
                      width: 120,
                      height: 120,
                      child: Image.network(
                        item.imageUrl,
                        scale: 3,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment(
                      Alignment.bottomRight.x, Alignment.bottomRight.y - 0.3),
                  child: Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(20),
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvenPage()));
                      },
                      backgroundColor: PRIMARY_COLOR,
                      heroTag: "actionButton",
                      child: Text(
                        "보관함",
                        style: TextStyle(
                            fontFamily: 'bm',
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      elevation: 1,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 70,
                    height: 70,
                    margin: const EdgeInsets.all(20),
                    child: FloatingActionButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => storePage()));
                      },
                      backgroundColor: PRIMARY_COLOR,
                      heroTag: "actionButton",
                      child: Text(
                        "상점",
                        style: TextStyle(
                            fontFamily: 'bm',
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      elevation: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/images/sea.png",
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(
                  color: Colors.white70,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "Error: ${snapshot.error}",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontFamily: 'bm',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
