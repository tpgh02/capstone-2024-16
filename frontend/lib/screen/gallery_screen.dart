import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/const/server.dart';
import 'package:dodo/screen/main2_screen.dart';

// Fetch images from server
Future<List<Certification>> fetchImg() async {
  var headers = {
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjF9.8PJk4wE2HsDlgLmFA_4PU2Ckb7TWmXfG0Hfz2pRE9WU'
  };
  final response = await http.get(Uri.parse(serverUrl + '/api/v1/report/album'),
      headers: headers);
  if (response.statusCode == 200) {
    Iterable certificationList = jsonDecode(utf8
        .decode(response.bodyBytes)); // To prevent Korean character corruption
    log('$certificationList');
    List<Certification> certifications =
        certificationList.map((json) => Certification.fromJson(json)).toList();
    return certifications;
  } else {
    throw Exception('Failed to load album');
  }
}

// Certification model
class Certification {
  final int certificationId;
  final ImageData image;
  final String date;

  Certification({
    required this.certificationId,
    required this.image,
    required this.date,
  });

  factory Certification.fromJson(dynamic json) {
    return Certification(
      certificationId: json['certificationId'],
      image: ImageData.fromJson(json['image']),
      date: json['date'],
    );
  }
}

// ImageData model
class ImageData {
  final int id;
  final String url;

  ImageData({
    required this.id,
    required this.url,
  });

  factory ImageData.fromJson(dynamic json) {
    return ImageData(
      id: json['id'],
      url: json['url'],
    );
  }
}

// Gallery Page
class galleryPage extends StatefulWidget {
  const galleryPage({super.key});

  @override
  State<galleryPage> createState() => _galleryPageState();
}

class _galleryPageState extends State<galleryPage> {
  final widgetKey = GlobalKey();
  bool downloading = false;
  String progressString = "";

  Future<void> downloadFile(String imgUrl) async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(imgUrl, '${dir.path}/myimage.jpg',
          onReceiveProgress: (rec, total) {
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = 'Completed';
    });
    print('Download completed');
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
              // Top section
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
                    "사진첩",
                    style: TextStyle(
                        fontFamily: 'bm', fontSize: 30, color: POINT_COLOR),
                  ),
                ],
              ),
              // Gallery section
              FutureBuilder<List<Certification>>(
                future: fetchImg(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: Text(
                        '오류가 발생했습니다. 잠시 후 시도해 주십시오',
                        style: TextStyle(
                            fontFamily: 'bm', color: DARKGREY, fontSize: 25),
                      )),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                          child: Text(
                        '이미지가 없습니다.',
                        style: TextStyle(
                            fontFamily: 'bm', color: DARKGREY, fontSize: 25),
                      )),
                    );
                  } else {
                    return Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final certification = snapshot.data![index];
                            return Image.network(
                              certification.image.url,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: downloading
                                ? null
                                : () async {
                                    if (snapshot.hasData &&
                                        snapshot.data!.isNotEmpty) {
                                      await downloadFile(
                                          snapshot.data!.first.image.url);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: PRIMARY_COLOR,
                            ),
                            child: Text(
                              downloading ? progressString : "이미지로 다운받기",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'bm',
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
