import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:uahage/homepagelist/map_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/kid_cafe_sublist.dart';
import 'package:fluttertoast/fluttertoast.dart';

class kids_cafe extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  // String oldNickname;
  kids_cafe(
      {Key key, this.userId, this.loginOption, this.latitude, this.longitude})
      : super(key: key);
  @override
  _kids_cafeState createState() => _kids_cafeState();
}

class _kids_cafeState extends State<kids_cafe> {
  var listimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/images_kidscafe_sublist/image2.png",
  ];

  String latitude = "";
  String longitude = "";
  String liststringdata = 'Kids_cafe';
  String store_name1, address1, phone1, fare1;
  var star_color = false;
  List<String> star_color_list = [];
  var list = true;

  // getCurrentLocation() async {
  //   print("Geolocation started");
  //   LocationPermission permission = await Geolocator.requestPermission();

  //   final geoposition = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best);
  //   setState(() {
  //     latitude = '${geoposition.latitude}';
  //     longitude = '${geoposition.longitude}';
  //   });
  // }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  int _currentMax = 0;
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String userId = "";
  String loginOption = "";

  Future<List<Kids_cafe>> myFuture;
  void initState() {
    myFuture = _getrestaurant();
    setState(() {
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      latitude = widget.latitude;
      longitude = widget.longitude;
      // oldNickname = userId != "" ? getMyNickname().toString() : "";
    });
    _star_color();
    // getCurrentLocation();
    super.initState();
  }

  Future click_star() async {
    Map<String, dynamic> ss = {
      "user_id": userId + loginOption,
      "store_name": store_name1,
      "address": address1,
      "phone": phone1,
      "Examination_item": fare1,
      "star_color": star_color,
      "type": "kids_cafe"
    };
    var response = await http.post(
      "http://13.209.41.43/star",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
  }

  Future _star_color() async {
    var data = await http.get(
        'http://13.209.41.43/starcolor?user_id=$userId$loginOption&tablename=$liststringdata');
    var dec = jsonDecode(data.body);
    // print(dec);
    for (int i = 0; i < dec.length; i++) {
      //  print(dec[i]["store_name"].toString());
      star_color_list.add(dec[i]["store_name"].toString());
    }
    setState(() {});
  }

  Future<List<Kids_cafe>> _getrestaurant() async {
    List<Kids_cafe> kids_cafes = [];
    String liststringdata = "Kids_cafe";
    var data = await http.get(
        'http://13.209.41.43/getList/$liststringdata?maxCount=$_currentMax');
    //?maxCount=$_currentMax

    var jsonData = json.decode(data.body);

    for (var r in jsonData) {
      Kids_cafe kids_cafe = Kids_cafe(
        r["id"],
        r["store_name"],
        r["address"],
        r["phone"],
        r["fare"],
      );

      kids_cafes.add(kids_cafe);
    }

    return kids_cafes;
  }

  @override
  void dispose() {
    super.dispose();
    // _scrollController.dispose();
  }

  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Image.asset(
                      "./assets/listPage/backbutton.png",
                      width: 44 / (1501 / ScreenWidth),
                      height: 76 / (2667 / ScreenHeight),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                      left: 45 / screenWidth,
                    )),
                    Container(
                      // width: 310 / screenWidth,
                      child: Text(
                        '키즈·카페',
                        style: TextStyle(
                            fontSize: 62 / screenWidth,
                            fontFamily: 'NotoSansCJKkr_Medium',
                            color: Color.fromRGBO(255, 114, 148, 1.0)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 30 / screenWidth),
                child: toggle
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            toggle = !toggle;
                            if (list) {
                              list = false;
                            } else {
                              list = true;
                            }
                          });
                        },
                        child: Image.asset(
                          './assets/on.png',
                          width: 284 / screenWidth,
                          height: 133 / screenHeight,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            toggle = !toggle;
                            if (list) {
                              list = false;
                            } else {
                              list = true;
                            }
                          });
                        },
                        child: Image.asset(
                          './assets/off.png',
                          width: 284 / screenWidth,
                          height: 133 / screenHeight,
                        ),
                      ),
              )
              // Container(
              //   margin: EdgeInsets.only(left: 590 / screenWidth),
              //   child: LiteRollingSwitch(
              //     value: false,
              //     textOn: '목록',
              //     textOff: '지도',
              //     colorOn: Color.fromRGBO(255, 114, 148, 1.0),
              //     colorOff: Color.fromRGBO(255, 114, 148, 1.0),

              //     //    iconOn:  , iconOff: , textSize:
              //     onChanged: (bool state) {},
              //     onTap: () {
              //       /*     Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => map_list(),
              //             ));*/
              //       setState(() {
              //         if (list) {
              //           list = false;
              //         } else {
              //           list = true;
              //         }
              //       });
              //     },
              //   ),
              // ),
            ],
          ),
        ),
        body: list
            ? FutureBuilder(
                future: myFuture,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Center(
                      child: SizedBox(
                          width: 60,
                          height: 60,
                          child: buildSpinKitThreeBounce(80, screenWidth)
                          // CircularProgressIndicator(
                          //   strokeWidth: 5.0,
                          //   valueColor: new AlwaysStoppedAnimation<Color>(
                          //     Colors.pinkAccent,
                          //   ),
                          // ),
                          ),
                    );
                  } else {
                    print("length " + snapshot.data.length.toString());
                    return ListView.builder(
                        // controller: _scrollController,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0.3,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: kid_cafe_sublist(
                                        index: index,
                                        storename:
                                            snapshot.data[index].store_name,
                                        address: snapshot.data[index].address,
                                        phone: snapshot.data[index].phone,
                                        fare: snapshot.data[index].fare,
                                        userId: userId,
                                        loginOption: loginOption,
                                      ),
                                      duration: Duration(milliseconds: 250),
                                      reverseDuration:
                                          Duration(milliseconds: 100),
                                    ));
                              },
                              child: Container(
                                  // height: 500 / (2667 / ScreenHeight),
                                  padding: EdgeInsets.only(
                                    top: 30 / screenHeight,
                                    left: 26 / screenWidth,
                                    bottom: 40 / screenHeight,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            // border: Border.all(width: 3.0),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  (() {
                                                    if (index % 2 == 0)
                                                      return listimage[0];
                                                    else
                                                      return listimage[1];
                                                  }()),
                                                ),
                                                fit: BoxFit.fitHeight),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                        height: 414 / screenHeight,
                                        width: 414 / screenHeight,
                                        // child: (() {
                                        //   if (index % 2 == 0) {
                                        //     return Image.network(
                                        //       listimage[0],
                                        //       loadingBuilder: (context, child,
                                        //           loadingProgress) {
                                        //         if (loadingProgress == null)
                                        //           return child;
                                        //         return Center(
                                        //           child:
                                        //               buildSpinKitThreeBounce(
                                        //                   50, screenWidth),
                                        //         );
                                        //       },
                                        //       fit: BoxFit.fitHeight,
                                        //       // height: 414 / screenHeight,
                                        //     );
                                        //   } else {
                                        //     return Image.network(
                                        //       listimage[1],
                                        //       loadingBuilder: (context, child,
                                        //           loadingProgress) {
                                        //         if (loadingProgress == null)
                                        //           return child;
                                        //         return Center(
                                        //           child:
                                        //               buildSpinKitThreeBounce(
                                        //                   50, screenWidth),
                                        //         );
                                        //       },
                                        //       fit: BoxFit.fitHeight,
                                        //       // height: 414 / screenHeight,
                                        //     );
                                        //   }
                                        // }()),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                        left: 53 / screenWidth,
                                      )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10 / screenHeight)),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width:
                                                    800 / (1501 / ScreenWidth),
                                                height:
                                                    100 / (2667 / ScreenHeight),
                                                child: Text(
                                                  snapshot
                                                      .data[index].store_name,
                                                  style: TextStyle(
                                                    fontSize: 56 / screenWidth,
                                                    fontFamily:
                                                        'NotoSansCJKkr_Medium',
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                padding: EdgeInsets.all(0),
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      70 / (1501 / ScreenWidth),
                                                  maxHeight: 70 /
                                                      (2667 / ScreenHeight),
                                                ),
                                                icon: Image.asset(
                                                  star_color_list[index] ==
                                                          'null'
                                                      ? "./assets/listPage/star_grey.png"
                                                      : "./assets/listPage/star_color.png",
                                                  height: 60 /
                                                      (2667 / ScreenHeight),
                                                ),
                                                onPressed: loginOption ==
                                                        "login"
                                                    ? () {
                                                        Fluttertoast.showToast(
                                                          msg: "  로그인 해주세요!  ",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.black45,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 48 /
                                                              (2667 /
                                                                  ScreenHeight),
                                                        );
                                                      }
                                                    : () async {
                                                        setState(() {
                                                          store_name1 = snapshot
                                                              .data[index]
                                                              .store_name;
                                                          address1 = snapshot
                                                              .data[index]
                                                              .address;
                                                          phone1 = snapshot
                                                              .data[index]
                                                              .phone;
                                                          fare1 = snapshot
                                                              .data[index].fare;

                                                          if (star_color_list[
                                                                  index] ==
                                                              'null') {
                                                            star_color = true;
                                                            star_color_list[
                                                                index] = "test";
                                                            print(
                                                                ' star_color_list[index]');
                                                            print(
                                                                star_color_list[
                                                                    index]);
                                                          } else {
                                                            star_color = false;
                                                            star_color_list[
                                                                index] = 'null';
                                                          }
                                                          ;

                                                          click_star();
                                                        });
                                                      },
                                              ),
                                            ],
                                          ),
                                          Container(
                                            // height: 350 / screenHeight,
                                            width: 650 / screenWidth,
                                            child: Text(
                                              snapshot.data[index].address,
                                              style: TextStyle(
                                                // fontFamily: 'NatoSans',
                                                color: Colors.grey,
                                                fontSize: 50 / screenWidth,
                                                fontFamily:
                                                    'NotoSansCJKkr_Medium',
                                                height: 1.2,
                                              ),
                                            ),
                                          ),
                                          // Padding(
                                          //     padding: EdgeInsets.only(
                                          //   top: 20 / (2667 / ScreenHeight),
                                          // )),
                                          // SafeArea(
                                          //   child: Container(
                                          //     height:
                                          //         100 / (1501 / ScreenWidth),
                                          //     width: 800 / (1501 / ScreenWidth),
                                          //     child:
                                          //         snapshot.data[index].fare ==
                                          //                 null
                                          //             ? Text(" ")
                                          //             : Text(
                                          //                 snapshot.data[index]
                                          //                     .phone,
                                          //                 style: TextStyle(
                                          //                   // fontFamily: 'NatoSans',
                                          //                   color: Colors.grey,
                                          //                   fontSize: 45 /
                                          //                       (2667 /
                                          //                           ScreenHeight),
                                          //                   fontFamily:
                                          //                       'NotoSansCJKkr_Medium',
                                          //                 ),
                                          //               ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        });
                  }
                },
              )
            : map_list(
                userId: userId,
                loginOption: loginOption,
                latitude: latitude,
                longitude: longitude,
                list: liststringdata),
      ),
    );
  }
}

class Kids_cafe {
  final int id;
  final String store_name;
  final String address;
  final String phone;
  final String fare;

  Kids_cafe(this.id, this.store_name, this.address, this.phone, this.fare);
}
