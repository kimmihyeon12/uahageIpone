import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/restaurant_sublist.dart';
import 'package:fluttertoast/fluttertoast.dart';

class searchPage extends StatefulWidget {
  searchPage(
      {Key key, this.latitude, this.longitude, this.userId, this.loginOption})
      : super(key: key);
  String latitude;
  String longitude;
  String loginOption;
  String userId;
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  // getting current location
  String latitude = "";
  String longitude = "";
  String searchKey = "";
  var star_color = false;
  String userId = "";
  String loginOption = "";
  int index = 1;
  var Message;

  List<String> star_color_list = List(2);
  List<bool> grey_image = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true
  ];
  var iconimage = [
    "./assets/listPage/menu.png",
    "./assets/listPage/bed.png",
    "./assets/listPage/tableware.png",
    "./assets/listPage/meetingroom.png",
    "./assets/listPage/diapers.png",
    "./assets/listPage/playroom.png",
    "./assets/listPage/carriage.png",
    "./assets/listPage/nursingroom.png",
    "./assets/listPage/chair.png",
  ];

  //
  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = geoposition.latitude.toString();
      longitude = geoposition.longitude.toString();
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
    });
  }

  searchAddress(searchKey) async {
    // ignore: unnecessary_statements
    print(searchKey);
    searchKey != ""
        ? controller
            .loadUrl('http://13.209.41.43/getAddress?address=$searchKey')
        : null;
  }

  Future searchCategory() async {
    print(grey_image);
    controller.loadUrl(
        "http://13.209.41.43/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}");
  }

  Future click_star() async {
    //  print("clicking start $star_color");
    Map<String, dynamic> ss = {
      "user_id": userId + loginOption,
      "store_name": Message[0],
      "address": Message[1],
      "phone": Message[2],
      "menu": Message[3],
      "bed": Message[4],
      "tableware": Message[5],
      "meetingroom": Message[6],
      "diapers": Message[7],
      "playroom": Message[8],
      "carriage": Message[9],
      "nursingroom": Message[10],
      "chair": Message[11],
      "star_color": star_color,
      "Examination_item": null,
      "fare": null,
      "type": "restaurant"
    };
    print(ss);
    var response = await http.post(
      "http://13.209.41.43/star",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
  }

  Future checkStar() async {
    print("start checking");
    var response;
    try {
      response = await http.get(
          "http://13.209.41.43/getStarColor?userId=$userId$loginOption&storeName=${Message[0]}");
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

  // WebViewController _controller;
  WebViewController controller;

  @override
  void initState() {
    super.initState();
    if (widget.latitude == 'NaN' ||
        widget.longitude == 'NaN' ||
        widget.latitude == '' ||
        widget.longitude == '') {
      getCurrentLocation();
    } else
      setState(() {
        latitude = widget.latitude;
        longitude = widget.longitude;
        loginOption = widget.loginOption;
        userId = widget.userId ?? "";
      });
    // getCurrentLocation();
  }

  int position = 1;
  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  bool isIOS = Platform.isIOS;

  @override
  Widget build(BuildContext context) {
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;
    // isIOS
    //     ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
    //         .copyWith(
    //             statusBarBrightness:
    //                 Brightness.dark // Dark == white status bar -- for IOS.
    //             ))
    //     : null;
    return Scaffold(
      body: isIOS
          ? AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.dark,
              child: Stack(
                children: [
                  IndexedStack(
                    index: position,
                    children: [
                      WebView(
                        key: key,
                        onPageFinished: doneLoading,
                        onPageStarted: startLoading,
                        onWebViewCreated:
                            (WebViewController webViewController) {
                          controller = webViewController;
                          controller.loadUrl(latitude == 'NaN' ||
                                  longitude == 'NaN' ||
                                  latitude == '' ||
                                  longitude == ''
                              ? 'http://13.209.41.43/map'
                              : 'http://13.209.41.43/getPos?lat=$latitude&long=$longitude');
                        },
                        javascriptMode: JavascriptMode.unrestricted,
                        javascriptChannels: Set.from([
                          JavascriptChannel(
                              name: 'Print',
                              onMessageReceived:
                                  (JavascriptMessage message) async {
                                //This is where you receive message from
                                //javascript code and handle in Flutter/Dart
                                //like here, the message is just being printed
                                //in Run/LogCat window of android studio
                                var messages = message.message;
                                Message = messages.split(",");
                                await checkStar();
                                // await checkStar();
                                showPopUpbottomMenu(
                                    context, screenHeight, screenWidth);
                              })
                        ]),
                      ),
                      Container(
                        color: Colors.white,
                        child: Center(
                            child: buildSpinKitThreeBounce(80, screenWidth)),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    margin: EdgeInsets.fromLTRB(51 / screenWidth,
                        161 / screenHeight, 35 / screenWidth, 0),
                    height: 196 / screenHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 42 / screenWidth),
                          child: Image.asset(
                            "./assets/searchPage/arrow.png",
                            height: 68 / screenHeight,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 53 / screenWidth),
                          child: Image.asset(
                            "./assets/searchPage/arrow.png",
                            height: 68 / screenHeight,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 41 / screenWidth),
                          width: 1200 / screenWidth,
                          child: // 검색 조건을 설정해주세요
                              Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("검색 조건을 설정해주세요",
                                  style: TextStyle(
                                      color: const Color(0xffed7191),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 58 / screenWidth),
                                  textAlign: TextAlign.left),
                              InkWell(
                                onTap: () async {
                                  setState(() {
                                    grey_image = [
                                      true,
                                      true,
                                      true,
                                      true,
                                      true,
                                      true,
                                      true,
                                      true,
                                      true,
                                    ];
                                  });
                                  await showPopUpMenu(
                                      context, screenHeight, screenWidth);
                                },
                                child: Image.asset(
                                  "./assets/searchPage/cat_btn.png",
                                  height: 158 / screenHeight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // bottom Buttons
                  Row(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: InkWell(
                          onTap: () async {
                            //var response = await getMap(latitude, longitude);
                            if (latitude == 'NaN' ||
                                longitude == 'NaN' ||
                                latitude == '' ||
                                longitude == '') await getCurrentLocation();
                            controller.loadUrl(
                                "http://13.209.41.43/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}"
                                // "http://13.209.41.43/getPos?lat=$latitude&long=$longitude"
                                );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 48 / screenWidth,
                                bottom: 76 / screenHeight),
                            child: SizedBox(
                              height: 159 / screenHeight,
                              width: 161 / screenWidth,
                              child:
                                  Image.asset("assets/searchPage/location.png"),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(
                              1060 / screenWidth, 0, 0, 47 / screenHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              /* IconButton(
                              onPressed: () {
                                controller.loadUrl(
                                    "http://13.209.41.43/zoomIn?lat=$latitude&long=$longitude");
                              },
                              icon: Image.asset(
                                "assets/searchPage/plus.png",
                                width: 105 / screenWidth,
                                height: 105 / screenHeight,
                              )),
                          IconButton(
                              onPressed: () {
                                controller.loadUrl(
                                    "http://13.209.41.43/zoomOut?lat=$latitude&long=$longitude");
                              },
                              icon: Image.asset(
                                "assets/searchPage/minus.png",
                                width: 105 / screenWidth,
                                height: 105 / screenHeight,
                              )),*/
                            ],
                          ),
                        ),
                      )
                      //
                    ],
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                IndexedStack(
                  index: position,
                  children: [
                    WebView(
                      key: key,
                      onPageFinished: doneLoading,
                      onPageStarted: startLoading,
                      onWebViewCreated: (WebViewController webViewController) {
                        controller = webViewController;
                        controller.loadUrl(latitude == 'NaN' ||
                                longitude == 'NaN' ||
                                latitude == '' ||
                                longitude == ''
                            ? 'http://13.209.41.43/map'
                            : 'http://13.209.41.43/getPos?lat=$latitude&long=$longitude');
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      javascriptChannels: Set.from([
                        JavascriptChannel(
                            name: 'Print',
                            onMessageReceived:
                                (JavascriptMessage message) async {
                              //This is where you receive message from
                              //javascript code and handle in Flutter/Dart
                              //like here, the message is just being printed
                              //in Run/LogCat window of android studio
                              var messages = message.message;
                              Message = messages.split(",");
                              await checkStar();
                              showPopUpbottomMenu(
                                  context, screenHeight, screenWidth);
                            })
                      ]),
                    ),
                    Container(
                      color: Colors.white,
                      child: Center(
                          child: buildSpinKitThreeBounce(80, screenWidth)),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.fromLTRB(51 / screenWidth,
                      161 / screenHeight, 51 / screenWidth, 0),
                  height: 196 / screenHeight,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 53 / screenWidth),
                        child: Image.asset(
                          "./assets/searchPage/arrow.png",
                          height: 68 / screenHeight,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 41 / screenWidth),
                        width: 1200 / screenWidth,
                        child: // 검색 조건을 설정해주세요
                            Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("검색 조건을 설정해주세요",
                                style: TextStyle(
                                    color: const Color(0xffed7191),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 58 / screenWidth),
                                textAlign: TextAlign.left),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  grey_image = [
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                    true,
                                  ];
                                });
                                await showPopUpMenu(
                                    context, screenHeight, screenWidth);
                              },
                              child: Image.asset(
                                "./assets/searchPage/cat_btn.png",
                                height: 158 / screenHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // bottom Buttons
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: InkWell(
                        onTap: () async {
                          //var response = await getMap(latitude, longitude);
                          if (latitude == 'NaN' ||
                              longitude == 'NaN' ||
                              latitude == '' ||
                              longitude == '') await getCurrentLocation();
                          controller.loadUrl(
                              "http://13.209.41.43/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}"
                              // "http://13.209.41.43/getPos?lat=$latitude&long=$longitude"
                              );
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 48 / screenWidth,
                              bottom: 76 / screenHeight),
                          child: SizedBox(
                            height: 159 / screenHeight,
                            width: 161 / screenWidth,
                            child:
                                Image.asset("assets/searchPage/location.png"),
                          ),
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.bottomRight,
                    //   child: Container(
                    //     margin: EdgeInsets.fromLTRB(
                    //         1060 / screenWidth, 0, 0, 47 / screenHeight),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       // crossAxisAlignment: CrossAxisAlignment.end,
                    //       children: [
                    //         /* IconButton(
                    //     onPressed: () {
                    //       controller.loadUrl(
                    //           "http://13.209.41.43/zoomIn?lat=$latitude&long=$longitude");
                    //     },
                    //     icon: Image.asset(
                    //       "assets/searchPage/plus.png",
                    //       width: 105 / screenWidth,
                    //       height: 105 / screenHeight,
                    //     )),
                    // IconButton(
                    //     onPressed: () {
                    //       controller.loadUrl(
                    //           "http://13.209.41.43/zoomOut?lat=$latitude&long=$longitude");
                    //     },
                    //     icon: Image.asset(
                    //       "assets/searchPage/minus.png",
                    //       width: 105 / screenWidth,
                    //       height: 105 / screenHeight,
                    //     )),*/
                    //       ],
                    //     ),
                    //   ),
                    // )
                    //
                  ],
                ),
              ],
            ),
    );
  }

  Future<Object> showPopUpMenu(
      BuildContext context, double screenHeight, double screenWidth) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return SafeArea(
              child: Builder(builder: (context) {
                return Stack(
                  children: [
                    Container(
                      height: 2300 / screenHeight,
                      child: Center(
                        child: Image.asset(
                          "./assets/searchPage/popUp.png",
                          height: 1176 / screenHeight,
                          width: 1067 / screenHeight,
                        ),
                      ),
                    ),
                    Container(
                      height: 2300 / screenHeight,
                      child: Center(
                        child: Container(
                          height: 1176 / screenHeight,
                          child: Center(
                            child: Positioned(
                              child: SizedBox(
                                width: 1000 / screenWidth,
                                height: 1000 / screenHeight,
                                child: GridView.count(
                                  // childAspectRatio: 3 / 2,
                                  crossAxisCount: 3,
                                  children: List.generate(9, (index) {
                                    return Scaffold(
                                      backgroundColor: Colors.white,
                                      body: Center(
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              grey_image[index] =
                                                  !grey_image[index];
                                            });
                                            print(grey_image);
                                          },
                                          child: grey_image[index]
                                              ? Image.asset(
                                                  "./assets/searchPage/image" +
                                                      (index + 1).toString() +
                                                      "_grey.png",
                                                  height: 293 / screenHeight,
                                                  width: 218 / screenWidth,
                                                )
                                              : Image.asset(
                                                  "./assets/searchPage/image" +
                                                      (index + 1).toString() +
                                                      ".png",
                                                  height: 293 / screenHeight,
                                                  width: 218 / screenWidth,
                                                ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1850 / screenHeight,
                      left: 400 / screenWidth,
                      right: 400 / screenWidth,
                      child: SizedBox(
                        width: 611 / screenWidth,
                        height: 195 / screenHeight,
                        child: FlatButton(
                          onPressed: () async {
                            await searchCategory();

                            Navigator.of(context).pop();
                            // print(isBirthdayFree);
                          },
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          color: Color.fromRGBO(255, 114, 148, 1.0),
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'NotoSansCJKkr_Medium',
                              fontSize: 62 / screenWidth,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            );
          });
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150));
  }

  Future<Object> showPopUpbottomMenu(
      BuildContext context, double screenHeight, double screenWidth) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return Builder(builder: (context) {
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: 1874 / (screenHeight),
                        bottom: 263 / screenHeight,
                        left: 33 / screenWidth,
                        right: 33 / screenWidth),
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shadowColor: Colors.black54,
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: restaurant_sublist(
                                  index: index++,
                                  storename: Message[0],
                                  address: Message[1],
                                  phone: Message[2],
                                  menu: Message[3],
                                  bed: Message[4],
                                  tableware: Message[5],
                                  meetingroom: Message[6],
                                  diapers: Message[7],
                                  playroom: Message[8],
                                  carriage: Message[9],
                                  nursingroom: Message[10],
                                  chair: Message[11],
                                  userId: userId,
                                  loginOption: loginOption,
                                ),
                                duration: Duration(milliseconds: 100),
                                reverseDuration: Duration(milliseconds: 100),
                              ));
                        },
                        child: Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                              left: 30 / screenWidth,
                            )),
                            Image.asset(
                              "./assets/listPage/clipGroup1.png",
                              height: 409 / screenHeight,
                              width: 413 / screenWidth,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              left: 53 / screenWidth,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 60 / screenHeight),
                                  width: 880 / screenWidth,
                                  height: 82 / screenHeight,
                                  child: Row(
                                    //  crossAxisAlignment: CrossAxisAlignment.center,
                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 680 / screenWidth,
                                        child: Text(Message[0],
                                            style: TextStyle(
                                              color: const Color(0xff010000),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "NotoSansCJKkr_Bold",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 58 / screenWidth,
                                              // height: 1.0,
                                            ),
                                            textAlign: TextAlign.left),
                                      ),
                                      IconButton(
                                        //  iconSize: 60 / screenHeight,
                                        padding: EdgeInsets.all(0),
                                        icon: Image.asset(
                                            star_color
                                                ? "./assets/listPage/star_color.png"
                                                : "./assets/listPage/star_grey.png",
                                            height: 60 / screenHeight),
                                        onPressed: loginOption == "login"
                                            ? () {
                                                Fluttertoast.showToast(
                                                  msg: "  로그인 해주세요!  ",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Colors.black45,
                                                  textColor: Colors.white,
                                                  fontSize: 56 / screenWidth,
                                                );
                                              }
                                            : () async {
                                                setState(() {
                                                  star_color = !star_color;
                                                });

                                                loginOption != "login"
                                                    ? await click_star()
                                                    : null;
                                              },
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 35 / screenHeight),
                                  width: 650 / screenWidth,
                                  height: 138 / screenHeight,
                                  child: Text(Message[1],
                                      style: TextStyle(
                                        color: const Color(0xffb0b0b0),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 55 / screenWidth,
                                        height: 1.2,
                                      ),
                                      textAlign: TextAlign.left),
                                ),
                                Container(
                                  height: 120 / screenHeight,
                                  width: 650 / screenWidth,
                                  alignment: Alignment.bottomRight,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        menu(Message[3]),
                                        bed(Message[4]),
                                        tableware(Message[5]),
                                        meetingroom(Message[6]),
                                        diapers(Message[7]),
                                        playroom(Message[8]),
                                        carriage(Message[9]),
                                        nursingroom(Message[10]),
                                        chair(Message[11]),
                                      ]),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
          });
        },
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: null,
        transitionDuration: const Duration(milliseconds: 150));
  }

  menu(String menu) {
    var menus = menu.toString();

    return menus == "○"
        ? Container(
            child: Image.asset(iconimage[0], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[0], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  bed(String bed) {
    var beds = bed.toString();

    return beds == "○"
        ? Container(
            child: Image.asset(iconimage[1], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[1], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  tableware(String tableware) {
    var tablewares = tableware.toString();

    return tablewares == "○"
        ? Container(
            child: Image.asset(iconimage[2], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[2], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  meetingroom(String meetingroom) {
    var meetingrooms = meetingroom.toString();

    return meetingrooms == "○"
        ? Container(
            child: Image.asset(iconimage[3], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[3], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  diapers(String diapers) {
    var diaperss = diapers.toString();

    return diaperss == "○"
        ? Container(
            child: Image.asset(iconimage[4], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[4], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  playroom(String playroom) {
    var playrooms = playroom.toString();

    return playrooms == "○"
        ? Container(
            child: Image.asset(iconimage[5], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[5], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  carriage(String carriage) {
    var carriages = carriage.toString();

    return carriages == "○"
        ? Container(
            child: Image.asset(iconimage[6], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[6], width: 0, height: 0),
          );
  }

  nursingroom(String nursingroom) {
    var nursingrooms = nursingroom.toString();

    return nursingrooms == "○"
        ? Container(
            child: Image.asset(iconimage[7], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[7], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  chair(String chair) {
    var chairs = chair.toString();

    return chairs == "○"
        ? Container(
            child: Image.asset(iconimage[8], width: 30, height: 30),
            padding: EdgeInsets.only(
                right: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[8], width: 0, height: 0),
            padding: EdgeInsets.only(
                right: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }
}
