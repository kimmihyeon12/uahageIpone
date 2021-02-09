import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:uahage/screens/loginPage.dart';

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
    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
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

                  width: 1446 / screenWidth,
                  // height: 50,
                ),
              ),
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                    left: 658 / screenWidth,
                  )),
                  Image(
                    image: AssetImage('./assets/firstPage/Lighting.png'),
                    height: 440 / screenHeight,
                    width: 143 / screenWidth,
                  ),
                  Image(
                    image: AssetImage('./assets/firstPage/logo.png'),
                    height: 88 / screenHeight,
                    width: 662 / screenWidth,
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
                      top: 626 / screenHeight,
                    )),
                    Text(
                      "회원탈퇴가 완료되었습니다.",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkr_Bold",
                          //   height: 1.0,
                          //   letterSpacing: -1.0,
                          fontSize: 78 / screenHeight,
                          // fontWeight: FontWeight.bold,
                          color: Color(0xffff7292)),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                      top: 127 / screenHeight,
                    )),
                    Text(
                      "그동안 우아하게를 이용해주시고 ",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkr_Medium",
                          //  height: 1.0,
                          //   letterSpacing: -1.0,
                          fontSize: 65 / screenHeight,
                          color: Color(0xffff7292)),
                    ),
                    Text(
                      "그 사랑해주셔서 감사합니다.",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkr_Medium",
                          //  height: 1.0,
                          //   letterSpacing: -1.0,
                          fontSize: 65 / screenHeight,
                          color: Color.fromRGBO(255, 114, 148, 1.0)),
                    ),
                    Text(
                      "더욱더 노력하고 발전하는 우아하게가 되겠습니다.",
                      style: TextStyle(
                          fontFamily: "NotoSansCJKkr_Medium",
                          //  height: 1.0,
                          //   letterSpacing: -1.0,
                          fontSize: 65 / screenHeight,
                          color: Color.fromRGBO(255, 114, 148, 1.0)),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
