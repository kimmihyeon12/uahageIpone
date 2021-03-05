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

  getCurrentLocation() async {
    // print("Geolocation started");
    // LocationPermission permission = await Geolocator.requestPermission();

    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = geoposition.latitude.toString();
      longitude = geoposition.longitude.toString();
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("uahageLat", latitude);
    sharedPreferences.setString("uahageLong", longitude);
  }

  @override
  void initState() {
    getCurrentLocation();
    setState(() {
      userId = widget.userId ?? "";
      oldNickname = widget.oldNickname ?? "";
      loginOption = widget.loginOption;
    });
    super.initState();

    // print("userID " + userId);
    // print("loginOption " + loginOption);
    // print("oldnick " + oldNickname);
  }

  int _selectedTabIndex = 0;

  bool isIOS = Platform.isIOS;
  ListQueue<int> _navigationQueue = ListQueue();
  @override
  Widget build(BuildContext context) {
    // print("nav " + latitude);
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
    return isIOS
        ? Scaffold(
            body: IndexedStack(
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
                    loginOption: loginOption),
                starPage(userId: userId, loginOption: loginOption),
                myPage(userId: userId, loginOption: loginOption),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedTabIndex,
              showSelectedLabels: false, // <-- HERE
              showUnselectedLabels: false,
              elevation: 15,
              onTap: (value) {
                _selectedTabIndex = value;

                setState(() {});
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
            ),
          )
        : SafeArea(
            child: Scaffold(
              body: IndexedStack(
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
                      loginOption: loginOption),
                  starPage(userId: userId, loginOption: loginOption),
                  myPage(userId: userId, loginOption: loginOption),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedTabIndex,
                showSelectedLabels: false, // <-- HERE
                showUnselectedLabels: false,
                elevation: 15,
                onTap: (value) {
                  _selectedTabIndex = value;

                  setState(() {});
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
              ),
            ),
          );
  }
}
