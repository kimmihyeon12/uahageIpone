import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:uahage/homepagelist/map_list.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/experience_center_sublist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uahage/StarManage.dart';

class experience_center extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  // String oldNickname;
  experience_center(
      {Key key,
      this.userId,
      this.loginOption,
      this.latitude,
      this.longitude,
      this.Area,
      this.Locality})
      : super(key: key);
  @override
  _experience_centerState createState() => _experience_centerState();
}

class _experience_centerState extends State<experience_center> {
  var listimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image3.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/experience_/image4.png",
  ];

  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  String liststringdata = "Experience_center";
  String userId = "";
  String loginOption = "";
  String store_name1, address1, phone1, fare1;
  var star_color = false;
  List<String> star_color_list = [];
  var list = true;
  var indexcount = 0;

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  int _currentMax = 0;
  // ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  Future<List<Experience_center>> myFuture;
  ScrollController _scrollController = ScrollController();
  List<Experience_center> experience_centers = [];

  @override
  void initState() {
    // setState(() {
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    latitude = widget.latitude;
    longitude = widget.longitude;
    Area = widget.Area ?? "";
    Locality = widget.Locality ?? "";
    // oldNickname = userId != "" ? getMyNickname().toString() : "";
    // });
    _star_color();
    _isLoading = false;

    myFuture = _getrestaurant();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      // double delta =
      //     100.0; // or something else..maxScroll - currentScroll <= delta
      if (currentScroll == maxScroll && !_isLoading) {
        print("scrolling");
        print("isloading: $_isLoading");
        _currentMax += 10;
        _isLoading = true;
        _getrestaurant();
      }
    });
    // getCurrentLocation();
    super.initState();
  }

  StarManage starInsertDelete = new StarManage();

  Future click_star() async {
    await starInsertDelete.click_star(
        userId + loginOption,
        store_name1,
        address1,
        phone1,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        fare1,
        null,
        star_color,
        liststringdata);
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

  Future<List<Experience_center>> _getrestaurant() async {
    var data = await http.get(
        'http://13.209.41.43/getList/$liststringdata?maxCount=$_currentMax');
    //?maxCount=$_currentMax

    var jsonData = json.decode(data.body);
    for (var r in jsonData) {
      Experience_center experience_center = Experience_center(
        r["id"],
        r["store_name"],
        r["address"],
        r["phone"],
        r["fare"],
      );

      experience_centers.add(experience_center);
    }
    setState(() {
      _isLoading = false;
    });

    return experience_centers;
  }

  bool toggle = false;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Image.asset("./assets/listPage/backbutton.png",
                          width: 44 / screenWidth, height: 76 / screenHeight),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 45 / screenWidth,
                      )),
                      Container(
                        // width: 310 / screenWidth,
                        child: Text(
                          '체험관',
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
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              toggle = !toggle;
                              if (indexcount == 1)
                                indexcount = 0;
                              else
                                indexcount = 1;
                            });
                          },
                          child: Image.asset(
                            './assets/on.png',
                            width: 284 / screenWidth,
                            height: 133 / screenHeight,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            setState(() {
                              toggle = !toggle;
                              if (indexcount == 1)
                                indexcount = 0;
                              else
                                indexcount = 1;
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
          body: IndexedStack(index: indexcount, children: <Widget>[
            experience_center_view(context, screenWidth, screenHeight),
            map_list(
                userId: userId,
                loginOption: loginOption,
                latitude: latitude,
                longitude: longitude,
                list: liststringdata,
                Area: Area,
                Locality: Locality),
          ])),
    );
  }

  Widget experience_center_view(context, screenWidth, screenHeight) {
    return FutureBuilder(
      future: myFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("${snapshot.error}"),
          );
        } else if (snapshot.hasData &&
            snapshot.data != null &&
            star_color_list.length != 0) {
          return Scrollbar(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: experience_centers?.length,
                itemBuilder: (context, index) {
                  print("List index: $index");
                  return Card(
                    elevation: 0.3,
                    child: Container(
                        // height: 500 / screenHeight,
                        padding: EdgeInsets.only(
                            top: 30 / screenHeight,
                            left: 26 / screenWidth,
                            bottom: 40 / screenHeight),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: experience_center_sublist(
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
                                width: 1280 / screenWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          // border: Border.all(width: 3.0),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                (() {
                                                  if (index % 4 == 0)
                                                    return listimage[0];
                                                  else if (index % 4 == 1)
                                                    return listimage[1];
                                                  else if (index % 4 == 2)
                                                    return listimage[2];
                                                  else
                                                    return listimage[3];
                                                }()),
                                              ),
                                              fit: BoxFit.fitHeight),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      height: 414 / screenHeight,
                                      width: 414 / screenHeight,
                                    ),
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
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 10 / screenHeight)),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 700 / screenWidth,
                                              height: 90 / screenHeight,
                                              child: Text(
                                                snapshot.data[index].store_name,
                                                style: TextStyle(
                                                  fontSize: 56 / screenWidth,
                                                  fontFamily:
                                                      'NotoSansCJKkr_Medium',
                                                ),
                                              ),
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
                                              fontSize: 56 / screenWidth,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 30 / screenWidth,
                                  top: 10 / screenHeight),
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                  maxWidth: 170 / screenWidth,
                                  maxHeight: 170 / screenHeight,
                                ),
                                icon: Image.asset(
                                  star_color_list[index] == 'null'
                                      ? "./assets/listPage/star_grey.png"
                                      : "./assets/listPage/star_color.png",
                                  height: 60 / screenHeight,
                                ),
                                onPressed: loginOption == "login"
                                    ? () {
                                        Fluttertoast.showToast(
                                          msg: "  로그인 해주세요!  ",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black45,
                                          textColor: Colors.white,
                                          fontSize: 48 / screenWidth,
                                        );
                                      }
                                    : () async {
                                        setState(() {
                                          store_name1 =
                                              snapshot.data[index].store_name;
                                          address1 =
                                              snapshot.data[index].address;
                                          phone1 = snapshot.data[index].phone;
                                          fare1 = snapshot.data[index].fare;

                                          if (star_color_list[index] ==
                                              'null') {
                                            star_color = true;
                                            star_color_list[index] = "test";
                                            print(' star_color_list[index]');
                                            print(star_color_list[index]);
                                          } else {
                                            star_color = false;
                                            star_color_list[index] = 'null';
                                          }
                                          ;

                                          click_star();
                                        });
                                      },
                              ),
                            )
                          ],
                        )),
                  );
                }),
          );
        } else {
          return Center(
            child: SizedBox(
                width: 60,
                height: 60,
                child: buildSpinKitThreeBounce(80, screenWidth)),
          );
        }
      },
    );
  }
}

class Experience_center {
  final int id;
  final String store_name;
  final String address;
  final String phone;
  final String fare;

  Experience_center(
      this.id, this.store_name, this.address, this.phone, this.fare);
}
