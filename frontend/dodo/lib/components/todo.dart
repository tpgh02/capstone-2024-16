//import 'package:dodo/const/colors.dart';
import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';

class todo extends StatelessWidget {
  final String room_name;
  final Image room_img;

  const todo(this.room_name, this.room_img);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            //color: Colors.amber,
          ),
          child: InkWell(
            onTap: () {
              tododialog(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: room_img,
            ),
          ),
        ),
        Container(
          //color: Colors.amber,
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            "$room_name",
            style: const TextStyle(
                fontFamily: "bm", fontSize: 25, color: POINT_COLOR),
          ),
        )
      ],
    );
  }
}

void tododialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
          child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("사진 넣으셨는지~"),
            SizedBox(
              height: 100,
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            )
          ],
        ),
      ));
    },
  );
}
