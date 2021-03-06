import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:uahage/View/Auth/loginPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class withdrawal extends StatefulWidget {
  @override
  _withdrawalState createState() => _withdrawalState();
}

class _withdrawalState extends State<withdrawal> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  Future startTime() async => Future.delayed(
      Duration(seconds: 2),
      () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => loginPage()),
            (Route<dynamic> route) => false,
          ));

  //popUntil((route) => route.isFirst));
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
            // resizeToAvoidBottomPadding: false,
            body: Stack(
          children: [
            Container(
              child: Image(
                image: AssetImage('./assets/firstPage/backgroundimage.png'),
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.fitWidth,
              ),
              //  color:Colors.black
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image(
                image: AssetImage('./assets/firstPage/backfamily.png'),
                height: 1415.h,
                width: 1446.w,
                // height: 50,
              ),
            ),
            Row(
              children: [
                Padding(
                    padding: EdgeInsets.only(
                  left: 658.w,
                )),
                Image(
                  image: AssetImage('./assets/firstPage/Lighting.png'),
                  height: 440.h,
                  width: 143.w,
                ),
                Image(
                  image: AssetImage('./assets/firstPage/logo.png'),
                  height: 88.h,
                  width: 662.w,
                ),
              ],
            ),
            Center(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                    top: 626.h,
                  )),
                  Text(
                    "??????????????? ?????????????????????.",
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkr_Bold",
                        //   height: 1.0,
                        //   letterSpacing: -1.0,
                        fontSize: 78.sp,
                        // fontWeight: FontWeight.bold,
                        color: Color(0xffff7292)),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    top: 100.h,
                  )),
                  Text(
                    "????????? ??????????????? ?????????????????? ",
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkr_Medium",
                        // height: 0.8,
                        //   letterSpacing: -1.0,
                        fontSize: 63.sp,
                        color: Color.fromRGBO(255, 114, 142, 1.0)),
                  ),
                  Text(
                    "??? ?????????????????? ???????????????.",
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkr_Medium",
                        //  height: 1.0,
                        //   letterSpacing: -1.0,
                        fontSize: 63.sp,
                        color: Color.fromRGBO(255, 114, 142, 1.0)),
                  ),
                  Text(
                    "????????? ???????????? ???????????? ??????????????? ???????????????.",
                    style: TextStyle(
                        fontFamily: "NotoSansCJKkr_Medium",
                        //  height: 1.0,
                        //   letterSpacing: -1.0,
                        fontSize: 63.sp,
                        color: Color.fromRGBO(255, 114, 142, 1.0)),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
