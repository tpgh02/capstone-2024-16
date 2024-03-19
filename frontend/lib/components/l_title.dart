import 'package:flutter/material.dart';

//login 관련 페이지들의 타이틀 컴포넌트
//'로그인', '회원가입', '비밀번호 찾기' 같은 title
class l_title extends StatelessWidget {
  final String title;
  //사용예시) l_title('로그인') 쓰면 됨
  const l_title(this.title);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          //타이틀 text로 출력
          Text(
            '$title',
            style: const TextStyle(fontFamily: "kcc", fontSize: 30),
          ),
        ],
      ),
    );
  }
}
