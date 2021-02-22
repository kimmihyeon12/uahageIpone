import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uahage/NavigationPage/Home.dart';
import 'package:uahage/NavigationPage/MyPage.dart';
import 'package:uahage/NavigationPage/Search.dart';
import 'package:uahage/NavigationPage/Star.dart';
import 'package:geolocator/geolocator.dart';

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
      latitude = '${geoposition.latitude}';
      longitude = '${geoposition.longitude}';
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    setState(() {
      userId = widget.userId ?? "";
      oldNickname = widget.oldNickname ?? "";
      loginOption = widget.loginOption;
    });
    print("userID " + userId);
    print("loginOption " + loginOption);
    print("oldnick " + oldNickname);
  }

  int _selectedTabIndex = 0;

  bool currentTab0 = false;
  bool currentTab1 = false;
  bool currentTab2 = false;
  bool currentTab3 = false;
  Widget CallPage(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return homePage(userId: userId, loginOption: loginOption);
        break;
      case 1:
        return searchPage(
            latitude: latitude,
            longitude: longitude,
            userId: userId,
            loginOption: loginOption);
        break;
      case 2:
        return starPage(userId: userId, loginOption: loginOption);
        break;
      case 3:
        return myPage(userId: userId, loginOption: loginOption);
        break;
    }
  }

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
            body: CallPage(_selectedTabIndex),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedTabIndex,
              showSelectedLabels: false, // <-- HERE
              showUnselectedLabels: false,
              elevation: 15,
              onTap: (value) {
                _selectedTabIndex = value;
                _changeAge(value);
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
              body: CallPage(_selectedTabIndex),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _selectedTabIndex,
                showSelectedLabels: false, // <-- HERE
                showUnselectedLabels: false,
                elevation: 15,
                onTap: (value) {
                  _selectedTabIndex = value;
                  _changeAge(value);
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

  void _changeAge(int value) {
    if (value == 0) {
      currentTab0 = true;
      currentTab1 = false;
      currentTab2 = false;
      currentTab3 = false;
    }
    if (value == 1) {
      currentTab1 = true;
      currentTab0 = false;
      currentTab2 = false;
      currentTab3 = false;
    }
    if (value == 2) {
      currentTab2 = true;
      currentTab0 = false;
      currentTab1 = false;
      currentTab3 = false;
    }
    if (value == 3) {
      currentTab3 = true;
      currentTab1 = false;
      currentTab2 = false;
      currentTab0 = false;
    }
  }
}
