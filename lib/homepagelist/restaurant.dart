import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// import 'package:uahage/homepagelist/Restaurant_helper.dart';
import 'map_list.dart';
import 'package:uahage/homepagelist/sublist/restaurant_sublist.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fluttertoast/fluttertoast.dart';

class restaurant extends StatefulWidget {
  String loginOption;
  String userId;
  String latitude = "";
  String longitude = "";

  // String oldNickname;
  restaurant(
      {Key key, this.userId, this.loginOption, this.latitude, this.longitude})
      : super(key: key);
  @override
  _restaurantState createState() => _restaurantState();
}

class _restaurantState extends State<restaurant> {
  var indexcount = 0;
  FToast fToast;
  String latitude = "";
  String longitude = "";
  String userId = "";
  String loginOption = "";
  String store_name1,
      address1,
      phone1,
      menu1,
      bed1,
      tableware1,
      meetingroom1,
      diapers1,
      playroom1,
      carriage1,
      nursingroom1,
      chair1;
  var list = true;
  int _currentMax = 0;
  // ScrollController _scrollController = ScrollController();
  List<String> star_color_list = [];
  var star_color = false;
  bool toggle = false;

  String liststringdata = "restaurant";
  var listimage = [
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image1.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image2.png",
    "https://uahage.s3.ap-northeast-2.amazonaws.com/restaurant_image/image3.png",
  ];
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

  Future<List<Restaurant>> myFuture;

  @override
  void initState() {
    myFuture = _getrestaurant();
    setState(() {
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      latitude = widget.latitude ?? "";
      longitude = widget.longitude ?? "";
    });

    print("latt in restaurant : $latitude");
    print("long in restaurant : $longitude");
    _star_color();
    super.initState();
  }

  Future click_star() async {
    Map<String, dynamic> ss = {
      "user_id": userId + loginOption,
      "store_name": store_name1,
      "address": address1,
      "phone": phone1,
      "menu": menu1,
      "bed": bed1,
      "tableware": tableware1,
      "meetingroom": meetingroom1,
      "diapers": diapers1,
      "playroom": playroom1,
      "carriage": carriage1,
      "nursingroom": nursingroom1,
      "chair": chair1,
      "star_color": star_color,
      "type": "restaurant"
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
      // print(star_color_list[i]);
    }
    setState(() {});
  }

