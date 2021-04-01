import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/homepagelist/distance.dart';
import 'dart:convert';
import 'dart:async';
import 'package:uahage/homepagelist/map_list.dart';
import 'package:uahage/homepagelist/sublist/exaimination_institution_sublist.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/ToastManage.dart';
import 'package:uahage/StarManage.dart';
import 'package:uahage/homepagelist/examination_institution_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class examination_institution extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  // String oldNickname;
  examination_institution(
      {Key key,
      this.userId,
      this.loginOption,
      this.latitude,
      this.longitude,
      this.Area,
      this.Locality})
      : super(key: key);
  @override
  _examination_institutionState createState() =>
      _examination_institutionState();
}

class _examination_institutionState extends State<examination_institution> {
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  String userId = "";
  String loginOption = "";
  String liststringdata = 'Examination_institution';
  String store_name1, address1, phone1, Examination_item1;
  var star_color = false;
  List<bool> star_color_list = [];
  var list = true;
  int _currentMax = 0;
  var indexcount = 0;
  // ScrollController _scrollController = ScrollController();

  var listimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image2.png",
  ];

  Future<List<dynamic>> myFuture;
  List<dynamic> examination_institutions = [];
  ScrollController _scrollController = ScrollController();

  List<dynamic> sortedKidsCafe = [];
  List<dynamic> sortedStarList = [];
  Map<double, dynamic> map = new Map();
  var sortedKeys;
  // bool _isLoading;
  toast show_toast = new toast();
  @override
  void initState() {
    // setState(() {
    // _isLoading = false;
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    latitude = widget.latitude;
    longitude = widget.longitude;
    Area = widget.Area ?? "";
    Locality = widget.Locality ?? "";
    // oldNickname = userId != "" ? getMyNickname().toString() : "";
    // });
    // get_star_color();
    myFuture = _getexamination_institution();

    // _scrollController.addListener(() {
    //   double maxScroll = _scrollController.position.maxScrollExtent;
    //   double currentScroll = _scrollController.position.pixels;
    //   // double delta =
    //   //     100.0; // or something else..maxScroll - currentScroll <= delta
    //   if (currentScroll >= maxScroll * 0.7 &&
    //           currentScroll <= maxScroll * 0.75 &&
    //           !_isLoading ||
    //       currentScroll == maxScroll) {
    //     print("scrolling");
    //     print("isloading: $_isLoading");
    //     _currentMax += 10;
    //     _isLoading = true;
    //     _getexamination_institution();
    //   }
    // });
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
        null,
        Examination_item1,
        star_color,
        liststringdata);
  }

  Future get_star_color() async {
    star_color_list = await starInsertDelete.getStarColor(
        userId, loginOption, liststringdata);
    setState(() {});
  }

  Future<List<dynamic>> _getexamination_institution() async {
    await get_star_color();
    var response = await http.get(
        'http://211.223.46.144:3000/getList/$liststringdata'); //?maxCount=$_currentMax');
    List responseJson = json.decode(response.body);
    if (json.decode(response.body)[0] == false) {
      // setState(() {
      //   _scrollController.dispose();
      //   _isLoading = false;
      // });
    } else {
      var currentData;
      var distance;
      int i = 0;
      for (var data in responseJson) {
        currentData = examinationinstitution.fromJson(data);
        // start sorting KIDS CAFE
        distance = await distancePoints(
          double.parse(latitude),
          double.parse(longitude),
          currentData.lon,
          currentData.lat,
        );
        sortedKidsCafe.add(distance);
        print("adding to sortedlist");
        map[distance] = {"data": currentData, "starIndex": star_color_list[i]};
        i++;
        // examination_institutions.add(examinationinstitution.fromJson(data));
      }
      // setState(() {
      //   _isLoading = false;
      // });

    }
    sortedKeys = map.keys.toList()..sort();
    for (var keys in sortedKeys) {
      // print("$keys ${map[keys].store_name}");
      examination_institutions.add(map[keys]['data']);
      sortedStarList.add(map[keys]['starIndex']);
    }
    return examination_institutions;
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool toggle = false;
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
                    children: [
                      Image.asset(
                        "./assets/listPage/backbutton.png",
                        width: 44.w,
                        height: 76.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 62.w,
                        ),
                      ),
                      Container(
                        // width: 310.w,
                        // margin: EdgeInsets.only(left: 50.w),
                        child: Text(
                          '병원',
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
            examination_institution_view(context, 1500.w, 2667.h),
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

  Widget examination_institution_view(context, screenWidth, screenHeight) {
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            sortedStarList.length != 0) {
          return Scrollbar(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: examination_institutions?.length,
                itemBuilder: (context, index) {
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
                                      child: examination_institution_sublist(
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
                                    sortedStarList[index] = true;
                                  } else {
                                    sortedStarList[index] = false;
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
                                                if (index % 2 == 0)
                                                  return listimage[0];
                                                else
                                                  return listimage[1];
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

                              //         color:Colors.yellow,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                  maxWidth: 70.w,
                                  maxHeight: 70.h,
                                ),
                                icon: Image.asset(
                                  !sortedStarList[index]
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
                                          Examination_item1 = snapshot
                                              .data[index].Examination_item;

                                          if (sortedStarList[index] == false) {
                                            star_color = true;
                                            sortedStarList[index] = true;
                                            print(' sortedStarList[index]');
                                            print(sortedStarList[index]);
                                          } else {
                                            star_color = false;
                                            sortedStarList[index] = false;
                                          }

                                          click_star();
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
