import 'package:dodo/components/l_title.dart';
import 'package:dodo/screen/findpass_screen.dart';
import 'package:flutter/material.dart';

class signupPage extends StatelessWidget {
  //signupPage({super.key});
  String? emailAddress;
  String? name;
  String? password;
  String? passcheck;
  int? state;

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
    return Scaffold(
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                child: ListView(
                  shrinkWrap: true,
                  children: [
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
                      '회원가입',
                      style: TextStyle(fontFamily: 'kcc', fontSize: 30),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //이메일
                    SizedBox(
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          labelText: '이메일주소',
                          filled: true,
                          fillColor: Color(0xffEDEDED),
                          labelStyle:
                              TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //사용자이름
                    SizedBox(
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          labelText: '사용자이름',
                          filled: true,
                          fillColor: Color(0xffEDEDED),
                          labelStyle:
                              TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //비밀번호
                    SizedBox(
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 20),
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          labelText: '비밀번호',
                          filled: true,
                          fillColor: Color(0xffEDEDED),
                          labelStyle:
                              TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //비밀번호 확인
                    SizedBox(
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(fontSize: 20),
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          labelText: '비밀번호확인',
                          filled: true,
                          fillColor: Color(0xffEDEDED),
                          labelStyle:
                              TextStyle(color: Color(0xff4f4f4f), fontSize: 18),
                        ),
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
                                builder: (context) => findpassPage()));
                      },
                      child: Text(
                        '회원가입',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Image.asset('assets/images/earth.png',
                width: 500,
                height: 175,
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter),
          ],
        ));
  }
}
