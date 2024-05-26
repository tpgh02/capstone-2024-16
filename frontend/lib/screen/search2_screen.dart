import 'dart:async';
import 'dart:convert';
import 'package:dodo/components/s2_hotroom.dart';
import 'package:dodo/components/s2_tag.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main_screen.dart';
import 'package:dodo/screen/room_join.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<Post>> fetchPost(String searchQuery) async {
  final response = await http.get(
    Uri.parse('$serverUrl/api/v1/room/search-room?string=$searchQuery'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
    List<Post> posts = jsonData.map((json) => Post.fromJSON(json)).toList();
    return posts;
  } else {
    throw Exception('Failed to load posts');
  }
}

class Post {
  final int roomId;
  final String name;
  final image; // 변경: image는 Map<String, dynamic>? 타입
  final int maxUser;
  final int nowUser;
  final String endDay;
  final String periodicity;
  final String? pwd;
  final String category;
  final String? info;
  final bool canChat;
  final int numOfVoteSuccess;
  final int? numOfVoteFail; // 변경: numOfVoteFail는 nullable
  final int? numOfGoal; // 변경: numOfGoal는 nullable
  final List<String>? goal; // 변경: goal는 nullable
  final int? nowGoal; // 변경: nowGoal는 nullable
  final bool isFull;
  final String? status;
  final String roomType;
  final String certificationType;
  final int frequency;
  final List<dynamic>? tag;
  final bool isManager;

  Post({
    required this.roomId,
    required this.name,
    this.image,
    required this.maxUser,
    required this.nowUser,
    required this.endDay,
    required this.periodicity,
    required this.pwd,
    required this.category,
    required this.info,
    required this.canChat,
    required this.numOfVoteSuccess,
    this.numOfVoteFail,
    this.numOfGoal,
    this.goal,
    this.nowGoal,
    required this.isFull,
    this.status,
    required this.roomType,
    required this.certificationType,
    required this.frequency,
    this.tag,
    required this.isManager,
  });

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(
      roomId: json['roomId'],
      name: json['name'],
      image: json['image'], // 변경: image는 Map<String, dynamic>? 타입
      maxUser: json['maxUser'],
      nowUser: json['nowUser'],
      endDay: json['endDay'],
      periodicity: json['periodicity'],
      pwd: json['pwd'],
      category: json['category'],
      info: json['info'],
      canChat: json['canChat'],
      numOfVoteSuccess: json['numOfVoteSuccess'],
      numOfVoteFail: json['numOfVoteFail'], // 변경: nullable 처리
      numOfGoal: json['numOfGoal'],
      goal: json['goal'] != null ? List<String>.from(json['goal']) : null,
      nowGoal: json['nowGoal'],
      isFull: json['isFull'],
      status: json['status'],
      roomType: json['roomType'],
      certificationType: json['certificationType'],
      frequency: json['frequency'],
      tag: json['tag'] != null ? List<String>.from(json['tag']) : null,
      isManager: json['isManager'],
    );
  }
}

class search2Page extends StatefulWidget {
  const search2Page({Key? key}) : super(key: key);

  @override
  State<search2Page> createState() => _search2PageState();
}

class _search2PageState extends State<search2Page> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  Future<List<Post>>? _futurePosts;

  void _performSearch(String query) {
    setState(() {
      _futurePosts = fetchPost(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _performSearch('');
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
              // 상단 부분
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _clearSearch();
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: POINT_COLOR,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: '검색어를 입력하세요',
                          hintStyle: TextStyle(
                            color: DARKGREY,
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: POINT_COLOR,
                              width: 5,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: PRIMARY_COLOR,
                              width: 5,
                            ),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                _performSearch(_searchController.text),
                            icon: const Icon(
                              Icons.search,
                              color: POINT_COLOR,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: 'kcc',
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        onSubmitted: _performSearch,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _futurePosts == null
                  ? Container()
                  : FutureBuilder<List<Post>>(
                      future: _futurePosts,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          List<Post> posts = snapshot.data!;
                          if (posts.isEmpty) {
                            return Text(
                              '해당 데이터가 없습니다.',
                              style: TextStyle(
                                  fontFamily: "bm",
                                  color: DARKGREY,
                                  fontSize: 20),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return _buildRoom(posts[index]);
                              },
                            );
                          }
                        } else {
                          return const Text('No results found');
                        }
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoom(Post post) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => room_join(
                    roomId: post.roomId,
                    room_title: post.name,
                    image: post.image ??
                        {
                          "id": 1,
                          "url":
                              "https://my-dodo-bucket.s3.ap-northeast-2.amazonaws.com/image/default.png"
                        },
                    maxUser: post.maxUser,
                    nowUser: post.nowUser,
                    endDay: post.endDay,
                    periodicity: post.periodicity,
                    room_pwd: post.pwd,
                    info: post.info,
                    canChat: post.canChat,
                    room_type: post.roomType,
                    certificationType: post.certificationType,
                    frequency: post.frequency,
                    tag: post.tag))); //post.roomId, post.name, post.image)));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(color: DARKGREY, width: 1)),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                post.name,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: "bm",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    post.periodicity == 'DAILY' ? '매일' : '매주',
                    style: const TextStyle(
                        fontFamily: "bm", fontSize: 15, color: PRIMARY_COLOR),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  size: 5,
                  Icons.circle,
                  color: PRIMARY_COLOR,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.person,
                  color: PRIMARY_COLOR,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${post.nowUser} / ${post.maxUser}명',
                    style: const TextStyle(
                        fontFamily: "bm", fontSize: 15, color: PRIMARY_COLOR),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              height: 1,
              color: DARKGREY,
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: post.info == null || post.info == ""
                  ? const Text(
                      "소개가 없습니다.",
                      style: TextStyle(
                          fontFamily: "bm", fontSize: 15, color: Colors.black),
                    )
                  : Text(
                      post.info!,
                      style: const TextStyle(
                          fontFamily: "bm", fontSize: 15, color: Colors.black),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
