import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class kid_cafe_sublist extends StatefulWidget {
  kid_cafe_sublist(
      {Key key,
      this.index,
      this.storename,
      this.address,
      this.phone,
      this.fare,
      this.userId,
      this.loginOption});
  int index;
  String storename;
  String address;
  String phone;
  String fare;
  String loginOption;
  String userId;
  @override
  _kid_cafe_sublistState createState() => _kid_cafe_sublistState();
}

class _kid_cafe_sublistState extends State<kid_cafe_sublist> {
  WebViewController controller;
  FToast fToast;
  var userId = "", loginOption = "";
  var storename, address, phone, fare;
  var star_color = false;

  var mainimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image2.png",
  ];
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    setState(() {
      storename = widget.storename;
      address = widget.address;
      phone = widget.phone;
      fare = widget.fare;
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
    var storename = widget.storename;
    var address = widget.address;
    var phone = widget.phone;
    var fare = widget.fare;

    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(180 / screenHeight),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, centerTitle: true,
            // iconTheme: IconThemeData(
            //   color: Color(0xffff7292), //change your color here
            // ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              "키즈카페 안내",
              style: TextStyle(
                  color: Color(0xffff7292),
                  fontFamily: "NotoSansCJKkr_Medium",
                  fontSize: 62.0 / screenWidth),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //bar
              // Container(
              //   height: 178 / screenHeight,
              //   width: 1501 / screenWidth,
              //   color: Colors.white,
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Stack(children: [
              //         Center(
              //           child: IconButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             icon: Image.asset(
              //               "./assets/listPage/backbutton.png",
              //               width: 44 / (screenWidth),
              //               height: 76 / (screenHeight),
              //             ),
              //           ),
              //         ),
              //         Container(
              //           height: 178 / screenHeight,
              //           width: 1501 / screenWidth,
              //           child: Center(
              //               child: // 약관동의
              //                   Text(
              //             "키즈카페 안내",
              //             style: TextStyle(
              //                 color: Color(0xffff7292),
              //                 fontFamily: "NotoSansCJKkr_Medium",
              //                 fontSize: 62.0 / screenWidth),
              //           )),
              //         ),
              //       ]),
              //     ],
              //   ),
              // ),

              Container(
                height: 939 / screenHeight,
                width: 1501 / screenWidth,
                child: (() {
                  if (index % 2 == 0) {
                    return mainImage(mainimage[0], screenWidth);
                  } else
                    return mainImage(mainimage[1], screenWidth);
                }()),
              ),
              // index % 2 == 0
              //     ? Image.asset(
              //         mainimage[0],
              //         width: MediaQuery.of(context).size.width,
              //       )
              //     : index % 2 == 1
              //         ? Image.asset(
              //             mainimage[1],
              //             width: MediaQuery.of(context).size.width,
              //           )
              //         : Image.asset(
              //             mainimage[1],
              //             width: MediaQuery.of(context).size.width,
              //           ),

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
                        child: Text(storename,
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
                              address == null ? "정보 없음" : address,
                              style: TextStyle(
                                  color: Color(0xff808080),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 57.0 / screenWidth,
                                  height: 1.2),
                            ),
                          ),
                          InkWell(
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
                              FlutterClipboard.copy(address);
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
                        phone,
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
                          Text(fare == null ? "정보 없음" : fare,
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
