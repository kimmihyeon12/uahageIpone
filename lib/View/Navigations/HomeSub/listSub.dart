import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uahage/Model/bottom_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uahage/Widget/appBar.dart';
import 'package:uahage/Widget/starManager.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubListPage extends StatefulWidget {
  final index;
  final data;
  final loginOption;
  final userId;
  final tableType;
  const SubListPage(
      {Key key,
      this.index,
      this.data,
      this.loginOption,
      this.userId,
      this.tableType})
      : super(key: key);
  @override
  _SubListPageState createState() => _SubListPageState();
}

class _SubListPageState extends State<SubListPage> {
  WebViewController controller;

  var userId = "", loginOption = "";
  var data, storename, address;
  var star_color = false;
  var tableType = "";

  toast show_toast = new toast();
  StarManage starInsertDelete = new StarManage();
  Future click_star() async {
    await starInsertDelete.click_star(
        userId + loginOption,
        data.store_name,
        data.address,
        data.phone,
        data.menu,
        data.carriage,
        data.bed,
        data.tableware,
        data.nursingroom,
        data.meetingroom,
        data.diapers,
        data.playroom,
        data.chair,
        null,
        null,
        star_color,
        "restaurant");
  }

  Future getSubStarColor() async {
    star_color =
        await starInsertDelete.getSubStarColor(userId, loginOption, storename);
    setState(() {
      star_color = star_color;
    });
  }

