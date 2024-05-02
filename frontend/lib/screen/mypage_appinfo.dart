import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myPageAppBar("서비스 이용 약관"),
      backgroundColor: LIGHTGREY,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Text('서비스 이용 약관'),
      ),
    );
  }
}

class OpenSourceLicense extends StatelessWidget {
  const OpenSourceLicense({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myPageAppBar("오픈소스 라이선스"),
      backgroundColor: LIGHTGREY,
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Text('오픈소스 라이선스'),
      ),
    );
  }
}

PreferredSizeWidget myPageAppBar(String title) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(80),
    child: Container(
      width: 390,
      height: 80,
      // Border Line
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Color(0x7F414C58),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppBar(
            backgroundColor: LIGHTGREY,
            leading: const BackButton(
              color: PRIMARY_COLOR,
            ),
            title: Text(
              title,
              style: const TextStyle(
                color: PRIMARY_COLOR,
                fontFamily: "bm",
                fontSize: 30,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
