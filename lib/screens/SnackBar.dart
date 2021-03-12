import 'package:flutter/material.dart';

class SnackBarpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = 2667 / MediaQuery.of(context).size.height;
    var screenWidth = 1501 / MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black54,
      child: Align(
        alignment: Alignment(0.0, 1.0),
        child: Container(
          height: 150 / screenHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black54,
          ),
          margin: EdgeInsets.only(
              bottom: 50 / screenHeight,
              left: 40 / screenWidth,
              right: 40 / screenWidth),
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(left: 80 / screenWidth),
            child: Align(
              alignment: Alignment(-1.0, 0.0),
              child: Text(
                "인터넷 연결상태가 좋지않습니다.",
                style: TextStyle(
                  fontSize: 55 / screenWidth,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
