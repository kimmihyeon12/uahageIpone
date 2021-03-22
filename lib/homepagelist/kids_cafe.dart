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
import 'package:uahage/ToastManage.dart';
import 'package:uahage/StarManage.dart';
import 'package:uahage/homepagelist/Kids_cafe_helper.dart';
import 'package:uahage/icon.dart';

class kids_cafe extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";
  String Area = "";
  String Locality = "";
  // String oldNickname;
  kids_cafe(
      {Key key,
      this.userId,
      this.loginOption,
      this.latitude,
      this.longitude,
      this.Area,
      this.Locality})
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
  String Area = "";
  String Locality = "";
  String liststringdata = 'Kids_cafe';
  String store_name1, address1, phone1, fare1;
  var star_color = false;
  List<bool> star_color_list = [];
  var list = true;
  var indexcount = 0;
  toast show_toast = new toast();
  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  int _currentMax = 0;
  ScrollController _scrollController = ScrollController();
  bool _isLoading;
  String userId = "";
  String loginOption = "";

  Future<List<dynamic>> myFuture;
  List<dynamic> kids_cafes;
  void initState() {
    // setState(() {
    kids_cafes = [];
    _isLoading = false;
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    latitude = widget.latitude;
    longitude = widget.longitude;
    Area = widget.Area ?? "";
    Locality = widget.Locality ?? "";
    get_star_color();
    myFuture = _getkidcafe();

    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta =
          100.0; // or something else..maxScroll - currentScroll <= delta
      if (currentScroll == maxScroll && !_isLoading) {
        print("scrolling");
        _currentMax += 10;
        _isLoading = true;
        _getkidcafe();
      }
    });

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

  Future get_star_color() async {
    star_color_list = await starInsertDelete.getStarColor(
        userId, loginOption, liststringdata);
    setState(() {});
  }

  Future<List<dynamic>> _getkidcafe() async {
    String liststringdata = "Kids_cafe";
    var response = await http.get(
        'http://13.209.41.43/getList/$liststringdata?maxCount=$_currentMax');
    List responseJson = json.decode(response.body);
    for (var data in responseJson) {
      kids_cafes.add(KidsCafe.fromJson(data));
    }
    setState(() {
      _isLoading = false;
    });
    return kids_cafes;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  icon iconwidget = new icon();

  bool toggle = false;
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
                InkWell(
                  highlightColor: Colors.white,
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
                )
              ],
            ),
          ),
          body: IndexedStack(index: indexcount, children: <Widget>[
            kids_cafe_view(context, screenWidth, screenHeight),
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

  Widget kids_cafe_view(context, screenWidth, screenHeight) {
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
          print("snapshot data: ${snapshot.data[0].address}");
          return Scrollbar(
            child: ListView.builder(
                controller: _scrollController,
                itemCount: kids_cafes?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0.3,
                    child: Container(
                        padding: EdgeInsets.only(
                          top: 30 / screenHeight,
                          left: 26 / screenWidth,
                          bottom: 40 / screenHeight,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              highlightColor: Colors.white,
                              onTap: () async {
                                bool result = await Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: kid_cafe_sublist(
                                          index: index,
                                          data: snapshot.data[index],
                                          userId: userId,
                                          loginOption: loginOption),
                                      duration: Duration(milliseconds: 250),
                                      reverseDuration:
                                          Duration(milliseconds: 100),
                                    ));

                                setState(() {
                                  if (result) {
                                    star_color_list[index] = true;
                                  } else {
                                    star_color_list[index] = false;
                                  }
                                });
                              },
                              child: Container(
                                width: 1280 / screenWidth,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
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

                              //         color:Colors.yellow,
                              child: IconButton(
                                padding: EdgeInsets.all(0),
                                constraints: BoxConstraints(
                                  maxWidth: 70 / screenWidth,
                                  maxHeight: 70 / screenHeight,
                                ),
                                icon: Image.asset(
                                  !star_color_list[index]
                                      ? "./assets/listPage/star_grey.png"
                                      : "./assets/listPage/star_color.png",
                                  height: 60 / screenHeight,
                                ),
                                onPressed: loginOption == "login"
                                    ? () {
                                        show_toast.showToast(
                                            context, "로그인해주세요!");
                                      }
                                    : () async {
                                        setState(() {
                                          store_name1 =
                                              snapshot.data[index].store_name;
                                          address1 =
                                              snapshot.data[index].address;
                                          phone1 = snapshot.data[index].phone;
                                          fare1 = snapshot.data[index].fare;

                                          if (star_color_list[index] == false) {
                                            star_color = true;
                                            star_color_list[index] = true;
                                          } else {
                                            star_color = false;
                                            star_color_list[index] = false;
                                          }
                                          ;

                                          click_star();
                                        });
                                      },
                              ),
                            ),
                          ],
                        )),
                  );
                }),
          );
        } else
          return Center(
            child: SizedBox(
                width: 60,
                height: 60,
                child: buildSpinKitThreeBounce(80, screenWidth)),
          );
      },
    );
  }
}
