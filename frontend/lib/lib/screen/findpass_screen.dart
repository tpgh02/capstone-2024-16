import 'package:dodo/components/l_title.dart';
import 'package:dodo/const/colors.dart';
import 'package:dodo/screen/signup_screen.dart';
import 'package:flutter/material.dart';

class findpassPage extends StatelessWidget {
  //final GlobalKey<FormState> signupKey = GlobalKey();
  const findpassPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle l_button = ElevatedButton.styleFrom(
      backgroundColor: PRIMARY_COLOR,
      textStyle: const TextStyle(fontSize: 20),
      minimumSize: const Size(300, 70),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    return PopScope(
      child: Scaffold(
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
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              //color: Colors.amber,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: Form(
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            const l_title("비밀번호 찾기"),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              '이메일 주소를 입력해주세요',
                            ),
                            const SizedBox(
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
                                fillColor: LIGHTGREY,
                                labelStyle:
                                    TextStyle(color: DARKGREY, fontSize: 18),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              style: l_button,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupPage()));
                              },
                              child: const Text(
                                '비밀번호 찾기',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   height: ,
                    // ),
                    Container(
                      alignment: Alignment.bottomRight,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset('assets/images/turtle.png',
                          width: 150,
                          height: 150, //175
                          fit: BoxFit.cover,
                          alignment: Alignment.bottomCenter),
                    ),
                  ]))),
    );
  }
}
