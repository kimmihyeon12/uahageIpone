import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/restaurant_sublist.dart';
import 'dart:convert';
import 'package:uahage/StarManage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Map_List_Toggle extends StatefulWidget {
  Map_List_Toggle(
      {Key key,
      this.latitude,
      this.longitude,
      this.searchkey,
      this.userId,
      this.loginOption})
      : super(key: key);
  String userId;
  String loginOption;
  String latitude;
  String longitude;
  var searchkey;
  @override
  _Map_List_ToggleState createState() => _Map_List_ToggleState();
}

class _Map_List_ToggleState extends State<Map_List_Toggle> {
  @override
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
  String userId = "";
  String loginOption = "";
  int position;
  var switchbtn = false;
  WebViewController controller;
  var searchbtn = false;
  var i = 0;
  var Message;

  var star_color = false;
  var index = 1;
  List<String> store_namelist = List(500);
  List<String> addresslist = List(500);
  void initState() {
    super.initState();
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    //_star_color();
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

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  Widget startLoading(String A) {
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

  Widget build(BuildContext context) {
    var latitude = widget.latitude;
    var longitude = widget.longitude;
    var searchkey = widget.searchkey;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;

    return switchbtn
        ? WillPopScope(
            onWillPop: _onbackpressed,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 250 / screenHeight,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                      top: 500 / screenHeight,
                    )),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_sharp),
                      iconSize: 100 / screenWidth,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          searchbtn = false;
                          print(searchbtn);
                        });
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                      left: 870 / screenWidth,
                    )),
                    InkWell(
                      child: Image.asset(
                        './assets/off.png',
                        width: 290 / screenWidth,
                        height: 183 / screenHeight,
                      ),
                      onTap: () {
                        setState(() {
                          switchbtn = false;
                          print(searchbtn);
                          i = 0;
                        });
                      },
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                  itemCount: i,
                  itemBuilder: (context, index) {
                    print('snapshot.data.length');
                    // print(snapshot.data.id[index]);
                    return Card(
                      elevation: 0.3,
                      child: InkWell(
                        child: Container(
                            height: 400 / screenHeight,
                            padding: EdgeInsets.only(
                              top: 30 / screenHeight,
                              left: 26 / screenWidth,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 200 /
                                      (1501 /
                                          MediaQuery.of(context).size.width),
                                )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 1300 / screenWidth,
                                      height: 100 / screenHeight,
                                      child: Text(
                                        store_namelist[index],
                                        style: TextStyle(
                                          fontSize: 56 / screenWidth,
                                          fontFamily: 'NotoSansCJKkr_Medium',
                                        ),
                                      ),
                                    ),
                                    SafeArea(
                                      child: Container(
                                        height: 200 / screenHeight,
                                        width: 800 / screenWidth,
                                        child: Text(
                                          addresslist[index],
                                          style: TextStyle(
                                              // fontFamily: 'NatoSans',
                                              color: Colors.grey,
                                              fontSize: 56 / screenWidth,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                              height: 1.2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    );
                  }),
            ),
          )
        : WillPopScope(
            onWillPop: _onbackpressed,
            child: Scaffold(
              body: SafeArea(
                child: Stack(children: [
                  WebView(
                    onPageFinished: doneLoading,
                    onPageStarted: startLoading,
                    onWebViewCreated:
                        (WebViewController webViewController) async {
                      controller = webViewController;
                      await controller.loadUrl(
                          "http://13.209.41.43/homesearch?lat=$latitude&long=$longitude&address='$searchkey'");
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels: Set.from([
                      JavascriptChannel(
                          name: 'Print',
                          onMessageReceived: (JavascriptMessage message) async {
                            var messages = message.message;
                            var ex = messages.split(",");

                            setState(() {
                              for (int j = 0; j < 2; j++) {
                                store_namelist[i] = ex[0];
                                addresslist[i] = ex[1];
                                print(i.toString() +
                                    "store_namelist" +
                                    store_namelist[i]);
                                print(i.toString() +
                                    "addresslist" +
                                    addresslist[i]);
                              }
                              i++;
                            });
                          }),
                      JavascriptChannel(
                          name: 'Print1',
                          onMessageReceived: (JavascriptMessage message) async {
                            var messages = message.message;
                            Message = messages.split(",");
                            await checkStar();
                            showPopUpbottomMenu(
                                context, screenHeight, screenWidth);
                          })
                    ]),
                  ),
                  position == 1
                      ? Container(
                          color: Colors.white,
                          child: Center(
                              child: buildSpinKitThreeBounce(80, screenWidth)),
                        )
                      : Container(),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        top: 250 / screenHeight,
                      )),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_sharp),
                        iconSize: 100 / screenWidth,
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            searchbtn = false;

                            print(searchbtn);
                          });
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 950 / screenWidth,
                      )),
                      FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 550)),
                        builder: (c, s) =>
                            s.connectionState == ConnectionState.done
                                ? InkWell(
                                    child: Image.asset(
                                      './assets/on.png',
                                      width: 290 / screenWidth,
                                      height: 183 / screenHeight,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        switchbtn = true;
                                        print(switchbtn);
                                      });
                                    },
                                  )
                                : Text(
                                    "Loading..",
                                    style: TextStyle(
                                      fontSize: 45 / screenWidth,
                                      fontFamily: 'NotoSansCJKkr_Bold',
                                      letterSpacing: 0,
                                      color: Color(0xffff7292),
                                    ),
                                  ),
                      ),
                    ],
                  )
                ]),
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
                  print('aha');
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
                                    reverseDuration:
                                        Duration(milliseconds: 100),
                                  ));
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
                                            child: Text(Message[0],
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

                                                    loginOption != "login"
                                                        ? await click_star()
                                                        : null;
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

  Future<bool> _onbackpressed() {
    setState(() {
      //  searchbtn = false;
      //  switchbtn = false;
      return Navigator.pop(context, 'Yep!');
    });
  }

  menu(String menu) {
    var menus = menu.toString();

    return menus == "○"
        ? Container(
            child: Image.asset(iconimage[0], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[0], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  bed(String bed) {
    var beds = bed.toString();

    return beds == "○"
        ? Container(
            child: Image.asset(iconimage[1], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[1], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  tableware(String tableware) {
    var tablewares = tableware.toString();

    return tablewares == "○"
        ? Container(
            child: Image.asset(iconimage[2], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[2], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  meetingroom(String meetingroom) {
    var meetingrooms = meetingroom.toString();

    return meetingrooms == "○"
        ? Container(
            child: Image.asset(iconimage[3], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[3], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  diapers(String diapers) {
    var diaperss = diapers.toString();

    return diaperss == "○"
        ? Container(
            child: Image.asset(iconimage[4], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[4], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  playroom(String playroom) {
    var playrooms = playroom.toString();

    return playrooms == "○"
        ? Container(
            child: Image.asset(iconimage[5], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[5], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  carriage(String carriage) {
    var carriages = carriage.toString();

    return carriages == "○"
        ? Container(
            child: Image.asset(iconimage[6], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
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
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[7], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }

  chair(String chair) {
    var chairs = chair.toString();

    return chairs == "○"
        ? Container(
            child: Image.asset(iconimage[8], width: 30, height: 30),
            padding: EdgeInsets.only(
                left: 20 / (1501 / MediaQuery.of(context).size.width)),
          )
        : Container(
            child: Image.asset(iconimage[8], width: 0, height: 0),
            padding: EdgeInsets.only(
                left: 0 / (1501 / MediaQuery.of(context).size.width)),
          );
  }
}
