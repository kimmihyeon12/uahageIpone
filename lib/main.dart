import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:uahage/Location.dart';
import 'package:uahage/screens/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/NavigationPage/Navigationbar.dart';
import 'package:uahage/screens/loginPage.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String userId = "";
  String loginOption = "";
  var Area;
  var Locality;
  String latitude = "";
  String longitude = "";

  @override
  void initState() {
    lacations();
    super.initState();
  }

  Future lacations() async {
    Location location = new Location();
    await location.getCurrentLocation();
  }

  Future startTime() async => Future.delayed(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
        ),
      );
  bool isIOS = Platform.isIOS;
  bool isIphoneX = Device.get().isIphoneX;
  @override
  Widget build(BuildContext context) {
    print("iphoneX $isIphoneX");
    double screenHeight;
    double screenWidth;
    if (isIphoneX) {
      screenHeight = 5076 / MediaQuery.of(context).size.height;
      screenWidth = 2345 / MediaQuery.of(context).size.width;
    } else {
      screenHeight = 2667 / MediaQuery.of(context).size.height;
      screenWidth = 1501 / MediaQuery.of(context).size.width;
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    startTime();
    return isIphoneX
        ? Scaffold(
            backgroundColor: Color(0xfffff1f0),
            // resizeToAvoidBottomPadding: false,
            body: Stack(
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage('./assets/firstPage/backfamily.png'),

                    width: 2172 / screenWidth,
                    // height: 50,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                      left: 983 / screenWidth,
                    )),
                    Image(
                      image: AssetImage('./assets/firstPage/Lighting.png'),
                      height: 1130 / screenHeight,
                      width: 326 / screenWidth,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 135 / screenWidth),
                      child: Image(
                        image: AssetImage('./assets/firstPage/logo.png'),
                        height: 111 / screenHeight,
                        width: 788 / screenWidth,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(0, 1582 / screenHeight, 0, 0),
                        child: Image(
                          image: AssetImage('./assets/firstPage/group.png'),
                          height: 518 / screenHeight,
                          width: 471 / screenWidth,
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(0, 159 / screenHeight, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "우리아이",
                              style: TextStyle(
                                  fontFamily: "S_CoreDream_8",
                                  //   height: 1.0,
                                  //   letterSpacing: -1.0,
                                  fontSize: 146 / screenHeight,
                                  // fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 114, 148, 1.0)),
                            ),
                            Text(
                              "와 함께하는",
                              style: TextStyle(
                                  fontFamily: "S_CoreDream_4",
                                  //  height: 1.0,
                                  //   letterSpacing: -1.0,
                                  fontSize: 146 / screenHeight,
                                  color: Color.fromRGBO(255, 114, 148, 1.0)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 49 / screenHeight, 0, 0),
                        child: Image(
                          image: AssetImage('./assets/firstPage/uahage.png'),
                          height: 194 / screenHeight,
                          // height: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ))
        : Scaffold(
            backgroundColor: Color(0xfffff1f0),
            body: Stack(
              children: [
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.fromLTRB(0, 666 / screenHeight, 0, 0),
                        child: Image(
                          image: AssetImage('./assets/firstPage/group.png'),
                          height: 357 / screenHeight,
                          width: 325 / screenWidth,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 79 / screenHeight, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "우리아이",
                              style: TextStyle(
                                  fontFamily: "S_CoreDream_8",
                                  //   height: 1.0,
                                  //   letterSpacing: -1.0,
                                  fontSize: 71 / screenHeight,
                                  // fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 114, 148, 1.0)),
                            ),
                            Text(
                              "와 함께하는",
                              style: TextStyle(
                                  fontFamily: "S_CoreDream_4",
                                  fontSize: 71 / screenHeight,
                                  color: Color.fromRGBO(255, 114, 148, 1.0)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 49 / screenHeight, 0, 0),
                        child: Image(
                          image: AssetImage('./assets/firstPage/uahage.png'),
                          height: 113 / screenHeight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
