import 'package:dodo/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class seaPage extends StatefulWidget {
  const seaPage({super.key});

  @override
  State<seaPage> createState() => _seaPageState();
}

class _seaPageState extends State<seaPage> {
  final widgetkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      key: widgetkey,
      child: Stack(children: [
        Image.asset(
          "../assets/images/sea.png",
          //fit: BoxFit.contain,
        ),
        Container(
          // color: Colors.red,
          padding: EdgeInsets.fromLTRB(150, 300, 150, 200),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 120,
              height: 120,
              child: Image.asset("../assets/images/turtle.png"),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            width: 70,
            height: 70,
            margin: EdgeInsets.all(20),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              onPressed: () {},
              backgroundColor: PRIMARY_COLOR,
              heroTag: "actionButton",
              child: Text(
                "업적",
                style: TextStyle(
                    fontFamily: 'bm', fontSize: 20, color: Colors.white),
              ),
              elevation: 1,
            ),
          ),
        ),
        Align(
          alignment:
              Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y - 0.3),
          child: Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.all(20),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              onPressed: () {},
              backgroundColor: PRIMARY_COLOR,
              heroTag: "actionButton",
              child: Text(
                "인벤",
                style: TextStyle(
                    fontFamily: 'bm', fontSize: 20, color: Colors.white),
              ),
              elevation: 1,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.all(20),
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              onPressed: () {},
              backgroundColor: PRIMARY_COLOR,
              heroTag: "actionButton",
              child: Text(
                "상점",
                style: TextStyle(
                    fontFamily: 'bm', fontSize: 20, color: Colors.white),
              ),
              elevation: 1,
            ),
          ),
        ),

        //버튼 누를시 좌표 계산(사진 좌표에 넣을 수 있는지, test용)
        // ElevatedButton(
        //     onPressed: () async {
        //       RenderBox renderbox =
        //           widgetkey.currentContext!.findRenderObject() as RenderBox;
        //       Offset position = renderbox.localToGlobal(Offset.zero);
        //       double x = position.dx;
        //       double y = position.dy;

        //       //Top left Corner
        //       print("x:$x");
        //       print("y:$y");

        //       double width = renderbox.size.width;
        //       double height = renderbox.size.height;

        //       print("width: $width");
        //       print("height:: $height");

        //       //top right corner
        //       print("x+w: ${x + width}");
        //       print("y:$y");

        //       //bottom left corner
        //       print("x$x");
        //       print("y+h: ${y + height}");

        //       //bottom right corner
        //       print("x+w: ${x + width}");
        //       print("y+h: ${y + height}");
        //     },
        //     child: Text("Get X and Y Positon of Container"),),
      ]),
    );
  }
}
