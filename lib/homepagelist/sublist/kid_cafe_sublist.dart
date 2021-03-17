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
class kid_cafe_sublist extends StatefulWidget {
  kid_cafe_sublist(
      {Key key,
      this.index,
      this.data,

      this.userId,
      this.loginOption});
  int index;
  var data;

  String loginOption;
  String userId;
  @override
  _kid_cafe_sublistState createState() => _kid_cafe_sublistState();
}

class _kid_cafe_sublistState extends State<kid_cafe_sublist> {
  WebViewController controller;

  var userId = "", loginOption = "";
  var data , storename, address;
  var star_color = false;

  var mainimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image2.png",
  ];
  @override
  void initState() {

    setState(() {
      data = widget.data;
      storename = widget.data.store_name;
      address = widget.data.address;
    userId = widget.userId;
      loginOption = widget.loginOption;
    });
    getSubStarColor();


    super.initState();
  }

  StarManage starInsertDelete = new StarManage();
  toast show_toast = new toast();
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



  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
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

    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:bar.sub_appbar("키즈카페 안내",context, star_color),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Container(
                // height: 939 / screenHeight,
                width: 1501 / screenWidth,
                child: (() {
                  if (index % 2 == 0) {
                    return mainImage(mainimage[0], screenWidth);
                  } else
                    return mainImage(mainimage[1], screenWidth);
                }()),
              ),


              Card(
                elevation: 0.3,
                child: Container(
                  padding: EdgeInsets.only(
                      left: 75 / screenWidth,
                      top: 45 / screenHeight,
                      bottom: 45 / screenHeight),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 1250 / screenWidth,
                        child: Text(data.store_name,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "NotoSansCJKkr_Bold",
                                fontSize: 77.0 / screenWidth),
                            textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20 / screenWidth,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        constraints: BoxConstraints(
                            maxWidth: 170 / screenWidth,
                            maxHeight: 170 / screenHeight),
                        icon: Image.asset(
                            star_color
                                ? "./assets/listPage/star_color.png"
                                : "./assets/listPage/star_grey.png",
                            height: 60 / screenHeight),
                        onPressed: loginOption == "login"
                            ? () {
                          show_toast.showToast(context,"로그인해주세요!");
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
                  //  height: 520 / screenHeight,
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
                            fontSize: 58.0 / screenWidth),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 10 / (1501 / MediaQuery.of(context).size.width),
                      )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 1065 / (screenWidth),
                            child: Text(
                              data.address == null ? "정보 없음" : data.address,
                              style: TextStyle(
                                  color: Color(0xff808080),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 57.0 / screenWidth,
                                  height: 1.2),
                            ),
                          ),
                          GestureDetector(
                            child: Row(
                              children: [
                                Image.asset(
                                  "./assets/sublistPage/copy.png",
                                  width: 250 / (screenWidth),
                                  height: 56 / (screenHeight),
                                ),
                                // Text(
                                //   "주소복사",
                                //   style: TextStyle(
                                //       color: Color(0xffff7292),
                                //       fontFamily: "NotoSansCJKkr_Medium",
                                //       fontSize: 48.0 / screenWidth),
                                // ),
                              ],
                            ),
                            onTap: () {
                              FlutterClipboard.copy(data.address);
                              show_toast.showToast(context,"주소가 복사되었습니다");
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
                            fontSize: 58.0 / screenWidth),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 10 / (1501 / MediaQuery.of(context).size.width),
                      )),
                      Text(
                        data.phone,
                        style: TextStyle(
                            color: Color(0xff808080),
                            fontFamily: "NotoSansCJKkr_Medium",
                            fontSize: 57.0 / screenWidth,
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
                  //  height: 300 / screenHeight,
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
                                fontSize: 58.0 / screenWidth),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                10 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(data.fare == null ? "정보 없음" : data.fare,
                              style: TextStyle(
                                  color: Color(0xff808080),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 57.0 / screenWidth,
                                  height: 1.2)),
                          Padding(
                              padding: EdgeInsets.only(
                            top:
                                50 / (1501 / MediaQuery.of(context).size.width),
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
                    // height: 1373 / screenHeight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 75 /
                                  (1501 / MediaQuery.of(context).size.width),
                              top: 40 / screenHeight,
                            ),
                            child: Text(
                              "위치",
                              style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 58.0 / screenWidth),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 50 / screenHeight)),
                          Container(
                            height: 1100 / screenHeight,
                            child: WebView(
                              onWebViewCreated:
                                  (WebViewController webViewController) {
                                controller = webViewController;
                                controller.loadUrl(
                                    'http://13.209.41.43/storename?storename=$storename&address=$address');

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
    );
  }
}
