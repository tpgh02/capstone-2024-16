import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/findpass_screen.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  //final SignupPage({super.key});
  String? emailAddress;
  String? name;
  String? password;
  String? passcheck;
  int? state;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      backgroundColor: PRIMARY_COLOR,
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size(300, 70),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            width: 100,
            height: 100,
            alignment: Alignment.topRight,
            padding: const EdgeInsets.fromLTRB(0, 30, 30, 0),
            child: const Image(
              image: AssetImage('../assets/images/logo.png'),
              width: 110,
              height: 110,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      '회원가입',
                      style: TextStyle(fontFamily: 'kcc', fontSize: 30),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //이메일
                    const SizedBox(
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
                    const SizedBox(
                      height: 20,
                    ),
                    //사용자이름
                    SizedBox(
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          labelText: '사용자이름',
                          filled: true,
                          fillColor: const Color(0xffEDEDED),
                          labelStyle: TextStyle(color: DARKGREY, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //비밀번호
                    const SizedBox(
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
                    const SizedBox(
                      height: 20,
                    ),
                    //비밀번호 확인
                    const SizedBox(
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: style,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => findpassPage()));
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.bottomRight,
              child: Image.asset('assets/images/turtle.png',
                  width: 150,
                  height: 150, //175
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter),
            ),
          ],
        ));
  }
}
