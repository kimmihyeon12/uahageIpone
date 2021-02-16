import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:uahage/screens/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/NavigationPage/Navigationbar.dart';
import 'package:uahage/screens/loginPage.dart';

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
  @override
  void initState() {
    super.initState();
    // _loadUserId();
  }

// _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString('uahageUserId') ?? "";
//       loginOption = prefs.getString("uahageLoginOption") ?? "";
//     });
//   }
  Future startTime() async => Future.delayed(
        Duration(seconds: 3),
        () =>
            // userId == "" ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => loginPage()  ):Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => navigatorPage()

            Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
        ),
      );
// Image(
//           image: AssetImage('./assets/firstPage/backgroundimage.png'),
//           width: MediaQuery.of(context).size.width,
//           fit: BoxFit.fitWidth,
//           // height: 50,
//         ),
  @override
  Widget build(BuildContext context) {
    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    startTime();
    return Scaffold(
        // resizeToAvoidBottomPadding: false,
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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 666 / screenHeight, 0, 0),
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
                          //  height: 1.0,
                          //   letterSpacing: -1.0,
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
                  // height: 50,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
