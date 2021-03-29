import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uahage/NavigationPage/Home.dart';
import 'package:uahage/NavigationPage/MyPage.dart';
import 'package:uahage/NavigationPage/Search.dart';
import 'package:uahage/NavigationPage/Star.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/Location.dart';
import 'package:uahage/screens/SnackBar.dart';
import '../connectivity_status.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    print("lat: $lat long: $long");

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
    ScreenUtil.init(context, width: 1500, height: 2667);
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
          Navigator.pop(context, true);
        } else
          SystemNavigator.pop();
        // Navigator.pop(context, true);
      },
      child: SafeArea(
          child: Scaffold(
              body: Stack(
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
                                width: 79.w,
                                height: 144.h,
                              ),
                              label: "home",
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/home_pink.png",
                                width: 79.w,
                                height: 144.h,
                              ),
                              // title: Text("home"),
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: Image.asset(
                                "assets/NavigationbarPage/search_grey.png",
                                width: 79.w,
                                height: 139.h,
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/search_pink.png",
                                width: 79.w,
                                height: 139.h,
                              ),
                              // title: Text("search"),
                            ),
                            BottomNavigationBarItem(
                              label: "",
                              icon: Image.asset(
                                "assets/NavigationbarPage/star_grey.png",
                                width: 162.w,
                                height: 147.h,
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/star_pink.png",
                                width: 162.w,
                                height: 147.h,
                              ),
                              // title: Text("star"),
                            ),
                            BottomNavigationBarItem(
                              label: "",

                              icon: Image.asset(
                                "assets/NavigationbarPage/mypage_grey.png",
                                width: 132.w,
                              ),
                              activeIcon: Image.asset(
                                "assets/NavigationbarPage/mypage_pink.png",
                                width: 132.w,
                                height: 141.h,
                              ),
                              // title: Text("mypage"),
                            ),
                          ],
                        )
                      : null)),
    );
  }
}
