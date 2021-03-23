import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uahage/NavigationPage/Bottom.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uahage/screens/allAppBar.dart';
import 'package:uahage/StarManage.dart';
import 'package:uahage/ToastManage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class restaurant_sublist extends StatefulWidget {
  restaurant_sublist(
      {Key key, this.index, this.data, this.userId, this.loginOption})
      : super(key: key);
  int index;
  var data;
  String loginOption;
  String userId;
  @override
  _restaurant_sublistState createState() => _restaurant_sublistState();
}

class _restaurant_sublistState extends State<restaurant_sublist> {
  WebViewController controller;

  var userId = "", loginOption = "";
  var data, storename, address;
  var star_color = false;

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
    // BottomButton();
    storename = data.store_name;
    address = data.address;
    userId = widget.userId;
    loginOption = widget.loginOption;
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

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  mainImage(image, screenWidth) {
    return CachedNetworkImage(
      imageUrl: image,
      // placeholder: (context, url) => buildSpinKitThreeBounce(50, screenWidth),
      fit: BoxFit.fitWidth,
    );
    // Image.network(
    //   image,
    //   loadingBuilder: (context, child, loadingProgress) {
    //     if (loadingProgress == null) return child;
    //     return Center(
    //       child: buildSpinKitThreeBounce(50, screenWidth),
    //     );
    //   },
    //   // width: MediaQuery.of(context).size.width,
    //   fit: BoxFit.fitWidth,
    // );
  }

  @override
  Widget build(BuildContext context) {
    appbar bar = new appbar();
    var index = widget.index;
    var data = widget.data;
    ScreenUtil.init(context, width: 1500, height: 2667);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, star_color);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: bar.sub_appbar("매장안내", context, star_color),
          body: ListView(
            controller: _scrollController,
            physics: enabled ? NeverScrollableScrollPhysics() : ScrollPhysics(),
            children: [
              GestureDetector(
                onPanDown: (a) async {
                  setState(() {
                    print('pandown');
                    enabled = false;
                  });
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 1501.w,
                      child: (() {
                        if (index % 3 == 1) {
                          return mainImage(mainimage[0], 1501.w);
                        } else if (index % 3 == 2) {
                          return mainImage(mainimage[1], 1501.w);
                        } else
                          return mainImage(mainimage[2], 1501.w);
                      }()),
                    ),
                    Card(
                      elevation: 0.3,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 75.w, top: 45.h, bottom: 45.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 1250.w,
                              child: Text(data.store_name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "NotoSansCJKkr_Bold",
                                      fontSize: 77.0.sp),
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
                                  maxWidth: 170.w, maxHeight: 170.h),
                              icon: Image.asset(
                                  star_color
                                      ? "./assets/listPage/star_color.png"
                                      : "./assets/listPage/star_grey.png",
                                  height: 60.h),
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
                          left: 75 / (1501 / MediaQuery.of(context).size.width),
                        ),
                        width: MediaQuery.of(context).size.width,
                        // alignment: Alignment.center,
                        //  height: 520 .h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                              top: 40 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                            Text(
                              "주소",
                              style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 58.0.sp),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              top: 10 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 1065.w,
                                  child: Text(
                                    data.address == null
                                        ? "정보 없음"
                                        : data.address,
                                    style: TextStyle(
                                        color: Color(0xff808080),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 57.0.sp,
                                        height: 1.2),
                                  ),
                                ),
                                GestureDetector(
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "./assets/sublistPage/copy.png",
                                        width: 250.w,
                                        height: 56.h,
                                      ),
                                      // Text(
                                      //   "주소복사",
                                      //   style: TextStyle(
                                      //       color: Color(0xffff7292),
                                      //       fontFamily: "NotoSansCJKkr_Medium",
                                      //       fontSize: 48.0 .w),
                                      // ),
                                    ],
                                  ),
                                  onTap: () {
                                    FlutterClipboard.copy(data.address);
                                    show_toast.showToast(
                                        context, "주소가 복사되었습니다");
                                  },
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              top: 30 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                            Text(
                              "연락처",
                              style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 58.0.sp),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              top: 10 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                            Text(
                              data.phone,
                              style: TextStyle(
                                  color: Color(0xff808080),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 57.0.sp,
                                  height: 1.2),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              top: 75 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 0.3,
                      child: Container(
                        height: 928.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                left: 75.w,
                                top: 50.h,
                              ),
                              child: Text(
                                "편의시설",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 58.0.sp,
                                    height: 1.2),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 50.h)),
                            Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 67.w)),
                                  data.menu == "○"
                                      ? Image.asset(
                                          imagecolor[0],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[0],
                                          width: 218.w,
                                          height: 292.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                  data.bed == "○"
                                      ? Image.asset(
                                          imagecolor[1],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[1],
                                          width: 218.w,
                                          height: 292.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                  data.tableware == "○"
                                      ? Image.asset(
                                          imagecolor[2],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[2],
                                          width: 218.w,
                                          height: 292.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                  data.meetingroom == "○"
                                      ? Image.asset(
                                          imagecolor[3],
                                          width: 218.w,
                                          height: 292.h,
                                        )
                                      : Image.asset(
                                          imagegrey[3],
                                          width: 218.w,
                                          height: 292.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                  data.diapers == "○"
                                      ? Image.asset(
                                          imagecolor[4],
                                          width: 231.w,
                                          height: 284.h,
                                        )
                                      : Image.asset(
                                          imagegrey[4],
                                          width: 231.w,
                                          height: 284.h,
                                        ),
                                  Padding(padding: EdgeInsets.only(left: 59.w)),
                                ]),
                            Padding(padding: EdgeInsets.only(top: 50.h)),
                            Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 67.w)),
                                data.playroom == "○"
                                    ? Image.asset(
                                        imagecolor[5],
                                        width: 218.w,
                                        height: 292.h,
                                      )
                                    : Image.asset(
                                        imagegrey[5],
                                        width: 218.w,
                                        height: 292.h,
                                      ),
                                Padding(padding: EdgeInsets.only(left: 59.w)),
                                data.carriage == "○"
                                    ? Image.asset(
                                        imagecolor[6],
                                        width: 218.w,
                                        height: 292.h,
                                      )
                                    : Image.asset(
                                        imagegrey[6],
                                        width: 218.w,
                                        height: 292.h,
                                      ),
                                Padding(padding: EdgeInsets.only(left: 59.w)),
                                data.nursingroom == "○"
                                    ? Image.asset(
                                        imagecolor[7],
                                        width: 218.w,
                                        height: 292.h,
                                      )
                                    : Image.asset(
                                        imagegrey[7],
                                        width: 218.w,
                                        height: 292.h,
                                      ),
                                Padding(padding: EdgeInsets.only(left: 59.w)),
                                data.chair == "○"
                                    ? Image.asset(
                                        imagecolor[8],
                                        width: 218.w,
                                        height: 292.h,
                                      )
                                    : Image.asset(
                                        imagegrey[8],
                                        width: 218.w,
                                        height: 292.h,
                                      )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                        elevation: 0.3,
                        child: Container(
                          //  height: 1300 .h,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 75.w,
                                    top: 40.h,
                                  ),
                                  child: Text(
                                    "위치",
                                    style: TextStyle(
                                        color: Color(0xff4d4d4d),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 58.0.sp),
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 50.h)),
                              ]),
                        ))
                  ],
                ),
              ),
              Container(
                height: 1100.h,
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
