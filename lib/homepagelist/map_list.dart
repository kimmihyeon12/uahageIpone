import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/restaurant_sublist.dart';
import 'package:uahage/homepagelist/sublist/experience_center_sublist.dart';
import 'package:uahage/homepagelist/sublist/kid_cafe_sublist.dart';
import 'package:uahage/homepagelist/sublist/exaimination_institution_sublist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uahage/Location.dart';
import 'package:uahage/StarManage.dart';

class map_list extends StatefulWidget {
  map_list(
      {Key key,
      this.latitude,
      this.longitude,
      this.list,
      this.userId,
      this.loginOption,
      this.Area,
      this.Locality})
      : super(key: key);
  String loginOption;
  String userId;
  String latitude;
  String longitude;
  String list;
  String Area = "";
  String Locality = "";
  @override
  _map_listState createState() => _map_listState();
}

class _map_listState extends State<map_list> {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String searchKey = "";
  String Area = "";
  String Locality = "";
  String list;
  var listrequest;
  var index = 1;
  var Message;
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
  var star_color = false;
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
        list);
  }

  Future searchCategory() async {
    print(grey_image);
    controller.loadUrl(
        "http://13.209.41.43/searchCategory?lat=$latitude&long=$longitude&menu=${grey_image[0]}&bed=${grey_image[1]}&tableware=${grey_image[2]}&meetingroom=${grey_image[3]}&diapers=${grey_image[4]}&playroom=${grey_image[5]}&carriages=${grey_image[6]}&nursingroom=${grey_image[7]}&chair=${grey_image[8]}&Area=$Area&Locality=$Locality");
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

  searchAddress(searchKey) async {
    // ignore: unnecessary_statements
    print(searchKey);
    searchKey != ""
        ? controller
            .loadUrl('http://13.209.41.43/getAddress?address=$searchKey')
        : null;
  }

  // WebViewController _controller;
  WebViewController controller;

  @override
  void initState() {
    setState(() {
      list = widget.list;
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      latitude = widget.latitude;
      longitude = widget.longitude;
      Area = widget.Area;
      Locality = widget.Locality;
      listrequest = widget.list;
    });
    super.initState();
    print("latt in restaurant_sub : $latitude");
    print("long in restaurant_sub : $longitude");
    // getCurrentLocation();
  }

  getLatLong() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String lat = sharedPreferences.getString("uahageLat");
    String long = sharedPreferences.getString("uahageLong");
    setState(() {
      latitude = lat;
      longitude = long;
    });
  }

  int zoom = 4;
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

  Location location = new Location();

  Future lacations() async {
    await location.getCurrentLocation();
  }

  // uadate_location() async{
  //   String url = 'http://13.209.41.43/listsearchmarker/$listrequest?lat=35.146076&long=126.9231225&Area=광주&Locality=동구';
  //   var response = await http.get(url);
  //   setState(() {
  //     print('reload');
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
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

                    if (latitude == 'NaN' ||
                        longitude == 'NaN' ||
                        latitude == '' ||
                        longitude == '') {
                      getLatLong();
                    } else {
                      controller.loadUrl(
                          'http://13.209.41.43/listsearchmarker/$listrequest?lat=$latitude&long=$longitude&Area=$Area&Locality=$Locality');
                    }
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels: Set.from([
                    JavascriptChannel(
                        name: 'Print',
                        onMessageReceived: (JavascriptMessage message) async {
                          //This is where you receive message from
                          //javascript code and handle in Flutter/Dart
                          //like here, the message is just being printed
                          //in Run/LogCat window of android studio
                          var messages = message.message;
                          print("messages:" + messages);
                          print('userId:' + userId);
                          Message = messages.split(",");
                          await checkStar();
                          showPopUpbottomMenu(
                              context, screenHeight, screenWidth);
                        }),
                  ]),
                ),
                Container(
                  color: Colors.white,
                  child:
                      Center(child: buildSpinKitThreeBounce(80, screenWidth)),
                ),
              ],
            ),
            listrequest == "restaurant"
                ? InkWell(
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
                      margin: EdgeInsets.only(
                          left: 1250 / screenWidth, top: 30 / screenHeight),
                      child: Image.asset(
                        "./assets/searchPage/cat_btn.png",
                        height: 158 / screenHeight,
                      ),
                    ),
                  )
                : Container(),
            Row(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () async {
                      //     uadate_location();
                      lacations();
                      controller.loadUrl(
                          'http://13.209.41.43/listsearchmarker/$listrequest?lat=$latitude&long=$longitude&Area=$Area&Locality=$Locality');
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 48 / screenWidth, bottom: 76 / screenHeight),
                      child: SizedBox(
                        height: 159 / screenHeight,
                        width: 161 / screenWidth,
                        child: Image.asset("assets/searchPage/location.png"),
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
                //         IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 zoom -= 1;
                //               });
                //               controller.loadUrl(
                //                   "http://13.209.41.43/test/$listrequest?lat=$latitude&long=$longitude&zoomLevel=$zoom");
                //             },
                //             icon: Image.asset(
                //               "assets/searchPage/plus.png",
                //               width: 105 / screenWidth,
                //               height: 105 / screenHeight,
                //             )),
                //         IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 zoom += 1;
                //               });
                //               controller.loadUrl(
                //                   "http://13.209.41.43/test/$listrequest?lat=$latitude&long=$longitude&zoomLevel=$zoom");
                //             },
                //             icon: Image.asset(
                //               "assets/searchPage/minus.png",
                //               width: 105 / screenWidth,
                //               height: 105 / screenHeight,
                //             )),
                //       ],
                //     ),
                //   ),
                // )
                // //
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<Object> showPopUpbottomMenu(
      BuildContext context, double screenHeight, double screenWidth) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (BuildContext buildContext, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return StatefulBuilder(builder: (context, setState) {
            return Builder(builder: (context) {
              return GestureDetector(
                onPanDown: (a) {
                  Navigator.pop(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 2100 / (screenHeight),
                            bottom: 50 / screenHeight,
                            left: 33 / screenWidth,
                            right: 33 / screenWidth),
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, () {
                                if (Message[14] == 'restaurant') {
                                  return PageTransition(
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
                                    reverseDuration:
                                        Duration(milliseconds: 100),
                                  );
                                } else if (Message[14] ==
                                    'Examination_institution') {
                                  return PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: examination_institution_sublist(
                                      index: index++,
                                      storename: Message[0],
                                      address: Message[1],
                                      phone: Message[2],
                                      examinationitem: Message[12],
                                      userId: userId,
                                      loginOption: loginOption,
                                    ),
                                    duration: Duration(milliseconds: 250),
                                    reverseDuration:
                                        Duration(milliseconds: 100),
                                  );
                                } else if (Message[14] == 'Experience_center') {
                                  return PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: experience_center_sublist(
                                      index: index++,
                                      storename: Message[0],
                                      address: Message[1],
                                      phone: Message[2],
                                      fare: Message[13],
                                      userId: userId,
                                      loginOption: loginOption,
                                    ),
                                    duration: Duration(milliseconds: 250),
                                    reverseDuration:
                                        Duration(milliseconds: 100),
                                  );
                                } else {
                                  return PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: kid_cafe_sublist(
                                      index: index++,
                                      storename: Message[0],
                                      address: Message[1],
                                      phone: Message[2],
                                      fare: Message[13],
                                      userId: userId,
                                      loginOption: loginOption,
                                    ),
                                    duration: Duration(milliseconds: 250),
                                    reverseDuration:
                                        Duration(milliseconds: 100),
                                  );
                                }
                              }());
                            },
                            child: Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                  left: 30 /
                                      (1501 /
                                          MediaQuery.of(context).size.width),
                                )),
                                Image.asset(
                                  "./assets/listPage/clipGroup1.png",
                                  height: 409 / screenHeight,
                                  width: 413 / screenWidth,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                  left: 53 /
                                      (1501 /
                                          MediaQuery.of(context).size.width),
                                )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 60 / screenHeight),
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
                                                    : Message[0]
                                                        .substring(0, 11),
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xff010000),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily:
                                                      "NotoSansCJKkr_Bold",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 58 / screenWidth,
                                                  height: 0.8,
                                                ),
                                                // overflow: TextOverflow.ellipsis,
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
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Colors.black45,
                                                      textColor: Colors.white,
                                                      fontSize:
                                                          56 / screenWidth,
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
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10 / screenHeight),
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
                                      margin: EdgeInsets.only(
                                          top: 10 / screenHeight),
                                      height: 120 / screenHeight,
                                      width: 650 / screenWidth,
                                      alignment: Alignment.bottomRight,
                                      child: Row(children: [
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
                  ),
                ),
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
