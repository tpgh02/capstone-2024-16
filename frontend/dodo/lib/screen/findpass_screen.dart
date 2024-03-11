import 'package:dodo/components/l_title.dart';
import 'package:dodo/screen/signup_screen.dart';
import 'package:flutter/material.dart';

class findpassPage extends StatelessWidget {
  //final GlobalKey<FormState> signupKey = GlobalKey();
  const findpassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle l_button = ElevatedButton.styleFrom(
      backgroundColor: Color(0xff1cb5e0),
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: Size(300, 70),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(120),
            child: Container(
              width: 100,
              height: 100,
              alignment: Alignment.topRight,
              padding: EdgeInsets.fromLTRB(0, 30, 30, 0),
              child: Image(
                image: AssetImage('../assets/images/logo.png'),
                width: 110,
                height: 110,
              ),
            ),
          ),
          body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    // Image.asset(
                    //   'assets/images/logo.png',
                    //   width: 20,
                    //   height: 20,
                    //   //fit: BoxFit.fitWidth,
                    //   alignment: Alignment.centerRight,
                    // ),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      '비밀번호 찾기',
                      style: TextStyle(fontFamily: 'kcc', fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '이메일 주소를 입력해주세요',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        //labelText: '이메일주소',
                        filled: true,
                        fillColor: Color(0xffEDEDED),
                        labelStyle:
                            TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: l_button,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => signupPage()));
                      },
                      child: Text(
                        '비밀번호 찾기',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // SizedBox(
                    //   height: 73,
                    // ),
                  ],
                ),
              ),
            ),
            Image.asset('assets/images/earth.png',
                width: 500,
                height: 250, //175
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter),
          ])),
    );
  }
}
