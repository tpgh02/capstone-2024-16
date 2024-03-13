import 'package:dodo/components/l_title.dart';
import 'package:flutter/material.dart';

//이건 너가 만든 대로 넣으면 돼!
class loginPage extends StatelessWidget {
  const loginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            //수현이 파일들어갈 곳!
            l_title('로그인')
          ],
        ),
      ),
    );
  }
}
