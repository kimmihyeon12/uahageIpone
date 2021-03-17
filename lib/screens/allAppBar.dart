import 'package:flutter/material.dart';

class appbar extends StatelessWidget {

  sub_appbar(String text ,context){
    // print(this.text);
    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    return  PreferredSize(
      preferredSize: Size.fromHeight(180 / screenHeight),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, centerTitle: true,
        // iconTheme: IconThemeData(
        //   color: Color(0xffff7292), //change your color here
        // ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          text,
          style: TextStyle(
              color: Color(0xffff7292),
              fontFamily: "NotoSansCJKkr_Medium",
              fontSize: 62.0 / screenWidth),
        ),
      ),
    );
  }
  navHome_abbbar(String text,context){
    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
   return PreferredSize(
      preferredSize: Size.fromHeight(178 / screenHeight),
      child: Container(
        color: Color.fromRGBO(255, 114, 148, 1.0),
        height: 178 / screenHeight,
        child: Center(
          child: Text(
             text,
            style: TextStyle(
              fontSize: 73 / screenWidth,
              fontFamily: 'NotoSansCJKkr_Bold',
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
