import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class restaurant_sublist extends StatefulWidget {
  restaurant_sublist(
      {Key key,
      this.index,
      this.storename,
      this.address,
      this.phone,
      this.menu,
      this.bed,
      this.tableware,
      this.meetingroom,
      this.diapers,
      this.playroom,
      this.carriage,
      this.nursingroom,
      this.chair,
      this.userId,
      this.loginOption})
      : super(key: key);
  int index;
  String storename;
  String address;
  String phone;
  String menu;
  String bed;
  String tableware;
  String meetingroom;
  String diapers;
  String playroom;
  String carriage;
  String nursingroom;
  String chair;
  String loginOption;
  String userId;
  @override
  _restaurant_sublistState createState() => _restaurant_sublistState();
}

class _restaurant_sublistState extends State<restaurant_sublist> {
  WebViewController controller;
  FToast fToast;
  var userId = "", loginOption = "";
  var storename,
      address,
      phone,
      menu,
      bed,
      tableware,
      meetingroom,
      diapers,
      playroom,
      carriage,
      nursingroom,
      chair;
  List<String> star_color_list = List(10);
  var star_color = false;

  Future _star_color() async {
    var data = await http.get(
        'http://211.55.236.196:3000/substarcolor?user_id=$userId$loginOption&storename=$storename');
    var dec = jsonDecode(data.body);
    print(dec.length);
    setState(() {
      if (dec.length == 0) {
        star_color_list[0] = 'null';
      } else {
        star_color_list[0] = dec[0]["store_name"].toString();
      }
    });
  }

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    setState(() {
      storename = widget.storename;
      address = widget.address;
      phone = widget.phone;
      menu = widget.menu;
      bed = widget.bed;
      tableware = widget.tableware;
      meetingroom = widget.meetingroom;
      diapers = widget.diapers;
      playroom = widget.playroom;
      carriage = widget.carriage;
      nursingroom = widget.nursingroom;
      chair = widget.chair;
      userId = widget.userId;
      loginOption = widget.loginOption;
    });
    print(storename);
    _star_color();

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
    "./assets/sublistPage/image1.png",
    "./assets/sublistPage/image2.png",
    "./assets/sublistPage/image3.png",
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

  @override
  Widget build(BuildContext context) {
    var index = widget.index;

    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //bar
              Container(
                height: 178 / screenHeight,
                width: 1501 / screenWidth,
                color: Colors.white,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        "./assets/listPage/backbutton.png",
                        width: 44 / (screenWidth),
                        height: 76 / (screenHeight),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 400 / screenWidth),
                        child: // 약관동의
                            Text("매장안내",
                                style: TextStyle(
                                    color: Color(0xffff7292),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 62.0 / screenWidth),
                                textAlign: TextAlign.left)),
                  ],
                ),
              ),
              index % 3 == 0
                  ? Image.asset(
                      mainimage[0],
                      width: MediaQuery.of(context).size.width,
                    )
                  : index % 3 == 1
                      ? Image.asset(
                          mainimage[1],
                          width: MediaQuery.of(context).size.width,
                        )
                      : index % 3 == 2
                          ? Image.asset(
                              mainimage[2],
                              width: MediaQuery.of(context).size.width,
                            )
                          : Image.asset(
                              mainimage[2],
                              width: MediaQuery.of(context).size.width,
                            ),

              Card(
                elevation: 0.3,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        left: 75 / (1501 / MediaQuery.of(context).size.width),
                      ),
                      width: 1320 / (1501 / MediaQuery.of(context).size.width),
                      alignment: Alignment.centerLeft,
                      height: 207 / screenHeight,
                      child: Text(storename,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "NotoSansCJKkr_Bold",
                              fontSize: 77.0 / screenWidth),
                          textAlign: TextAlign.left),
                    ),
                    IconButton(
                      padding: EdgeInsets.all(0),
                      constraints: BoxConstraints(
                          maxWidth: 170 / screenWidth,
                          maxHeight: 170 / screenHeight),
                      icon: Image.asset(
                          star_color_list[0] == 'null'
                              ? "./assets/listPage/star_grey.png"
                              : "./assets/listPage/star_color.png",
                          height: 60 / screenHeight),

                      /*      onPressed:() async {
                        setState(() {
                       if( star_color_list[0]=='null'){
                            setState(() {
                            star_color = true;
                              star_color_list[0]="test";
                            });
                          }else{
                            setState(() {
                              star_color=false;
                             star_color_list[0]='null';
                            });
                          };
                          click_star();
                        });
                      },*/
                    ),
                  ],
                ),
              ),

              Card(
                elevation: 0.3,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 75 / screenWidth,
                  ),
                  width: MediaQuery.of(context).size.width,
                  // alignment: Alignment.center,
                  height: 520 / screenHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        top: 40 / screenWidth,
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
                        top: 15 / screenWidth,
                      )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 1050 / (screenWidth),
                            height: 150 / (screenHeight),
                            child: Text(
                              address,
                              style: TextStyle(
                                  color: Color(0xff808080),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 48.0 / screenWidth),
                            ),
                          ),
                          InkWell(
                            child: Row(
                              children: [
                                Image.asset(
                                  "./assets/sublistPage/copy.png",
                                  width: 49 / (screenWidth),
                                  height: 56 / (screenHeight),
                                ),
                                Text(
                                  "주소복사",
                                  style: TextStyle(
                                      color: Color(0xffff7292),
                                      fontFamily: "NotoSansCJKkr_Medium",
                                      fontSize: 48.0 / screenWidth),
                                ),
                              ],
                            ),
                            onTap: () {
                              FlutterClipboard.copy(address)
                                  .then((value) => print('copied'));
                              _showToast(screenWidth);
                            },
                          )
                        ],
                      ),
                      Text(
                        "연락처",
                        style: TextStyle(
                            color: Color(0xff4d4d4d),
                            fontFamily: "NotoSansCJKkr_Medium",
                            fontSize: 58.0 / screenWidth),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 15 / screenWidth,
                      )),
                      Text(
                        phone == null ? "정보 없음" : phone,
                        style: TextStyle(
                            color: Color(0xff808080),
                            fontFamily: "NotoSansCJKkr_Medium",
                            fontSize: 48.0 / screenWidth),
                      ),
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
                        padding: EdgeInsets.only(
                          left: 75 / screenWidth,
                          top: 50 / screenHeight,
                        ),
                        child: Text(
                          "편의시설",
                          style: TextStyle(
                              color: Color(0xff4d4d4d),
                              fontFamily: "NotoSansCJKkr_Medium",
                              fontSize: 60.0 / screenWidth),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 50 / screenHeight)),
                      Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 67 / screenWidth)),
                            menu == "○"
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
                            bed == "○"
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
                            tableware == "○"
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
                            meetingroom == "○"
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
                            diapers == "○"
                                ? Image.asset(
                                    imagecolor[4],
                                    width: 292 / (screenWidth),
                                    height: 218 / (screenHeight),
                                  )
                                : Image.asset(
                                    imagegrey[4],
                                    width: 218 / (screenWidth),
                                    height: 292 / (screenHeight),
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
                          playroom == "○"
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
                          carriage == "○"
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
                          nursingroom == "○"
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
                          chair == "○"
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
                    height: 1373 / screenHeight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 75 /
                                  screenWidth,
                              top: 40 / screenHeight,
                            ),
                            child: Text(
                              "위치",
                              style: TextStyle(
                                  color: Color(0xff4d4d4d),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 60.0 / screenWidth),
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
                                    'http://211.55.236.196:3000/storename?storename=$storename&address=$address');
                                // print(storename);
                                // print(address);
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
