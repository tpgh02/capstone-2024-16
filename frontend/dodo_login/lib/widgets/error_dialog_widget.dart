import 'package:flutter/material.dart';
import 'package:insta_clone/exceptions/custom_exception.dart';

void errorDialogWidget(BuildContext context, CustomException e) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(e.code), //에러 코드
        content: Text(e.message), //에러 내용
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('확인')),
        ],
      );
    },
  );
}
