import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/Model/distance.dart';
import 'dart:convert';
import 'dart:async';
import 'listMap.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:uahage/Widget/starManager.dart';
import 'package:uahage/Model//Restaurant_helper.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/Model/Kids_cafe_helper.dart';
import 'package:uahage/Model/experience_center_helper.dart';
import 'package:uahage/Model/examination_institution_helper.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart';

class ListPage extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  String tableType = "";

  // String oldNickname;
  ListPage(
      {Key key,
      this.userId,
      this.loginOption,
      this.latitude,
      this.longitude,
      this.Area,
      this.Locality,
      this.tableType});
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  var indexcount = 0;
  String latitude = "";
  String longitude = "";
  String userId = "";
  String loginOption = "";
  String Area = "";
  String Locality = "";
  String tableType = "";
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

  var restaurantListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image3.png",
  ];
  var hospitalListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image2.png",
  ];
  var kidsCafeListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/kids_cafe/image2.png",
  ];
  var experienceListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image4.png",
  ];
  Future<List<dynamic>> myFuture;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController _scrollController = ScrollController();
  StarManage starInsertDelete = new StarManage();
  List<dynamic> sortedListData = [];
  List<dynamic> sortedStarList = [];
  Map<double, dynamic> map = new Map();
  var sortedKeys;

  @override
  void initState() {
    sortedListData = [];
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    latitude = widget.latitude ?? "";
    longitude = widget.longitude ?? "";
    Area = widget.Area ?? "";
    Locality = widget.Locality ?? "";
    tableType = widget.tableType ?? "";
    myFuture = _getDataList();
    super.initState();
  }

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
        tableType);
  }

  Future get_star_color() async {
    star_color_list =
        await starInsertDelete.getStarColor(userId, loginOption, tableType);
    setState(() {});
  }

  Future<List<dynamic>> _getDataList() async {
    await get_star_color();
    final response = await http.get(
        'http://211.223.46.144:3000/getList/$tableType'); //?maxCount=$_currentMax');
    List responseJson = json.decode(response.body);
    if (json.decode(response.body)[0] == false) {
    } else {
      var currentData;
      var distance;
      int i = 0;
      for (var data in responseJson) {
        if (tableType == 'restaurant') {
          currentData = Restaurant.fromJson(data);
        } else if (tableType == 'Examination_institution') {
          currentData = examinationinstitution.fromJson(data);
        } else if (tableType == 'Experience_center') {
          currentData = Experiencecenter.fromJson(data);
        } else if (tableType == 'Kids_cafe') {
          currentData = KidsCafe.fromJson(data);
        }

        print("distancePoints $latitude");
        distance = await distancePoints(
          double.parse(latitude),
          double.parse(longitude),
          currentData.lon,
          currentData.lat,
        );
        map[distance] = {"data": currentData, "starIndex": star_color_list[i]};
        i++;
      }

      sortedKeys = map.keys.toList()..sort();
      for (var keys in sortedKeys) {
        print("$keys ${map[keys]['data']}");
        sortedListData.add(map[keys]['data']);
        sortedStarList.add(map[keys]['starIndex']);
      }
    }
    return sortedListData;
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
    ScreenUtil.init(context, width: 2345, height: 5076);

    return SafeArea(
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(600.h),
            child: Container(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(left: 62.w, top: 350.h),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            "./assets/listPage/backbutton.png",
                            width: 64.w,
                            height: 114.h,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            left: 46.w,
                          )),
                          Container(
                             width: 1700.w,
                            child: Text(
                              (() {
                                if (tableType == 'restaurant') {
                                  return "식당·카페";
                                } else if (tableType ==
                                    "Examination_institution") {
                                  return "병원";
                                } else if (tableType == "Experience_center") {
                                  return "체험관";
                                } else {
                                  return "키즈카페";
                                }
                              }()),
                              style: TextStyle(
                                  fontSize: 116.sp,
                                  fontFamily: 'NotoSansCJKkr_Medium',
                                  color: Color.fromRGBO(255, 114, 148, 1.0)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(

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
                                width: 446.w,
                                height: 270.h,
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
                                width: 446.w,
                                height: 270.h,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            // ),
          ),
          body: IndexedStack(index: indexcount, children: <Widget>[
            restaruant_view(context),
            map_list(
                userId: userId,
                loginOption: loginOption,
                latitude: latitude,
                longitude: longitude,
                list: tableType,
                Area: Area,
                Locality: Locality),
          ])),
    );
  }

  Widget restaruant_view(context) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            sortedStarList.length != 0) {

          return Scrollbar(
            child: ListView.builder(
                // controller: _scrollController,
                itemCount: sortedListData?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.3,
                    child: Container(
                        height: 770.h,
                        padding: EdgeInsets.only(
                          top: 40.h,
                          left: 76.w,
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
                                      child: SubListPage(
                                        index: index,
                                        data: snapshot.data[index],
                                        userId: userId,
                                        loginOption: loginOption,
                                        tableType: tableType,
                                      ),
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
                                width: 2000.w,
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
                                                if (tableType == 'restaurant') {
                                                  if (index % 3 == 1)
                                                    return restaurantListImage[
                                                        0];
                                                  else if (index % 3 == 2)
                                                    return restaurantListImage[
                                                        1];
                                                  else
                                                    return restaurantListImage[
                                                        2];
                                                } else if (tableType ==
                                                    'Examination_institution') {
                                                  if (index % 2 == 1)
                                                    return hospitalListImage[0];
                                                  else
                                                    return hospitalListImage[1];
                                                } else if (tableType ==
                                                    'Experience_center') {
                                                  if (index % 4 == 1)
                                                    return experienceListImage[
                                                        0];
                                                  else if (index % 4 == 2)
                                                    return experienceListImage[
                                                        1];
                                                  else if (index % 4 == 3)
                                                    return experienceListImage[
                                                        2];
                                                  else
                                                    return experienceListImage[
                                                        3];
                                                } else {
                                                  if (index % 2 == 1)
                                                    return kidsCafeListImage[0];
                                                  else
                                                    return kidsCafeListImage[1];
                                                }
                                              }()),
                                            ),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      height: 639.h,
                                      width: 639.w,
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                      left: 86.w,
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
                                              width: 900.w,
                                              height: 160.h,
                                              child: Text(
                                                snapshot.data[index].store_name,
                                                style: TextStyle(
                                                  fontSize: 96.sp,
                                                  fontFamily:
                                                      'NotoSansCJKkr_Medium',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 250.h,
                                          width: 900.w,
                                          child: Text(
                                            snapshot.data[index].address,
                                            style: TextStyle(
                                              // fontFamily: 'NatoSans',
                                              color: Colors.grey,
                                              fontSize: 86.sp,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                        tableType == 'restaurant'
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(top: 15.h),
                                                height: 175.h,
                                                width: 900.w,
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Row(
                                                  children: [
                                                    iconwidget.chair(
                                                        snapshot
                                                            .data[index].chair,
                                                        context),
                                                    iconwidget.carriage(
                                                        snapshot.data[index]
                                                            .carriage,
                                                        context),
                                                    iconwidget.menu(
                                                        snapshot
                                                            .data[index].menu,
                                                        context),
                                                    iconwidget.bed(
                                                        snapshot
                                                            .data[index].bed,
                                                        context),
                                                    iconwidget.tableware(
                                                        snapshot.data[index]
                                                            .tableware,
                                                        context),
                                                    iconwidget.meetingroom(
                                                        snapshot.data[index]
                                                            .meetingroom,
                                                        context),
                                                    iconwidget.diapers(
                                                        snapshot.data[index]
                                                            .diapers,
                                                        context),
                                                    iconwidget.playroom(
                                                        snapshot.data[index]
                                                            .playroom,
                                                        context),
                                                    iconwidget.nursingroom(
                                                        snapshot.data[index]
                                                            .nursingroom,
                                                        context),
                                                  ],
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30.w, top: 40.h),

                              //         color:Colors.yellow,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                  maxWidth: 125.w,
                                  maxHeight: 95.h,
                                ),
                                icon: Image.asset(
                                  !sortedStarList[index]
                                      ? "./assets/listPage/star_grey.png"
                                      : "./assets/listPage/star_color.png",
                                  height: 95.h,
                                ),
                                onPressed: loginOption == "login"
                                    ? () {
                                        show_toast.showToast(
                                            context, "로그인해주세요!");
                                      }
                                    : () async {
                                        setState(() {
                                          if( tableType =='restaurant'){
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
                                          }

                                          if (sortedStarList[index] == false) {
                                            setState(() {
                                              star_color = true;
                                              sortedStarList[index] = true;
                                            });
                                          } else {
                                            setState(() {
                                              star_color = false;
                                              sortedStarList[index] = false;
                                            });
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
        }
        return Center(
          child: SizedBox(
              width: 60,
              height: 60,
              child: buildSpinKitThreeBounce(80, 2345.h)),
        );
      },
    );
  }
}
