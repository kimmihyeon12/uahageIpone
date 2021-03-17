import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uahage/screens/allAppBar.dart';
class experience_center_sublist extends StatefulWidget {
  experience_center_sublist(
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
  _experience_center_sublistState createState() =>
      _experience_center_sublistState();
}

class _experience_center_sublistState extends State<experience_center_sublist> {
  WebViewController controller;
  FToast fToast;
  var userId = "", loginOption = "";
  var data , storename, address;
  var star_color = false;

  var mainimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_experience_sublist/image4.png",
  ];
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    setState(() {
      data = widget.data;
      storename = widget.data.store_name;
      address = widget.data.address;
      userId = widget.userId;
      loginOption = widget.loginOption;
    });
    print(storename);
    // _star_color();
    checkStar();
    super.initState();
  }

  Future checkStar() async {
    print("start checking");
    var response;
    try {
      response = await http.get(
          "http://13.209.41.43/getStarColor?userId=$userId$loginOption&storeName=$storename");
      print(response.statusCode);
      if (response.statusCode == 200) {
        setState(() {
          star_color = true;
        });
      } else {
        setState(() {
          star_color = false;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  _showToast(screenWidth) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black45,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "주소가 복사되었어요",
            style: TextStyle(
              fontSize: 45 / screenWidth,
              fontFamily: 'NotoSansCJKkr_Medium',
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 1),
    );
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
        appBar:bar.sub_appbar("체험관 안내",context),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


              Container(
                // height: 939 / screenHeight,
                width: 1501 / screenWidth,
                child: (() {
                  if (index % 4 == 0) {
                    return mainImage(mainimage[0], screenWidth);
                  } else if (index % 4 == 1) {
                    return mainImage(mainimage[1], screenWidth);
                  } else if (index % 4 == 2) {
                    return mainImage(mainimage[2], screenWidth);
                  } else
                    return mainImage(mainimage[3], screenWidth);
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
                        onPressed: () async {},
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
                              //     .then((value) => print('copied'));
                              // _showToast(screenWidth);
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
                        data.phone == null ? '정보없음' : data.phone,
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
                          Text(
                            data.fare == null ? "정보 없음" : data.fare,
                            style: TextStyle(
                                color: Color(0xff808080),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 57.0 / screenWidth,
                                height: 1.2),
                          ),
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
                    //    height: 1373 / screenHeight,
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
    );
  }
}
