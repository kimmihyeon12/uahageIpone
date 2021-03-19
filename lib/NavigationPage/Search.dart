import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/NavigationPage/Bottom.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/restaurant_sublist.dart';
import 'package:uahage/ToastManage.dart';
import 'package:uahage/Location.dart';
import 'package:uahage/StarManage.dart';
import 'package:uahage/icon.dart';
import 'dart:convert';

class searchPage extends StatefulWidget {
  searchPage(
      {Key key,
      this.latitude,
      this.longitude,
      this.userId,
      this.loginOption,
      this.Area,
      this.Locality})
      : super(key: key);
  String latitude;
  String longitude;
  String loginOption;
  String userId;
  String Locality;
  String Area;
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {
  // getting current location
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  String searchKey = "";
  var star_color = false;
  String userId = "";
  String loginOption = "";
  int index = 1;
  var Message;

  toast show_toast = new toast();
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

  Location location = new Location();

  Future lacations() async {
    await location.getCurrentLocation();
  }

  getLatLong() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String lat = sharedPreferences.getString("uahageLat") ?? "";
    String long = sharedPreferences.getString("uahageLong") ?? "";
    String area = sharedPreferences.getString("uahageArea") ?? "";
    String locality = sharedPreferences.getString("uahageLocality") ?? "";
    print("search lat: $lat");
    if (lat == "" || long == "") {
      await lacations();
    } else
      setState(() {
        latitude = lat;
        longitude = long;
        Area = area;
        Locality = locality;
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
        "http://13.209.41.43/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}&Area=$Area&Locality=$Locality");
  }

  StarManage starInsertDelete = new StarManage();
  Future click_star() async {
    await starInsertDelete.click_star(
        userId + loginOption,
        Message[0],
        Message[1],
        Message[2],
        Message[3],
        Message[4],
        Message[5],
        Message[6],
        Message[7],
        Message[8],
        Message[9],
        Message[10],
        Message[11],
        null,
        null,
        star_color,
        "restaurant");
  }

  Future getSubStarColor() async {
    star_color =
        await starInsertDelete.getSubStarColor(userId, loginOption, Message[0]);
    setState(() {
      star_color = star_color;
    });
  }

  // WebViewController _controller;
  WebViewController controller;
  icon iconwidget = new icon();
  @override
  void initState() {
    setState(() {
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      latitude = widget.latitude ?? "";
      longitude = widget.longitude ?? "";
      Area = widget.Area ?? "";
      Locality = widget.Locality ?? "";
    });
    if (latitude == "" || longitude == "" || Locality == "" || Area == "")
      getLatLong();
    super.initState();
    // getCurrentLocation();
    print("latitude: $latitude");
    print("longitude: $longitude");
  }

  @override
  void didChangeDependencies() {
    getLatLong();
    super.didChangeDependencies();
  }

  int position = 1;
  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
    // setState(() {
    //   isLoading = false;
    // });
    // print("isloading: $isLoading");
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
  var isLoading = true;

  @override
  Widget build(BuildContext context) {
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          WebView(
            key: key,
            onPageFinished: doneLoading,
            onPageStarted: startLoading,
            // initialUrl: 'http://13.209.41.43/map',
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
                  onMessageReceived: (JavascriptMessage message) async {
                    var messages = message.message;
                    Message = messages.split("|");
                    await getSubStarColor();
                    print("star_color: $star_color");
                    print("Message: $Message");
                    showPopUpbottomMenu(context, screenHeight, screenWidth);
                  })
            ]),
          ),
          position == 1
              ? Center(
                  child: Container(
                    color: Colors.white,
                    child:
                        Center(child: buildSpinKitThreeBounce(80, screenWidth)),
                  ),
                )
              : SizedBox.shrink(),

          GestureDetector(
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
              await showPopUpMenu(context, screenHeight, screenWidth);
            },
            child: Container(
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
              margin: EdgeInsets.fromLTRB(
                  51 / screenWidth, 161 / screenHeight, 51 / screenWidth, 0),
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
          ),

          // bottom Buttons
          // Row(
          //   children: [
          //     Align(
          //       alignment: Alignment.bottomLeft,
          //       child: InkWell(
          //         onTap: () async {
          //           //var response = await getMap(latitude, longitude);
          //           if (latitude == 'NaN' ||
          //               longitude == 'NaN' ||
          //               latitude == '' ||
          //               longitude == '') await lacations();
          //           // controller.loadUrl(
          //           //     'http://13.209.41.43/getPos?lat=$latitude&long=$longitude');
          //           controller.loadUrl(
          //               "http://13.209.41.43/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}&Area=$Area&Locality=$Locality");
          //         },
          //         child: Container(
          //           margin: EdgeInsets.only(
          //               left: 48 / screenWidth, bottom: 76 / screenHeight),
          //           child: SizedBox(
          //             height: 159 / screenHeight,
          //             width: 161 / screenWidth,
          //             child: Image.asset("assets/searchPage/location.png"),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
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
                      margin: EdgeInsets.only(
                          top: 600 / (screenHeight),
                          bottom: 0 / screenHeight,
                          left: 190 / screenWidth,
                          right: 0 / screenWidth),
                      width: 1100 / screenWidth,
                      height: 1100 / screenHeight,
                      child: Card(
                        shadowColor: Colors.black54,
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 110 / (screenHeight),
                              left: 50 / screenWidth,
                              right: 50 / screenWidth),
                          child: SizedBox(
                            //       width: 888 / screenWidth,
                            //     height: 800 / screenHeight,
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
                  GestureDetector(
                    onPanDown: (a) {
                      print('aha');
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 1874 / (screenHeight),
                    ),
                  ),
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
                        onTap: () async {
                          final btm = BottomButton(
                              storeName: Message[0],
                              address1: Message[1],
                              phone1: Message[2],
                              menu1: Message[3],
                              bed1: Message[4],
                              tableware1: Message[5],
                              meetingroom1: Message[6],
                              diapers1: Message[7],
                              playroom1: Message[8],
                              carriage1: Message[9],
                              nursingroom1: Message[10],
                              chair1: Message[11],
                              Examination_item1: Message[12],
                              fare1: Message[13]);
                          // print(Message);
                          // print(toMap);
                          print(btm);
                          print(btm.carriage);
                          print(btm.store_name);

                          final result = await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: restaurant_sublist(
                                  index: index++,
                                  data: btm,
                                  userId: userId,
                                  loginOption: loginOption,
                                ),
                                duration: Duration(milliseconds: 100),
                                reverseDuration: Duration(milliseconds: 100),
                              ));
                          result
                              ? setState(() {
                                  star_color = true;
                                })
                              : setState(() {
                                  star_color = false;
                                });
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
                                        child: Text(
                                            Message[0].length <= 10
                                                ? Message[0]
                                                : Message[0].substring(0, 11),
                                            style: TextStyle(
                                              color: const Color(0xff010000),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "NotoSansCJKkr_Bold",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 58 / screenWidth,
                                              height: 1.2,
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
                                                show_toast.showToast(
                                                    context, "로그인해주세요!");
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
                                      EdgeInsets.only(top: 10 / screenHeight),
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
                                  margin:
                                      EdgeInsets.only(top: 10 / screenHeight),
                                  height: 120 / screenHeight,
                                  width: 650 / screenWidth,
                                  alignment: Alignment.bottomRight,
                                  child: Row(children: [
                                    iconwidget.menu(Message[3], context),
                                    iconwidget.bed(Message[4], context),
                                    iconwidget.tableware(Message[5], context),
                                    iconwidget.meetingroom(Message[6], context),
                                    iconwidget.diapers(Message[7], context),
                                    iconwidget.playroom(Message[8], context),
                                    iconwidget.carriage(Message[9], context),
                                    iconwidget.nursingroom(
                                        Message[10], context),
                                    iconwidget.chair(Message[11], context),
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
}
