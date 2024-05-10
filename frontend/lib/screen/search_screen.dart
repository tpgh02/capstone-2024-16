import 'package:dodo/components/s_list.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/search2_screen.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPost() async {
  final response = await http
      .get(Uri.parse(serverUrl + '/api/v1/room/search-room'), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  });
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));

    List<Post> Posts = jsonData.map((json) => Post.fromJSON(json)).toList();
    return Posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

class Post {
  final int roomId;
  final String name;
  final String image;
  final String maxUser;
  final String nowUsers;
  final int periodicity;
  final int pwd;
  final int category;
  final String info;
  final bool canChat;
  final int numOfVoteSuccess;
  final int numOfVoteFail;
  final String status;
  final String certificationType;
  final int frequency;
  final List tag;

  Post({
    required this.roomId,
    required this.name,
    required this.image,
    required this.maxUser,
    required this.nowUsers,
    required this.periodicity,
    required this.pwd,
    required this.category,
    required this.info,
    required this.canChat,
    required this.numOfVoteSuccess,
    required this.numOfVoteFail,
    required this.status,
    required this.certificationType,
    required this.frequency,
    required this.tag,
  });

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(
      roomId: json['roomId'],
      name: json['name'],
      image: json['image'],
      maxUser: json['maxUser'],
      nowUsers: json['nowUsers'],
      periodicity: json['periodicity'],
      pwd: json['pwd'],
      category: json['category'],
      info: json['info'],
      canChat: json['canChat'],
      numOfVoteSuccess: json['numOfVoteSuccess'],
      numOfVoteFail: json['numOfVoteFail'],
      status: json['status'],
      certificationType: json['certificationType'],
      frequency: json['frequency'],
      tag: json['tag'] != null ? List<String>.from(json['tag']) : [],
    );
  }
}

class searchPage extends StatefulWidget {
  const searchPage({super.key});

  @override
  State<searchPage> createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  final widgetkey = GlobalKey();
  late Future<List<Post>> _searchResults;
  String _enteredSearchQuery = '';
  @override
  void initState() {
    super.initState();
    _searchResults = fetchPost();
  }

  void _performSearch(String searchQuery) {
    setState(() {
      _enteredSearchQuery = searchQuery;
      _searchResults = fetchPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
              alignment: Alignment.bottomCenter,
              color: LIGHTGREY,
              child: Image.asset("assets/images/turtle_w_e.png")),
          SingleChildScrollView(
            child: Column(
              children: [
                // 누르면 버튼 효과
                Container(
                  margin: const EdgeInsets.all(20),
                  child: InkWell(
                    onTap: () {
                      //한번 눌렀을 때 페이지 이동함
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => search2Page(
                                  searchQuery: _enteredSearchQuery)));
                    },

                    // TextField인 척하는 컨테이너
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      height: 50,
                      decoration: const UnderlineTabIndicator(
                          borderSide: BorderSide(color: POINT_COLOR, width: 5)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _enteredSearchQuery.isEmpty
                                ? '검색어를 입력하세요'
                                : _enteredSearchQuery,
                            style: const TextStyle(
                                fontFamily: 'kcc',
                                color: POINT_COLOR,
                                fontSize: 18),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.search,
                              color: POINT_COLOR,
                              size: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<Post>>(
                  future: _searchResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data!.map((post) {
                          return ListTile(
                            title: Text(post.name),
                            subtitle: Text(post.info),
                            // 원하는 다른 정보 추가 가능
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(child: Text('No results found'));
                    }
                  },
                ),
                const s_list(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
