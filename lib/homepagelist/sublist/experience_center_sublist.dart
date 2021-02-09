import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

class experience_center_sublist extends StatefulWidget {
  experience_center_sublist(
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
  _experience_center_sublistState createState() =>
      _experience_center_sublistState();
}

class _experience_center_sublistState extends State<experience_center_sublist> {
  WebViewController controller;
  FToast fToast;
  var userId = "", loginOption = "";
  var storename, address, phone, fare;
  List<String> star_color_list = List(10);
  var star_color = false;

  var mainimage = [
    "./assets/sublistPage/image8.png",
    "./assets/sublistPage/image9.png",
    "./assets/sublistPage/image9.png",
    "./assets/sublistPage/image11.png",
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
    _star_color();

    super.initState();
  }

  Future _star_color() async {
    var data = await http.get(
        'http://119.200.163.240:3000/substarcolor?user_id=$userId$loginOption&storename=$storename');
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
              fontSize: 45/screenWidth,
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
    var storename = widget.storename;
    var address = widget.address;
    var phone = widget.phone;
    var fare = widget.fare;

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
                            Text("체험관 안내",
                                style: TextStyle(
                                    color: Color(0xffff7292),
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontSize: 67.0 / screenWidth),
                                textAlign: TextAlign.left)),
                  ],
                ),
              ),
              index % 4 == 0
                  ? Image.asset(
                      mainimage[0],
                      width: MediaQuery.of(context).size.width,
                    )
                  : index % 4 == 1
                      ? Image.asset(
                          mainimage[1],
                          width: MediaQuery.of(context).size.width,
                        )
                      : index % 4 == 2
                          ? Image.asset(
                              mainimage[2],
                              width: MediaQuery.of(context).size.width,
                            )
                          : index % 3 == 3
                              ? Image.asset(
                                  mainimage[3],
                                  width: MediaQuery.of(context).size.width,
                                )
                              : Image.asset(
                                  mainimage[3],
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
                    left: 75 / (1501 / MediaQuery.of(context).size.width),
                  ),
                  width: MediaQuery.of(context).size.width,
                  // alignment: Alignment.center,
                  height: 520 / screenHeight,
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
                        top: 15 / (1501 / MediaQuery.of(context).size.width),
                      )),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 1050 / (screenWidth),
                            height: 150 / (screenHeight),
                            child: Text(
                              address == null ? "정보 없음" : address,
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
                        top: 15 / (1501 / MediaQuery.of(context).size.width),
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
                  height: 300 / screenHeight,
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
                                15 / (1501 / MediaQuery.of(context).size.width),
                          )),
                          Text(
                            fare == null ? "정보 없음" : fare,
                            style: TextStyle(
                                color: Color(0xff808080),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 48.0 / screenWidth),
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
                                  (1501 / MediaQuery.of(context).size.width),
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
                                    'http://119.200.163.240:3000/storename?storename=$storename&address=$address');
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