  ScrollController _scrollController = ScrollController();
  var enabled = false;
  @override
  void initState() {
    data = widget.data;
    storename = data.store_name;
    address = data.address;
    userId = widget.userId;
    loginOption = widget.loginOption;
    tableType = widget.tableType;

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;

      if (currentScroll == maxScroll) {
        print('max scroll');
        setState(() {
          enabled = true;
        });
      }
    });
    getSubStarColor();

    super.initState();
  }

  var imagecolor = [
    "./assets/searchPage/image1.png",
    "./assets/searchPage/image2.png",
    "./assets/searchPage/image3.png",
    "./assets/searchPage/image4.png",
    "./assets/searchPage/image5.png",
    "./assets/searchPage/image6.png",
    "./assets/searchPage/image7.png",
    "./assets/searchPage/image8.png",
    "./assets/searchPage/image9.png",
  ];
  var imagegrey = [
    "./assets/searchPage/image1_grey.png",
    "./assets/searchPage/image2_grey.png",
    "./assets/searchPage/image3_grey.png",
    "./assets/searchPage/image4_grey.png",
    "./assets/searchPage/image5_grey.png",
    "./assets/searchPage/image6_grey.png",
    "./assets/searchPage/image7_grey.png",
    "./assets/searchPage/image8_grey.png",
    "./assets/searchPage/image9_grey.png",
  ];

  var mainimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image3.png"
  ];

  var restaurantListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_sublist/image3.png"
  ];
  var hospitalListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_exam_sublist_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_exam_sublist_/image1.png",
  ];
  var kidsCafeListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image2.png",
  ];
  var experienceListImage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image4.png",
  ];

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  mainImage(image, screenWidth) {
    return CachedNetworkImage(
      imageUrl: image,

      fit: BoxFit.fitWidth,
    );

  }

  @override
  Widget build(BuildContext context) {
    appbar bar = new appbar();
    var index = widget.index;
    var data = widget.data;
    ScreenUtil.init(context, width: 2435, height: 5075);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, star_color);
        return;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: bar.sub_appbar(
              (() {
                if (tableType == 'restaurant') {
                  return "매장안내";
                } else if (tableType == "Examination_institution") {
                  return "영유아 검진 및 구강검진 병원 안내";
                } else if (tableType == "Experience_center") {
                  return "체험관 안내";
                } else {
                  return "키즈카페 안내";
                }
              }()),
              context,
              star_color),
          body: ListView(
            //  controller: _scrollController,
            physics: enabled ? NeverScrollableScrollPhysics() : ScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 2345.w,
                    child: (() {
                      if (tableType == 'restaurant') {
                        if (index % 3 == 1) {
                          return mainImage(restaurantListImage[0], 1501.w);
                        } else if (index % 3 == 2) {
                          return mainImage(restaurantListImage[1], 1501.w);
                        } else
                          return mainImage(restaurantListImage[2], 1501.w);
                      } else if (tableType == 'Examination_institution') {
                        if (index % 2 == 1)
                          return mainImage(hospitalListImage[0], 1501.w);
                        else
                          return mainImage(hospitalListImage[1], 1501.w);
                      } else if (tableType == 'Experience_center') {
                        if (index % 4 == 1)
                          return mainImage(experienceListImage[0], 1501.w);
                        else if (index % 4 == 2)
                          return mainImage(experienceListImage[1], 1501.w);
                        else if (index % 4 == 3)
                          return mainImage(experienceListImage[2], 1501.w);
                        else
                          return mainImage(experienceListImage[3], 1501.w);
                      } else {
                        if (index % 2 == 1)
                          return mainImage(kidsCafeListImage[0], 1501.w);
                        else
                          return mainImage(kidsCafeListImage[1], 1501.w);
                      }
                    }()),
                  ),

                  Card(
                    elevation: 0.3,
                    child: Container(
                      padding:
                          EdgeInsets.only(left: 100.w, top: 89.h, bottom: 89.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 2000.w,
                            child: Text(data.store_name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "NotoSansCJKkr_Bold",
                                    fontSize: 104.0.sp),
                                textAlign: TextAlign.left),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            constraints: BoxConstraints(
                                maxWidth: 98.w, maxHeight: 98.h),
                            icon: Image.asset(
                                star_color
                                    ? "./assets/listPage/star_color.png"
                                    : "./assets/listPage/star_grey.png",
                                height: 98.h),
                            onPressed: loginOption == "login"
                                ? () {
                                    Fluttertoast.showToast(
                                      msg: "  로그인 해주세요!  ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black45,
                                      textColor: Colors.white,
                                      fontSize: 56.sp,
                                    );
                                  }
                                : () async {
                                    setState(() {
                                      star_color = !star_color;
                                    });
                                    await click_star();
                                  },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.3,
                    child: Container(
                      padding: EdgeInsets.only(
                        left:98.h,
                      ),
                      width: MediaQuery.of(context).size.width,
                      // alignment: Alignment.center,
                      //  height: 520 .h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                78 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "주소",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 81.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                20 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 1800.w,
                                child: Text(
                                  data.address == null ? "정보 없음" : data.address,
                                  style: TextStyle(
                                      color: Color(0xff808080),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 81.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              GestureDetector(
                                child: Image.asset(
                                  "./assets/sublistPage/copy.png",
                                  width: 350.w,
                                 //     height: 68.h,
                                ),
                                onTap: () {
                                  FlutterClipboard.copy(data.address);
                                  show_toast.showToast(context, "주소가 복사되었습니다");
                                },
                              )
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                30 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            "연락처",
                            style: TextStyle(
                                color: Color(0xff4d4d4d),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 81.0.sp),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                20 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            data.phone,
                            style: TextStyle(
                                color: Color(0xff808080),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 81.0.sp,
                                height: 1.2),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                75 / (1501 / MediaQuery.of(context).size.width),
                          )),
                        ],
                      ),
                    ),
                  ),
                  (() {
                    if (tableType == 'restaurant') {
                      return Card(
                        elevation: 0.3,
                        child: Container(
                          height: 1400.h,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                  left: 99.w,
                                  top: 50.h,
                                ),
                                child: Text(
                                  "편의시설",
                                  style: TextStyle(
                                      color: Color(0xff4d4d4d),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 81.0.sp,
                                      height: 1.2),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 80.h)),
                              Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 97.w)),
                                    data.menu == "○"
                                        ? Image.asset(
                                            imagecolor[0],
                                            width: 346.w,
                                            height: 467.h,
                                          )
                                        : Image.asset(
                                            imagegrey[0],
                                      width: 346.w,
                                      height: 467.h,
                                          ),
                                    Padding(padding: EdgeInsets.only(left: 97.w)),
                                    data.bed == "○"
                                        ? Image.asset(
                                            imagecolor[1],
                                      width: 346.w,
                                      height: 467.h,
                                          )
                                        : Image.asset(
                                            imagegrey[1],
                                      width: 346.w,
                                      height: 467.h,
                                          ),
                                    Padding(padding: EdgeInsets.only(left: 97.w)),
                                    data.tableware == "○"
                                        ? Image.asset(
                                            imagecolor[2],
                                      width: 346.w,
                                      height: 467.h,
                                          )
                                        : Image.asset(
                                            imagegrey[2],
                                      width: 346.w,
                                      height: 467.h,
                                          ),
                                    Padding(padding: EdgeInsets.only(left: 97.w)),
                                    data.meetingroom == "○"
                                        ? Image.asset(
                                            imagecolor[3],
                                      width: 346.w,
                                      height: 467.h,
                                          )
                                        : Image.asset(
                                            imagegrey[3],
                                      width: 346.w,
                                      height: 467.h,
                                          ),
                                    Padding(padding: EdgeInsets.only(left: 97.w)),
                                    data.diapers == "○"
                                        ? Image.asset(
                                            imagecolor[4],
                                      width: 346.w,
                                      height: 467.h,
                                          )
                                        : Image.asset(
                                            imagegrey[4],
                                      width: 346.w,
                                      height: 467.h,
                                          ),

                                  ]),
                              Padding(padding: EdgeInsets.only(top: 94.h)),
                              Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 97.w)),
                                  data.playroom == "○"
                                      ? Image.asset(
                                          imagecolor[5],
                                    width: 346.w,
                                    height: 467.h,
                                        )
                                      : Image.asset(
                                          imagegrey[5],
                                    width: 346.w,
                                    height: 467.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 97.w)),
                                  data.carriage == "○"
                                      ? Image.asset(
                                          imagecolor[6],
                                    width: 346.w,
                                    height: 467.h,
                                        )
                                      : Image.asset(
                                          imagegrey[6],
                                    width: 346.w,
                                    height: 467.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 97.w)),
                                  data.nursingroom == "○"
                                      ? Image.asset(
                                          imagecolor[7],
                                    width: 346.w,
                                    height: 467.h,
                                        )
                                      : Image.asset(
                                          imagegrey[7],
                                    width: 346.w,
                                    height: 467.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 97.w)),
                                  data.chair == "○"
                                      ? Image.asset(
                                          imagecolor[8],
                                    width: 346.w,
                                    height: 467.h,
                                        )
                                      : Image.asset(
                                          imagegrey[8],
                                    width: 346.w,
                                    height: 467.h,
                                        )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (tableType == "Examination_institution") {
                      return Card(
                        elevation: 0.3,
           child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(
                            left: 98.w,   top: 20.h,
                          ),
                          child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Text(
                                "검진항목",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 81.0.sp),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top:
                                    20 / (1501 / MediaQuery.of(context).size.width),
                              )),
                              Text(
                                data.Examination_item,
                                style: TextStyle(
                                    color: Color(0xff808080),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 81.0.sp,
                                    height: 1.2),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top:
                                    50 / (1501 / MediaQuery.of(context).size.width),
                              )),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return
                        Card(
                          elevation: 0.3,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(
                              left: 98.w,   top: 20.h,
                            ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "관람 / 체험료",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 81.0.sp),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top:
                                    20 / (1501 / MediaQuery.of(context).size.width),
                              )),
                              Text(
                                data.fare == null ? "정보 없음" : data.fare,
                                style: TextStyle(
                                    color: Color(0xff808080),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 81.0.sp,
                                    height: 1.2),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                top:
                                    50 / (1501 / MediaQuery.of(context).size.width),
                              )),
                            ],
                          ),
                      ),
                        );
                    }
                  }()),
                  Card(
                      elevation: 0.3,
                      child: Container(
                        //  height: 1300 .h,
                        width: 2345.w,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                  left: 99.w,
                                  top: 50.h,
                                ),
                                child: Text(
                                  "위치",
                                  style: TextStyle(
                                      color: Color(0xff4d4d4d),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 81.0.sp),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(top: 100.h)),
                            ]),
                      ))
                ],
              ),
              Container(
                height: 2345.h,
                child: WebView(
                  // gestureNavigationEnabled: true,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                    controller.loadUrl(
                        'http://211.223.46.144:3000/map/storename?storename=$storename&address=$address');
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
