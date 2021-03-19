import 'package:http/http.dart' as http;
import 'package:uahage/NavigationPage/Bottom.dart';
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
import 'package:uahage/icon.dart';
import 'package:uahage/ToastManage.dart';

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
  }

  StarManage starInsertDelete = new StarManage();
  toast show_toast = new toast();
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

  icon iconwidget = new icon();

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
                // automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Color(0xffff7292),
                  ),
                  iconSize: 100 / screenWidth,
                  color: Colors.white,
                  onPressed: () {
                    // setState(() {
                    //   searchbtn = false;
                    //   print(searchbtn);
                    // });
                    Navigator.pop(context, 'closed');
                  },
                ),
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                      top: 500 / screenHeight,
                    )),
                    // Padding(
                    //     padding: EdgeInsets.only(
                    //   left: 870 / screenWidth,
                    // )),
                    GestureDetector(
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
                      child: GestureDetector(
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
                            Message = messages.split("|");
                            await getSubStarColor();
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
                        color: Color(0xffff7292),
                        onPressed: () {
                          setState(() {
                            searchbtn = false;

                            print(searchbtn);
                          });
                          Navigator.pop(context, 'Yep!');
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
                                ? GestureDetector(
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
                      height: 2100 / (screenHeight),
                    ),
                  ),
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
                          );
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
                              left: 30 /
                                  (1501 / MediaQuery.of(context).size.width),
                            )),
                            Image.asset(
                              "./assets/listPage/clipGroup1.png",
                              height: 409 / screenHeight,
                              width: 413 / screenWidth,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              left: 53 /
                                  (1501 / MediaQuery.of(context).size.width),
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
                                                show_toast.showToast(
                                                    context, "로그인해주세요!");
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

  Future<bool> _onbackpressed() {
    setState(() {
      return Navigator.pop(context);
    });
  }
}
