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
class restaurant_sublist extends StatefulWidget {
  restaurant_sublist(
      {Key key,
      this.index,
      this.data,
      this.userId,
      this.loginOption})
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
  FToast fToast;
  var userId = "", loginOption = "";
  var data , storename, address;
  // List<String> star_color_list = List(10);
  var star_color = false;

  // Future _star_color() async {
  //   var data = await http.get(
  //       'http://13.209.41.43/substarcolor?user_id=$userId$loginOption&storename=$storename');
  //   var dec = jsonDecode(data.body);
  //   print(dec.length);
  //   setState(() {
  //     if (dec.length == 0) {
  //       star_color_list[0] = 'null';
  //     } else {
  //       star_color_list[0] = dec[0]["store_name"].toString();
  //     }
  //   });
  // }
  // Future checkStar() async {
  //   print("start checking");
  //   var response;
  //   try {
  //     response = await http.get(
  //         "http://13.209.41.43/getStarColor?userId=$userId$loginOption&storeName=$storename");
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         star_color = true;
  //       });
  //     } else {
  //       setState(() {
  //         star_color = false;
  //       });
  //     }
  //   } catch (err) {
  //     print(err);
  //   }
  // }
  //
  // Future click_star() async {
  //   Map<String, dynamic> ss = {
  //     "user_id": userId + loginOption,
  //     "store_name": storename,
  //     "address": address,
  //     "phone": phone,
  //     "menu": menu,
  //     "bed": bed,
  //     "tableware": tableware,
  //     "meetingroom": meetingroom,
  //     "diapers": diapers,
  //     "playroom": playroom,
  //     "carriage": carriage,
  //     "nursingroom": nursingroom,
  //     "chair": chair,
  //     "star_color": star_color,
  //     "type": "restaurant"
  //   };
  //   var response = await http.post(
  //     "http://13.209.41.43/star",
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(ss),
  //   );
  // }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    data = widget.data;
    storename = widget.data.store_name;
    address = widget.data.address;
    userId = widget.userId;
    loginOption = widget.loginOption;


    // _star_color();
    //checkStar();

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

  _showToast(double screenWidth) {
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
    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: bar.sub_appbar("매장안내",context),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Container(
                width: 1501 / screenWidth,
                child: (() {
                  if (index % 3 == 1) {
                    return mainImage(mainimage[0], screenWidth);
                  } else if (index % 3 == 2) {
                    return mainImage(mainimage[1], screenWidth);
                  } else
                    return mainImage(mainimage[2], screenWidth);
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
                  height: 928 / screenHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          left: 75 / screenWidth,
                          top: 50 / screenHeight,
                        ),
                        child: Text(
                          "편의시설",
                          style: TextStyle(
                              color: Color(0xff4d4d4d),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 58.0 / screenWidth,
                              height: 1.2),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 50 / screenHeight)),
                      Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 67 / screenWidth)),
                            data.menu == "○"
                                ? Image.asset(
                                    imagecolor[0],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  )
                                : Image.asset(
                                    imagegrey[0],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  ),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 59 / screenWidth)),
                            data.bed == "○"
                                ? Image.asset(
                                    imagecolor[1],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  )
                                : Image.asset(
                                    imagegrey[1],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  ),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 59 / screenWidth)),
                            data.tableware == "○"
                                ? Image.asset(
                                    imagecolor[2],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  )
                                : Image.asset(
                                    imagegrey[2],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  ),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 59 / screenWidth)),
                            data.meetingroom == "○"
                                ? Image.asset(
                                    imagecolor[3],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  )
                                : Image.asset(
                                    imagegrey[3],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
                                  ),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 59 / screenWidth)),
                            data.diapers == "○"
                                ? Image.asset(
                                    imagecolor[4],
                                    width: 231 / (screenWidth),
                                    height: 284 / (screenHeight),
                                  )
                                : Image.asset(
                                    imagegrey[4],
                                    width: 231 / (screenWidth),
                                    height: 284 / (screenHeight),
                                  ),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 59 / screenWidth)),
                          ]),
                      Padding(padding: EdgeInsets.only(top: 50 / screenHeight)),
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(left: 67 / screenWidth)),
                          data.playroom == "○"
                              ? Image.asset(
                                  imagecolor[5],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
                                )
                              : Image.asset(
                                  imagegrey[5],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
                                ),
                          Padding(
                              padding: EdgeInsets.only(left: 59 / screenWidth)),
                          data.carriage == "○"
                              ? Image.asset(
                                  imagecolor[6],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
                                )
                              : Image.asset(
                                  imagegrey[6],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
                                ),
                          Padding(
                              padding: EdgeInsets.only(left: 59 / screenWidth)),
                          data.nursingroom == "○"
                              ? Image.asset(
                                  imagecolor[7],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
                                )
                              : Image.asset(
                                  imagegrey[7],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
                                ),
                          Padding(
                          padding: EdgeInsets.only(left: 59 / screenWidth)),
                          data    .chair == "○"
                              ? Image.asset(
                                  imagecolor[8],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
                                )
                              : Image.asset(
                                  imagegrey[8],
                                  width: 218 / (screenWidth),
                                  height: 292 / (screenHeight),
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
                    //  height: 1300 / screenHeight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 75 / screenWidth,
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
                              // gestureNavigationEnabled: true,
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
