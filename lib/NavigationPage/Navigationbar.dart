import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uahage/NavigationPage/Home.dart';
import 'package:uahage/NavigationPage/MyPage.dart';
import 'package:uahage/NavigationPage/Search.dart';
import 'package:uahage/NavigationPage/Star.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoder/geocoder.dart';
import 'package:uahage/Location.dart';
import 'package:uahage/screens/SnackBar.dart';

import '../connectivity_status.dart';
import 'package:provider/provider.dart';

class navigationPage extends StatefulWidget {
  String userId;
  String loginOption;
  String oldNickname;
  navigationPage({Key key, this.oldNickname, this.userId, this.loginOption})
      : super(key: key);
  @override
  _navigationPageState createState() => _navigationPageState();
}

class _navigationPageState extends State<navigationPage> {
  String latitude = "";
  String longitude = "";
  String userId = "";
  String loginOption = "";
  String oldNickname = "";
  var Area;
  var Locality;
  Location location = new Location();
  Future lacations() async {
    await location.getCurrentLocation();
  }

  getLatLong() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String lat = sharedPreferences.getString("uahageLat") ?? "";
    String long = sharedPreferences.getString("uahageLong") ?? "";
    String area = sharedPreferences.getString("uahageArea") ?? "";
    String locality = sharedPreferences.getString("uahageLocality") ?? "";
    print("lat: ${lat} long: ${long}");

    if (lat == "" || long == "") {
      await lacations();
    } else
      setState(() {
        latitude = lat;
        longitude = long;
        Area = area;
        Locality = locality;
      });
  }

  @override
  void initState() {
    getLatLong();
    setState(() {
      userId = widget.userId ?? "";
      oldNickname = widget.oldNickname ?? "";
      loginOption = widget.loginOption;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _selectedTabIndex = 0;

  bool isIOS = Platform.isIOS;
  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    print("navigation 빌드중입니다");
    // print("nav " + longitude);
//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    var ScreenWidth = MediaQuery.of(context).size.width;
    var ScreenHeight = MediaQuery.of(context).size.height;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    isIOS
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
            .copyWith(
                statusBarBrightness:
                    Brightness.dark // Dark == white status bar -- for IOS.
                ))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Color(0xffd9d4d5), // navigation bar color
            statusBarColor: Color(0xffd9d4d5), // status bar color
          ));
    return WillPopScope(
      onWillPop: () {
        if (loginOption == 'login') {
          Navigator.pop(context);
        } else
          SystemNavigator.pop();
      },
      child: SafeArea(
          child: Scaffold(
              body: _selectedTabIndex == 2
                  ? starPage(userId: userId, loginOption: loginOption)
                  : Stack(
                      children: [
                        IndexedStack(
                          index: _selectedTabIndex,
                          children: <Widget>[
                            homePage(
                              userId: userId,
                              loginOption: loginOption,
                              latitude: latitude,
                              longitude: longitude,
                            ),
                            searchPage(
                                latitude: latitude,
                                longitude: longitude,
                                userId: userId,
                                loginOption: loginOption,
                                Area: Area,
                                Locality: Locality),
                            starPage(userId: userId, loginOption: loginOption),
                            myPage(userId: userId, loginOption: loginOption),
                          ],
                        ),
                        connectionStatus == ConnectivityStatus.Offline
                            ? SnackBarpage()
                            : Container(),
                      ],
                    ),
              bottomNavigationBar:
                  (connectionStatus != ConnectivityStatus.Offline)
                      ? BottomNavigationBar(
                          currentIndex: _selectedTabIndex,
                          showSelectedLabels: false, // <-- HERE
                          showUnselectedLabels: false,
                          elevation: 15,
                          onTap: (value) {
                            setState(() {
                              _selectedTabIndex = value;
                            });
                          },
                          type: BottomNavigationBarType.fixed,
                          items: [
                            BottomNavigationBarItem(
                              icon: Image.asset(
                                "assets/NavigationbarPage/home_grey.png",
                                width: 79 / (1501 / ScreenWidth),
                                height: 144 / (2667 / ScreenHeight),
                              ),
                              title: Text("home"),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/home_pink.png",
                                width: 79 / (1501 / ScreenWidth),
                                height: 144 / (2667 / ScreenHeight),
                              ),
                              // title: Text("home"),
                            ),
                            BottomNavigationBarItem(
                              title: Text(""),
                              icon: Image.asset(
                                "assets/NavigationbarPage/search_grey.png",
                                width: 79 / (1501 / ScreenWidth),
                                height: 139 / (2667 / ScreenHeight),
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/search_pink.png",
                                width: 79 / (1501 / ScreenWidth),
                                height: 139 / (2667 / ScreenHeight),
                              ),
                              // title: Text("search"),
                            ),
                            BottomNavigationBarItem(
                              title: Text(""),

                              icon: Image.asset(
                                "assets/NavigationbarPage/star_grey.png",
                                width: 162 / (1501 / ScreenWidth),
                                height: 147 / (2667 / ScreenHeight),
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/star_pink.png",
                                width: 162 / (1501 / ScreenWidth),
                                height: 147 / (2667 / ScreenHeight),
                              ),
                              // title: Text("star"),
                            ),
                            BottomNavigationBarItem(
                              title: Text(""),

                              icon: Image.asset(
                                "assets/NavigationbarPage/mypage_grey.png",
                                width: 132 / (1501 / ScreenWidth),
                                height: 141 / (2667 / ScreenHeight),
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/mypage_grey.png",
                                width: 132 / (1501 / ScreenWidth),
                                height: 141 / (2667 / ScreenHeight),
                              ),
                              // title: Text("mypage"),
                            ),
                          ],
                        )
                      : null)),
    );
  }
}
