import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:uahage/homepagelist/map_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/experience_center_sublist.dart';
import 'package:uahage/ToastManage.dart';
import 'package:uahage/StarManage.dart';
import 'package:uahage/homepagelist/experience_center_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class experience_center extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  // String oldNickname;
  experience_center(
      {Key key,
      this.userId,
      this.loginOption,
      this.latitude,
      this.longitude,
      this.Area,
      this.Locality})
      : super(key: key);
  @override
  _experience_centerState createState() => _experience_centerState();
}

class _experience_centerState extends State<experience_center> {
  var listimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image4.png",
  ];

  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  String liststringdata = "Experience_center";
  String userId = "";
  String loginOption = "";
  String store_name1, address1, phone1, fare1;
  var star_color = false;
  List<bool> star_color_list = [];
  var list = true;
  var indexcount = 0;

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  toast show_toast = new toast();
  int _currentMax = 0;

  bool _isLoading = false;

  Future<List<dynamic>> myFuture;
  List<dynamic> experience_centers = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // setState(() {
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    latitude = widget.latitude;
    longitude = widget.longitude;
    Area = widget.Area ?? "";
    Locality = widget.Locality ?? "";
    // oldNickname = userId != "" ? getMyNickname().toString() : "";
    // });
    get_star_color();
    _isLoading = false;
    myFuture = _getexperience_center();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      // double delta =
      //     100.0; // or something else..maxScroll - currentScroll <= delta
      if (currentScroll == maxScroll && !_isLoading) {
        print("scrolling");
        print("isloading: $_isLoading");
        _currentMax += 10;
        _isLoading = true;
        _getexperience_center();
      }
    });
    // getCurrentLocation();
    super.initState();
  }

  StarManage starInsertDelete = new StarManage();

  Future click_star() async {
    await starInsertDelete.click_star(
        userId + loginOption,
        store_name1,
        address1,
        phone1,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        fare1,
        null,
        star_color,
        liststringdata);
  }

  Future get_star_color() async {
    star_color_list = await starInsertDelete.getStarColor(
        userId, loginOption, liststringdata);
    setState(() {});
  }

  Future<List<dynamic>> _getexperience_center() async {
    var response = await http.get(
        'http://13.209.41.43/map/getList/$liststringdata?maxCount=$_currentMax');
    List responseJson = json.decode(response.body);
    for (var data in responseJson) {
      experience_centers.add(Experiencecenter.fromJson(data));
    }
    setState(() {
      _isLoading = false;
    });
    return experience_centers;
  }

  bool toggle = false;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  highlightColor: Colors.white,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("./assets/listPage/backbutton.png",
                          width: 44.w, height: 76.h),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 45.w,
                      )),
                      Container(
                        // width: 310.w,
                        child: Text(
                          '체험관',
                          style: TextStyle(
                              fontSize: 62.sp,
                              fontFamily: 'NotoSansCJKkr_Medium',
                              color: Color.fromRGBO(255, 114, 148, 1.0)),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 30.w),
                  child: toggle
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              toggle = !toggle;
                              if (indexcount == 1)
                                indexcount = 0;
                              else
                                indexcount = 1;
                            });
                          },
                          child: Image.asset(
                            './assets/on.png',
                            width: 284.w,
                            height: 133.h,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              toggle = !toggle;
                              if (indexcount == 1)
                                indexcount = 0;
                              else
                                indexcount = 1;
                            });
                          },
                          child: Image.asset(
                            './assets/off.png',
                            width: 284.w,
                            height: 133.h,
                          ),
                        ),
                ),
              ],
            ),
          ),
          body: IndexedStack(index: indexcount, children: <Widget>[
            experience_center_view(context, 1500.w, 2667.h),
            map_list(
                userId: userId,
                loginOption: loginOption,
                latitude: latitude,
                longitude: longitude,
                list: liststringdata,
                Area: Area,
                Locality: Locality),
          ])),
    );
  }

  Widget experience_center_view(context, screenWidth, screenHeight) {
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            star_color_list.length != 0) {
          return Scrollbar(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: experience_centers?.length,
                itemBuilder: (context, index) {
                  print("List index: $index");
                  return Card(
                    elevation: 0.3,
                    child: Container(
                        height: 450.h,
                        padding: EdgeInsets.only(
                          top: 1.h,
                          left: 26.w,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              highlightColor: Colors.white,
                              onTap: () async {
                                bool result = await Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: experience_center_sublist(
                                          index: index,
                                          data: snapshot.data[index],
                                          userId: userId,
                                          loginOption: loginOption),
                                      duration: Duration(milliseconds: 250),
                                      reverseDuration:
                                          Duration(milliseconds: 100),
                                    ));

                                setState(() {
                                  if (result) {
                                    star_color_list[index] = true;
                                  } else {
                                    star_color_list[index] = false;
                                  }
                                });
                              },
                              child: Container(
                                width: 1280.w,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          // border: Border.all(width: 3.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              (() {
                                                if (index % 4 == 0)
                                                  return listimage[0];
                                                else if (index % 4 == 1)
                                                  return listimage[1];
                                                else if (index % 4 == 2)
                                                  return listimage[2];
                                                else
                                                  return listimage[3];
                                              }()),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      height: 414.h,
                                      width: 413.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                      left: 53 /
                                          (1501 /
                                              MediaQuery.of(context)
                                                  .size
                                                  .width),
                                    )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding:
                                                EdgeInsets.only(top: 10.h)),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(top: 20.h),
                                              width: 700.w,
                                              height: 82.h,
                                              child: Text(
                                                snapshot.data[index].store_name,
                                                style: TextStyle(
                                                  fontSize: 56.sp,
                                                  fontFamily:
                                                      'NotoSansCJKkr_Medium',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 255.h,
                                          width: 650.w,
                                          child: Text(
                                            snapshot.data[index].address,
                                            style: TextStyle(
                                              // fontFamily: 'NatoSans',
                                              color: Colors.grey,
                                              fontSize: 56.sp,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30.w, top: 25.h),
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                  maxWidth: 170.w,
                                  maxHeight: 170.h,
                                ),
                                icon: Image.asset(
                                  !star_color_list[index]
                                      ? "./assets/listPage/star_grey.png"
                                      : "./assets/listPage/star_color.png",
                                  height: 60.h,
                                ),
                                onPressed: loginOption == "login"
                                    ? () {
                                        show_toast.showToast(
                                            context, "로그인해주세요!");
                                      }
                                    : () async {
                                        setState(() {
                                          store_name1 =
                                              snapshot.data[index].store_name;
                                          address1 =
                                              snapshot.data[index].address;
                                          phone1 = snapshot.data[index].phone;
                                          fare1 = snapshot.data[index].fare;

                                          if (star_color_list[index] == false) {
                                            star_color = true;
                                            star_color_list[index] = true;
                                          } else {
                                            star_color = false;
                                            star_color_list[index] = false;
                                          }
                                          ;

                                          click_star();
                                        });
                                      },
                              ),
                            )
                          ],
                        )),
                  );
                }),
          );
        } else {
          return Center(
            child: SizedBox(
                width: 60,
                height: 60,
                child: buildSpinKitThreeBounce(80, screenWidth)),
          );
        }
      },
    );
  }
}
