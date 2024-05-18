import 'package:dodo/const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class c_title extends StatefulWidget {
  final String category;

  const c_title(this.category);

  @override
  State<c_title> createState() => _c_titleState();
}

class _c_titleState extends State<c_title> {
  late String category;

  @override
  void initState() {
    super.initState();
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: DARKGREY)),
          color: Colors.white,
        ),
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: POINT_COLOR,
                      size: 40,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child:
                            Image.asset("assets/images/turtle_noradius.png")),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                        fontFamily: 'kcc', fontSize: 25, color: POINT_COLOR),
                  ),
                ],
              ),
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     Row(
              //       children: [
              //         Container(
              //           width: 8,
              //           height: 8,
              //           decoration: const BoxDecoration(
              //             shape: BoxShape.circle,
              //             color: Colors.green,
              //           ),
              //         ),
              //         const SizedBox(
              //           width: 5,
              //         ),
              //         const Text(
              //           "참여중",
              //           style: TextStyle(
              //               fontFamily: 'kcc',
              //               fontSize: 15,
              //               color: POINT_COLOR),
              //         ),
              //       ],
              //     ),
              //     const Text(
              //       "25개의 챌린지",
              //       style: TextStyle(
              //           fontFamily: 'kcc', fontSize: 15, color: POINT_COLOR),
              //     ),
              //   ],
              // )
            ],
          ),
        ));
  }
}
