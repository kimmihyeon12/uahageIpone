import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:uahage/NavigationPage/Navigationbar.dart';
import 'package:uahage/main.dart';
import 'package:uahage/screens/agreement.dart';
import 'package:uahage/screens/registrationPage.dart';
import 'package:uahage/screens/SnackBar.dart';

import '../connectivity_status.dart';
import 'package:provider/provider.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool isIOS = Platform.isIOS;
  bool isIphoneX = Device.get().isIphoneX;

  double screenHeight;
  double screenWidth;
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (isIphoneX) {
      screenHeight = 5076 / MediaQuery.of(context).size.height;
      screenWidth = 2345 / MediaQuery.of(context).size.width;
    } else if (isIOS) {
      print("shu1");
      screenHeight = 1390 / MediaQuery.of(context).size.height;
      screenWidth = 781.5 / MediaQuery.of(context).size.width;
    } else {
      screenHeight = 2667 / MediaQuery.of(context).size.height;
      screenWidth = 1501 / MediaQuery.of(context).size.width;
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // logo 1
              Container(
                margin: EdgeInsets.fromLTRB(588 / screenWidth,
                    489 / screenHeight, 588 / screenWidth, 0),
                child: Image.asset(
                  "./assets/secondPage/logo.png",
                  height: 357 / screenHeight,
                  width: 325 / screenWidth,
                ),
              ),

              // 우리아이와 함께하는
              Container(
                margin: EdgeInsets.fromLTRB(0, 79 / screenHeight, 0, 0),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        style: const TextStyle(
                            color: const Color(0xffff7292),
                            fontWeight: FontWeight.w900,
                            fontFamily: "S_CoreDream_8",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                        text: "우리아이와"),
                    TextSpan(
                        style: const TextStyle(
                            color: const Color(0xffff7292),
                            fontWeight: FontWeight.w400,
                            fontFamily: "S_CoreDream_4",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                        text: "와 함께하는")
                  ]),
                ),
              ),

              // Logo Image
              Container(
                margin: EdgeInsets.fromLTRB(
                    545 / screenWidth, 49 / screenHeight, 546 / screenWidth, 0),
                child: Image.asset("./assets/secondPage/logoName.png"),
              ),

              //hearts
              Container(
                margin: EdgeInsets.fromLTRB(
                    79 / screenWidth, 71 / screenHeight, 79 / screenWidth, 0),
                child: Image.asset("./assets/secondPage/hearts.png"),
              ),

              // kakao
              Container(
                margin: EdgeInsets.fromLTRB(
                    96 / screenWidth, 69 / screenHeight, 94 / screenWidth, 0),
                height: 195 / screenHeight,
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            agreementPage(loginOption: "kakao")));
                  },
                  child: Image.asset(
                    "./assets/secondPage/kakao.png",
                    height: 195 / screenHeight,
                    width: 1311 / screenWidth,
                  ),
                ),
              ),

              // Naver
              Container(
                margin: EdgeInsets.fromLTRB(
                    96 / screenWidth, 53 / screenHeight, 94 / screenWidth, 0),
                height: 195 / screenHeight,
                child: InkWell(
                  onTap: () {
                    print("Naver login");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            agreementPage(loginOption: "naver")));
                  },
                  child: Image.asset("./assets/secondPage/naver.png"),
                ),
              ),

              // Button
              Container(
                margin: EdgeInsets.fromLTRB(
                    96 / screenWidth, 53 / screenHeight, 94 / screenWidth, 0),
                height: 195 / screenHeight,
                child: InkWell(
                  onTap: () {
                    print("login");
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            agreementPage(loginOption: "login")));
                  },
                  child: Image.asset("./assets/secondPage/button.png"),
                ),
              ),
            ],
          ),
          connectionStatus == ConnectivityStatus.Offline
              ? SnackBarpage()
              : Container(),
        ],
      ),
    );
  }
}
