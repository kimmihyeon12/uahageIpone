import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:uahage/homepagelist/map_list.dart';
import 'package:uahage/homepagelist/sublist/exaimination_institution_sublist.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';

class examination_institution extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  // String oldNickname;
  examination_institution(
      {Key key, this.userId, this.loginOption, this.latitude, this.longitude})
      : super(key: key);
  @override
  _examination_institutionState createState() =>
      _examination_institutionState();
}

class _examination_institutionState extends State<examination_institution> {
  String latitude = "";
  String longitude = "";
  String userId = "";
  String loginOption = "";
  String liststringdata = 'Examination_institution';
  String store_name1, address1, phone1, Examination_item1;
  var star_color = false;
  List<String> star_color_list = List(1000);
  var list = true;
  int _currentMax = 0;
  // ScrollController _scrollController = ScrollController();

  var listimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/hospital_image/image2.png",
  ];

  getCurrentLocation() async {
    print("Geolocation started");
    LocationPermission permission = await Geolocator.requestPermission();

    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = '${geoposition.latitude}';
      longitude = '${geoposition.longitude}';
    });
  }

  @override
  void initState() {
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
      "Examination_item": Examination_item1,
      "star_color": star_color,
      "type": "examination_institution"
    };
    var response = await http.post(
      "http://211.55.236.196:3000/star",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
  }

  Future _star_color() async {
    var data = await http.get(
        'http://211.55.236.196:3000/starcolor?user_id=$userId$loginOption&tablename=$liststringdata');
    var dec = jsonDecode(data.body);
    // print(dec);
    for (int i = 0; i < dec.length; i++) {
      star_color_list[i] = dec[i]["store_name"].toString();
    }
    setState(() {});
  }

  Future<List<Examination_institution>> _getrestaurant() async {
    List<Examination_institution> examination_institutions = [];

    var data =
        await http.get('http://211.55.236.196:3000/getList/$liststringdata');
    //?maxCount=$_currentMax

    var jsonData = json.decode(data.body);
    for (var r in jsonData) {
      Examination_institution examination_institution = Examination_institution(
        r["id"],
        r["store_name"],
        r["address"],
        r["phone"],
        r["Examination_item"],
      );

      examination_institutions.add(examination_institution);
    }

    return examination_institutions;
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
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
                        left: 62 / screenWidth,
                      ),
                    ),
                    Container(
                      // width: 310 / screenWidth,
                      // margin: EdgeInsets.only(left: 50 / screenWidth),
                      child: Text(
                        '병원',
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
              ),
            ],
          ),
        ),
        body: list
            ? FutureBuilder(
                future: _getrestaurant(),
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
                                      child: examination_institution_sublist(
                                        index: index,
                                        storename:
                                            snapshot.data[index].store_name,
                                        address: snapshot.data[index].address,
                                        phone: snapshot.data[index].phone,
                                        examinationitem: snapshot
                                            .data[index].Examination_item,
                                        userId: userId,
                                        loginOption: loginOption,
                                      ),
                                      duration: Duration(milliseconds: 250),
                                      reverseDuration:
                                          Duration(milliseconds: 100),
                                    ));
                              },
                              child: Container(
                                  height: 500 / (2667 / ScreenHeight),
                                  padding: EdgeInsets.only(
                                    top: 30 / (2667 / ScreenHeight),
                                    left: 26 / (1501 / ScreenWidth),
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
                                        width: 413 / screenWidth,
                                      ),
                                      // (() {
                                      //   if (index % 2 == 0) {
                                      //     return Image.asset(
                                      //       listimage[0],
                                      //       height: 414 / (2667 / ScreenHeight),
                                      //     );
                                      //   } else {
                                      //     return Image.asset(
                                      //       listimage[1],
                                      //       height: 414 / (2667 / ScreenHeight),
                                      //     );
                                      //   }
                                      // }()),
                                      Padding(
                                          padding: EdgeInsets.only(
                                        left: 53 /
                                            (1501 /
                                                MediaQuery.of(context)
                                                    .size
                                                    .width),
                                      )),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SafeArea(
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 750 /
                                                      (1501 / ScreenWidth),
                                                  height: 100 /
                                                      (2667 / ScreenHeight),
                                                  child: Text(
                                                    snapshot
                                                        .data[index].store_name,
                                                    style: TextStyle(
                                                      fontSize:
                                                          56 / screenWidth,
                                                      fontFamily:
                                                          'NotoSansCJKkr_Medium',
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  padding: EdgeInsets.all(0),
                                                  constraints: BoxConstraints(
                                                    maxWidth: 170 /
                                                        (1501 / ScreenWidth),
                                                    maxHeight: 170 /
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
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                "  로그인 해주세요!  ",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                            backgroundColor:
                                                                Colors.black45,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 48 /
                                                                screenWidth,
                                                          );
                                                        }
                                                      : () async {
                                                          setState(() {
                                                            store_name1 =
                                                                snapshot
                                                                    .data[index]
                                                                    .store_name;
                                                            address1 = snapshot
                                                                .data[index]
                                                                .address;
                                                            phone1 = snapshot
                                                                .data[index]
                                                                .phone;
                                                            Examination_item1 =
                                                                snapshot
                                                                    .data[index]
                                                                    .Examination_item;

                                                            if (star_color_list[
                                                                    index] ==
                                                                'null') {
                                                              star_color = true;
                                                              star_color_list[
                                                                      index] =
                                                                  "test";
                                                              print(
                                                                  ' star_color_list[index]');
                                                              print(
                                                                  star_color_list[
                                                                      index]);
                                                            } else {
                                                              star_color =
                                                                  false;
                                                              star_color_list[
                                                                      index] =
                                                                  'null';
                                                            }
                                                            ;

                                                            click_star();
                                                          });
                                                        },
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                            top: 10 / (2667 / ScreenHeight),
                                          )),
                                          SafeArea(
                                            child: Container(
                                              height:
                                                  160 / (2667 / ScreenHeight),
                                              width: 800 / (1501 / ScreenWidth),
                                              child: Text(
                                                snapshot.data[index].address,
                                                style: TextStyle(
                                                  // fontFamily: 'NatoSans',
                                                  color: Colors.grey,
                                                  fontSize: 45 / screenWidth,
                                                  fontFamily:
                                                      'NotoSansCJKkr_Medium',
                                                ),
                                              ),
                                            ),
                                          ),
                                          SafeArea(
                                            child: Container(
                                              height:
                                                  150 / (1501 / ScreenWidth),
                                              width: 800 / (1501 / ScreenWidth),
                                              child: Text(
                                                snapshot.data[index].phone,
                                                style: TextStyle(
                                                  // fontFamily: 'NatoSans',
                                                  color: Colors.grey,
                                                  fontSize: 45 / screenWidth,
                                                  fontFamily:
                                                      'NotoSansCJKkr_Medium',
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Container(
                                          //   width: 800 / (1501 / ScreenWidth),
                                          //   child: Text(
                                          //     snapshot.data[index].Examination_item,
                                          //     style: TextStyle(
                                          //       // fontFamily: 'NatoSans',
                                          //       color: Colors.black,
                                          //       fontSize:
                                          //           45 / (2667 / ScreenHeight),
                                          //       fontFamily: 'NotoSansCJKkr_Medium',
                                          //     ),
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
                latitude: latitude, longitude: longitude, list: liststringdata),
      ),
    );
  }
}

class Examination_institution {
  final int id;
  final String store_name;
  final String address;
  final String phone;
  final String Examination_item;

  Examination_institution(this.id, this.store_name, this.address, this.phone,
      this.Examination_item);
}
