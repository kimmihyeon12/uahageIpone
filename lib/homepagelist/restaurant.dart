import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// import 'package:uahage/homepagelist/Restaurant_helper.dart';
import 'map_list.dart';
import 'package:uahage/homepagelist/sublist/restaurant_sublist.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/ToastManage.dart';
import 'package:uahage/StarManage.dart';
import 'package:uahage/homepagelist/Restaurant_helper.dart';
import 'package:uahage/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class restaurant extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";

  // String oldNickname;
  restaurant(
      {Key key,
      this.userId,
      this.loginOption,
      this.latitude,
      this.longitude,
      this.Area,
      this.Locality})
      : super(key: key);
  @override
  _restaurantState createState() => _restaurantState();
}

class _restaurantState extends State<restaurant> {
  var indexcount = 0;

  String latitude = "";
  String longitude = "";
  String userId = "";
  String loginOption = "";
  String Area = "";
  String Locality = "";
  String store_name1,
      address1,
      phone1,
      menu1,
      bed1,
      tableware1,
      meetingroom1,
      diapers1,
      playroom1,
      carriage1,
      nursingroom1,
      chair1;
  var list = true;
  toast show_toast = new toast();

  List<bool> star_color_list = [];
  var star_color = false;
  bool toggle = false;

  String liststringdata = "restaurant";
  var listimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image3.png",
  ];

  Future<List<dynamic>> myFuture;
  int _currentMax = 0;
  ScrollController _scrollController = ScrollController();
  bool _isLoading;
  List<dynamic> restaurants;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // setState(() {
    restaurants = [];
    _isLoading = false;
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    latitude = widget.latitude ?? "";
    longitude = widget.longitude ?? "";
    Area = widget.Area ?? "";
    Locality = widget.Locality ?? "";
    // });
    get_star_color();
    myFuture = _getrestaurant();
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
        _getrestaurant();
      }
    });
    super.initState();
  }

  StarManage starInsertDelete = new StarManage();

  Future click_star() async {
    await starInsertDelete.click_star(
        userId + loginOption,
        store_name1,
        address1,
        phone1,
        menu1,
        bed1,
        tableware1,
        meetingroom1,
        diapers1,
        playroom1,
        carriage1,
        nursingroom1,
        chair1,
        null,
        null,
        star_color,
        liststringdata);
  }

  Future get_star_color() async {
    star_color_list = await starInsertDelete.getStarColor(
        userId, loginOption, liststringdata);
    setState(() {});
  }

  Future<List<dynamic>> _getrestaurant() async {
    final response = await http.get(
        'http://13.209.41.43/map/getList/$liststringdata?maxCount=$_currentMax');
    List responseJson = json.decode(response.body);
    for (var data in responseJson) {
      restaurants.add(Restaurant.fromJson(data));
    }
    setState(() {
      _isLoading = false;
    });
    return restaurants;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  icon iconwidget = new icon();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 1500, height: 2667);
    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
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
                    children: [
                      Image.asset(
                        "./assets/listPage/backbutton.png",
                        width: 44.w,
                        height: 76.h,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 45.w,
                      )),
                      Container(
                        // width: 310.w,
                        child: Text(
                          '식당·카페',
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
            restaruant_view(context, 1501.w, 2667.h),
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

  Widget restaruant_view(context, screenWidth, screenHeight) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            star_color_list.length != 0) {
          print("snapshot.hasData: ${snapshot.hasData}  ${snapshot.data}");
          return Scrollbar(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: restaurants?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // print(snapshot.data.id[index]);
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
                                      child: restaurant_sublist(
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
                                //     color:Colors.pink,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          // border: Border.all(width: 3.0),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              (() {
                                                if (index % 3 == 1)
                                                  return listimage[0];
                                                else if (index % 3 == 2)
                                                  return listimage[1];
                                                else
                                                  return listimage[2];
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
                                      left: 53.w,
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
                                          height: 135.h,
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
                                        Container(
                                          margin: EdgeInsets.only(top: 15.h),
                                          height: 120.h,
                                          width: 650.w,
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            children: [
                                              iconwidget.chair(
                                                  snapshot.data[index].chair,
                                                  context),
                                              iconwidget.carriage(
                                                  snapshot.data[index].carriage,
                                                  context),
                                              iconwidget.menu(
                                                  snapshot.data[index].menu,
                                                  context),
                                              iconwidget.bed(
                                                  snapshot.data[index].bed,
                                                  context),
                                              iconwidget.tableware(
                                                  snapshot
                                                      .data[index].tableware,
                                                  context),
                                              iconwidget.meetingroom(
                                                  snapshot
                                                      .data[index].meetingroom,
                                                  context),
                                              iconwidget.diapers(
                                                  snapshot.data[index].diapers,
                                                  context),
                                              iconwidget.playroom(
                                                  snapshot.data[index].playroom,
                                                  context),
                                              iconwidget.nursingroom(
                                                  snapshot
                                                      .data[index].nursingroom,
                                                  context),
                                            ],
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

                              //         color:Colors.yellow,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                  maxWidth: 70.w,
                                  maxHeight: 70.h,
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
                                          bed1 = snapshot.data[index].bed;
                                          phone1 = snapshot.data[index].phone;
                                          menu1 = snapshot.data[index].menu;
                                          tableware1 =
                                              snapshot.data[index].tableware;
                                          meetingroom1 =
                                              snapshot.data[index].meetingroom;
                                          diapers1 =
                                              snapshot.data[index].diapers;
                                          playroom1 =
                                              snapshot.data[index].playroom;
                                          carriage1 =
                                              snapshot.data[index].carriage;
                                          nursingroom1 =
                                              snapshot.data[index].nursingroom;
                                          chair1 = snapshot.data[index].chair;

                                          if (star_color_list[index] == false) {
                                            setState(() {
                                              star_color = true;
                                              star_color_list[index] = true;
                                            });
                                          } else {
                                            setState(() {
                                              star_color = false;
                                              star_color_list[index] = false;
                                            });
                                          }

                                          click_star();

                                          //    _star_color();
                                        });
                                      },
                              ),
                            ),
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
