import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:uahage/ToastManage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uahage/screens/allAppBar.dart';
import 'package:uahage/StarManage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class experience_center_sublist extends StatefulWidget {
  experience_center_sublist(
      {Key key, this.index, this.data, this.userId, this.loginOption});
  int index;
  var data;
  String loginOption;
  String userId;
  @override
  _experience_center_sublistState createState() =>
      _experience_center_sublistState();
}

class _experience_center_sublistState extends State<experience_center_sublist> {
  WebViewController controller;

  var userId = "", loginOption = "";
  var data, storename, address;
  var star_color = false;

  var mainimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image4.png",
  ];
  @override
  void initState() {
    setState(() {
      data = widget.data;
      storename = data.store_name;
      address = data.address;
      userId = widget.userId;
      loginOption = widget.loginOption;
    });
    getSubStarColor();
    super.initState();
  }

  StarManage starInsertDelete = new StarManage();
  Future click_star() async {
    await starInsertDelete.click_star(
        userId + loginOption,
        data.store_name,
        data.address,
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
        data.fare,
        null,
        star_color,
        "Examination_institution");
  }

  Future getSubStarColor() async {
    star_color =
        await starInsertDelete.getSubStarColor(userId, loginOption, storename);
    setState(() {
      star_color = star_color;
    });
  }

  toast show_toast = new toast();

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size .w,
    );
  }

  // Image mainImage(image, screenWidth) {
  //   return Image.network(
  //     image,
  //     loadingBuilder: (context, child, loadingProgress) {
  //       if (loadingProgress == null) return child;
  //       return Center(
  //         child: buildSpinKitThreeBounce(50, screenWidth),
  //       );
  //     },
  //     // width: MediaQuery.of(context).size.width,
  //     fit: BoxFit.fitWidth,
  //   );
  // }
  mainImage(image, screenWidth) {
    return CachedNetworkImage(
      imageUrl: image,
      // placeholder: (context, url) => buildSpinKitThreeBounce(50, screenWidth),
      fit: BoxFit.fitWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    var index = widget.index;
    var data = widget.data;
    appbar bar = new appbar();
    ScreenUtil.init(context, width:  1500 , height:  2667 );
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, star_color);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: bar.sub_appbar("체험관 안내", context, star_color),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // height: 939 .h,
                  width: 1501 .w,
                  child: (() {
                    if (index % 4 == 0) {
                      return mainImage(mainimage[0], 1501.w);
                    } else if (index % 4 == 1) {
                      return mainImage(mainimage[1], 1501.w);
                    } else if (index % 4 == 2) {
                      return mainImage(mainimage[2], 1501.w);
                    } else
                      return mainImage(mainimage[3], 1501.w);
                  }()),
                ),
                Card(
                  elevation: 0.3,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 75 .w,
                        top: 45 .h,
                        bottom: 45 .h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 1250 .w,
                          child: Text(data.store_name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "NotoSansCJKkr_Bold",
                                  fontSize: 77.0 .sp),
                              textAlign: TextAlign.left),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20 .w,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          constraints: BoxConstraints(
                              maxWidth: 170 .w,
                              maxHeight: 170 .h),
                          icon: Image.asset(
                              star_color
                                  ? "./assets/listPage/star_color.png"
                                  : "./assets/listPage/star_grey.png",
                              height: 60 .h),
                          onPressed: loginOption == "login"
                              ? () {
                                  show_toast.showToast(context, "로그인해주세요!");
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
                          top: 40 / (1501 / MediaQuery.of(context).size.width),
                        )),
                        Text(
                          "주소",
                          style: TextStyle(
                              color: Color(0xff4d4d4d),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 58.0 .sp),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          top: 10 / (1501 / MediaQuery.of(context).size.width),
                        )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 1065 .w,
                              child: Text(
                                data.address == null ? "정보 없음" : data.address,
                                style: TextStyle(
                                    color: Color(0xff808080),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 57.0 .sp,
                                    height: 1.2),
                              ),
                            ),
                            GestureDetector(
                              child: Row(
                                children: [
                                  Image.asset(
                                    "./assets/sublistPage/copy.png",
                                    width: 250 .w,
                                    height: 56 .h,
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
                                //     .then((value) => print('copied'));
                                show_toast.showToast(context, "주소가 복사되었습니다");
                              },
                            )
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          top: 30 / (1501 / MediaQuery.of(context).size.width),
                        )),
                        Text(
                          "연락처",
                          style: TextStyle(
                              color: Color(0xff4d4d4d),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 58.0 .sp),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          top: 10 / (1501 / MediaQuery.of(context).size.width),
                        )),
                        Text(
                          data.phone == null ? '정보없음' : data.phone,
                          style: TextStyle(
                              color: Color(0xff808080),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 57.0 .sp,
                              height: 1.2),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          top: 75 / (1501 / MediaQuery.of(context).size.width),
                        )),
                      ],
                    ),
                  ),
                ),
                Card(
                  elevation: 0.3,
                  child: Container(
                    //  height: 300 .h,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      left: 75 / (1501 / MediaQuery.of(context).size.width),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(
                          top: 30 / (1501 / MediaQuery.of(context).size.width),
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "관람 / 체험료",
                              style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 58.0 .sp),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              top: 10 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                            Text(
                              data.fare == null ? "정보 없음" : data.fare,
                              style: TextStyle(
                                  color: Color(0xff808080),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 57.0 .sp,
                                  height: 1.2),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              top: 50 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                    elevation: 0.3,
                    child: Container(
                      //    height: 1373 .h,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left: 75 /
                                    (1501 / MediaQuery.of(context).size.width),
                                top: 40 .h,
                              ),
                              child: Text(
                                "위치",
                                style: TextStyle(
                                    color: Color(0xff4d4d4d),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 58.0 .sp),
                              ),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: 50 .h)),
                            Container(
                              height: 1100 .h,
                              child: WebView(
                                onWebViewCreated:
                                    (WebViewController webViewController) {
                                  controller = webViewController;
                                  controller.loadUrl(
                                      'http://13.209.41.43/storename?storename=$storename&address=$address');
                                  print(storename);
                                  print(address);
                                },
                                javascriptMode: JavascriptMode.unrestricted,
                              ),
                            ),
                          ]),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