  Future<List<Restaurant>> _getrestaurant() async {
    List<Restaurant> restaurants = [];
    http.Response data = await http.get(
        // 'http://13.209.41.43/getList/$liststringdata?maxCount=$_currentMax');
        'http://13.209.41.43/getList/$liststringdata');

    List jsonData = json.decode(data.body);

    // jsonData.map((json) =>
    //     print("Calling: $json")); //Restaurant.fromJson(json)  .toList()

    for (var r in jsonData) {
      Restaurant restaurant = Restaurant(
          r["id"],
          r["store_name"],
          r["address"],
          r["phone"],
          r["menu"],
          r["bed"],
          r["Tableware"],
          r["meetingroom"],
          r["diapers"],
          r["playroom"],
          r["carriage"],
          r["nursingroom"],
          r["chair"]);

      restaurants.add(restaurant);
    }

    return restaurants;
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

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
                        width: 44 / screenWidth,
                        height: 76 / screenHeight,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 45 / screenWidth,
                      )),
                      Container(
                        // width: 310 / screenWidth,
                        child: Text(
                          '식당·카페',
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
                      : InkWell(
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
            restaruant_view(context, screenWidth, screenHeight),
            map_list(
                userId: userId,
                loginOption: loginOption,
                latitude: latitude,
                longitude: longitude,
                list: liststringdata),
          ])),
    );
  }

  Widget restaruant_view(context, screenWidth, screenHeight) {
    return FutureBuilder(
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
          print('snapshot.data.length : ${snapshot.data.length}');
          return ListView.builder(
              // controller: _scrollController,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                // print(snapshot.data.id[index]);
                return Card(
                  elevation: 0.3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: restaurant_sublist(
                                index: index,
                                storename: snapshot.data[index].store_name,
                                address: snapshot.data[index].address,
                                bed: snapshot.data[index].bed,
                                phone: snapshot.data[index].phone,
                                menu: snapshot.data[index].menu,
                                tableware: snapshot.data[index].tableware,
                                meetingroom: snapshot.data[index].meetingroom,
                                diapers: snapshot.data[index].diapers,
                                playroom: snapshot.data[index].playroom,
                                carriage: snapshot.data[index].carriage,
                                nursingroom: snapshot.data[index].nursingroom,
                                chair: snapshot.data[index].chair,
                                userId: userId,
                                loginOption: loginOption),
                            duration: Duration(milliseconds: 250),
                            reverseDuration: Duration(milliseconds: 100),
                          ));
                    },
                    child: Container(
                        height: 500 / screenHeight,
                        padding: EdgeInsets.only(
                          top: 30 / screenHeight,
                          left: 26 / screenWidth,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  // border: Border.all(width: 3.0),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        (() {
                                          if (index % 3 == 1)
                                            return listimage[0];
                                          else if (index % 3 == 2)
                                            return listimage[1];
                                          else
                                            return listimage[2];
                                        }()),
                                      ),
                                      fit: BoxFit.fill),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              height: 414 / screenHeight,
                              width: 414 / screenHeight,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                              left: 53 / screenWidth,
                            )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 10 / screenHeight)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 800 / screenWidth,
                                      height: 100 / screenHeight,
                                      child: Text(
                                        snapshot.data[index].store_name,
                                        style: TextStyle(
                                          fontSize: 56 / screenWidth,
                                          fontFamily: 'NotoSansCJKkr_Medium',
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.all(0),
                                      constraints: BoxConstraints(
                                        maxWidth: 70 / screenWidth,
                                        maxHeight: 70 / screenHeight,
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
                                                fontSize: 56 / screenWidth,
                                              );
                                            }
                                          : () async {
                                              setState(() {
                                                store_name1 = snapshot
                                                    .data[index].store_name;
                                                address1 = snapshot
                                                    .data[index].address;
                                                bed1 = snapshot.data[index].bed;
                                                phone1 =
                                                    snapshot.data[index].phone;
                                                menu1 =
                                                    snapshot.data[index].menu;
                                                tableware1 = snapshot
                                                    .data[index].tableware;
                                                meetingroom1 = snapshot
                                                    .data[index].meetingroom;
                                                diapers1 = snapshot
                                                    .data[index].diapers;
                                                playroom1 = snapshot
                                                    .data[index].playroom;
                                                carriage1 = snapshot
                                                    .data[index].carriage;
                                                nursingroom1 = snapshot
                                                    .data[index].nursingroom;
                                                chair1 =
                                                    snapshot.data[index].chair;

                                                if (star_color_list[index] ==
                                                    'null') {
                                                  setState(() {
                                                    star_color = true;
                                                    star_color_list[index] =
                                                        "test";
                                                  });
                                                } else {
                                                  setState(() {
                                                    star_color = false;
                                                    star_color_list[index] =
                                                        'null';
                                                  });
                                                }

                                                click_star();

                                                //    _star_color();
                                              });
                                            },
                                    ),
                                  ],
                                ),

                                Container(
                                  height: 141 / screenHeight,
                                  width: 650 / screenWidth,
                                  child: Text(
                                    snapshot.data[index].address,
                                    style: TextStyle(
                                      // fontFamily: 'NatoSans',
                                      color: Colors.grey,
                                      fontSize: 55 / screenWidth,
                                      fontFamily: 'NotoSansCJKkr_Medium',
                                      height: 1.2,
                                    ),
                                  ),
                                ),
                                // Container(
                                //   height: 80 / screenHeight,
                                //   width: 800 / screenWidth,
                                //   child: Text(
                                //     snapshot.data[index].phone,
                                //     style: TextStyle(
                                //       // fontFamily: 'NatoSans',
                                //       color: Colors.grey,
                                //       fontSize: 45 / 60 / screenWidth,
                                //       fontFamily:
                                //           'NotoSansCJKkr_Medium',
                                //     ),
                                //   ),
                                // ),

                                Container(
                                  height: 140 / screenHeight,
                                  //width: 800 / screenWidth,
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    children: [
                                      chair(snapshot.data[index].chair),
                                      carriage(snapshot.data[index].carriage),
                                      menu(snapshot.data[index].menu),
                                      bed(snapshot.data[index].bed),
                                      tableware(snapshot.data[index].tableware),
                                      meetingroom(
                                          snapshot.data[index].meetingroom),
                                      diapers(snapshot.data[index].diapers),
                                      playroom(snapshot.data[index].playroom),
                                      nursingroom(
                                          snapshot.data[index].nursingroom),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ),
                );
              });
        }
      },
    );
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

class Restaurant {
  final int id;
  final String store_name;
  final String address;
  final String phone;
  final String menu;
  final String bed;
  final String tableware;
  final String meetingroom;
  final String diapers;
  final String playroom;
  final String carriage;
  final String nursingroom;
  final String chair;

  Restaurant(
      this.id,
      this.store_name,
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
      this.chair);
}
