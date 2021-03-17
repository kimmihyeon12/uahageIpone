import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/homepagelist/sublist/restaurant_sublist.dart';
import 'package:uahage/homepagelist/sublist/kid_cafe_sublist.dart';
import 'package:uahage/homepagelist/sublist/experience_center_sublist.dart';
import 'package:uahage/homepagelist/sublist/exaimination_institution_sublist.dart';
import 'package:uahage/StarManage.dart';
import 'package:uahage/screens/allAppBar.dart';
import 'package:uahage/icon.dart';

class starPage extends StatefulWidget {
  String loginOption;
  String userId;
  // String oldNickname;
  starPage({Key key, this.userId, this.loginOption}) : super(key: key);
  @override
  _starPageState createState() => _starPageState();
}

class _starPageState extends State<starPage> {
  FToast fToast;
  String userId = "";
  String loginOption = "";
  var address1 = "";
  // List<Star_list> star_lists = [];

  var listimage = [
    "./assets/listPage/clipGroup.png",
    "./assets/listPage/clipGroup1.png",
    "./assets/listPage/layer1.png",
    "./assets/listPage/layer2.png",
  ];

  List<bool> arr = [];
  var list = true;
  int _currentMax = 0;
  ScrollController _scrollController = ScrollController();

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  Future myFuture;
  icon iconwidget = new icon();
  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    setState(() {
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
    });
    super.initState();
  }

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  StarManage starInsertDelete = new StarManage();
  click_star(address1) async {

    var response = await starInsertDelete.click_star(
        userId + loginOption,
        null,
        address1,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        null,
        false,
        null);
    if (jsonDecode(response)["affectedRows"] == 1) setState(() {});
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
            "즐겨찾기가 해제되었어요",
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

  bool isIOS = Platform.isIOS;
  bool isIphoneX = Device.get().isIphoneX;
  appbar bar = new appbar();
  @override
  Widget build(BuildContext context) {
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    double screenHeight;
    double screenWidth;

    if (isIphoneX) {
      screenHeight = 5076 / MediaQuery.of(context).size.height;
      screenWidth = 2345 / MediaQuery.of(context).size.width;
    } else if (isIOS) {
      print("shu1");
      screenHeight = 1390 / MediaQuery.of(context).size.height;
      screenWidth = 781.5 / MediaQuery.of(context).size.width;
    } else {
      screenHeight = 2667 / MediaQuery.of(context).size.height;
      screenWidth = 1501 / MediaQuery.of(context).size.width;
    }
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: bar.navHome_abbbar("즐겨찾기",context),
        body: Column(
          children: [

            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: _getstar(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error),
                    );
                  } else if (snapshot.hasData) {
                    print("snapshot length " + snapshot.data.length.toString());
                    // print(snapshot.data[0].type.toString());
                    // print("startColor: $starColor");
                    return snapshot.data.length == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin:
                                    EdgeInsets.only(top: 803 / screenHeight),
                                child: Image.asset(
                                  './assets/starPage/group.png',
                                  height: 357 / screenHeight,
                                  width: 325 / screenWidth,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 68 / screenHeight),
                                child: // 즐겨찾기 목록이 없습니다. 관심장소를 즐겨찾기에 등록해 보세요.
                                    RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        style: TextStyle(
                                            color: const Color(0xffff728e),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKkr_Medium",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 73.0 / screenWidth),
                                        text: "즐겨찾기 목록이 없습니다.\n"),
                                    TextSpan(
                                        style: TextStyle(
                                            color: const Color(0xffadadad),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKkr_Medium",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 50.0 / screenWidth),
                                        text: "관심장소를 즐겨찾기에 등록해 보세요.")
                                  ]),
                                ),
                              ),
                            ],
                          )
                        : Scrollbar(
                            child: ListView.builder(
                                key: listKey,
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  // print("startColor: $starColor");
                                  return Card(
                                    elevation: 0.3,
                                    child: Container(
                                        height: 500 / screenHeight,
                                        padding: EdgeInsets.only(
                                          top: 30 / screenHeight,
                                          left: 26 / (1501 / ScreenWidth),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                listClicked(
                                                    snapshot, index, context);
                                              },
                                              child: Container(
                                                width: 1280 / screenWidth,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    (() {
                                                      if (index % 4 == 1) {
                                                        return Image.asset(
                                                          listimage[0],
                                                          height: 400 /
                                                              screenHeight,
                                                          width: 400 /
                                                              screenHeight,
                                                        );
                                                      } else if (index % 4 ==
                                                          2) {
                                                        return Image.asset(
                                                          listimage[1],
                                                          height: 400 /
                                                              screenHeight,
                                                          width: 400 /
                                                              screenHeight,
                                                        );
                                                      } else if (index % 4 ==
                                                          3) {
                                                        return Image.asset(
                                                          listimage[2],
                                                          height: 400 /
                                                              screenHeight,
                                                          width: 400 /
                                                              screenHeight,
                                                        );
                                                      } else {
                                                        return Image.asset(
                                                          listimage[3],
                                                          height: 400 /
                                                              screenHeight,
                                                          width: 400 /
                                                              screenHeight,
                                                        );
                                                      }
                                                    }()),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                      left: 53 / screenWidth,
                                                    )),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                          top:
                                                              10 / screenHeight,
                                                        )),
                                                        Container(
                                                          height:
                                                              80 / screenHeight,
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 700 /
                                                                    screenWidth,
                                                                height: 80 /
                                                                    screenHeight,
                                                                child: Text(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .store_name,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize: 56 /
                                                                        screenWidth,
                                                                    fontFamily:
                                                                        'NotoSansCJKkr_Medium',
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              top: 10 /
                                                                  screenHeight),
                                                          width:
                                                              650 / screenWidth,
                                                          height: 142 /
                                                              screenHeight,
                                                          child: Text(
                                                            snapshot.data[index]
                                                                .address,
                                                            style: TextStyle(
                                                              // fontFamily: 'NatoSans',
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 55 /
                                                                  screenWidth,
                                                              fontFamily:
                                                                  'NotoSansCJKkr_Medium',
                                                              height: 1.2,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: 140 /
                                                              screenHeight,
                                                          //  width: 650 / screenWidth,
                                                          alignment: Alignment
                                                              .bottomRight,
                                                          child: Row(
                                                            children: [
                                                              iconwidget.chair(snapshot
                                                                  .data[index]
                                                                  .chair , context),
                                                              iconwidget.carriage(snapshot
                                                                  .data[index]
                                                                  .carriage, context),
                                                              iconwidget.menu(snapshot
                                                                  .data[index]
                                                                  .menu, context),
                                                              iconwidget. bed(snapshot
                                                                  .data[index]
                                                                  .bed, context),
                                                              iconwidget.tableware(snapshot
                                                                  .data[index]
                                                                  .tableware, context),
                                                              iconwidget. meetingroom(snapshot
                                                                  .data[index]
                                                                  .meetingroom, context),
                                                              iconwidget.diapers(snapshot
                                                                  .data[index]
                                                                  .diapers, context),
                                                              iconwidget.playroom(snapshot
                                                                  .data[index]
                                                                  .playroom, context),
                                                              iconwidget.nursingroom(snapshot
                                                                  .data[index]
                                                                  .nursingroom, context),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20 / screenWidth,
                                                  top: 10 / screenHeight),
                                              child: IconButton(
                                                alignment:
                                                    Alignment.centerRight,
                                                padding: EdgeInsets.all(0),
                                                constraints: BoxConstraints(
                                                  maxWidth: 170 / screenWidth,
                                                  maxHeight: 170 / screenHeight,
                                                ),
                                                icon: Image.asset(
                                                  "./assets/listPage/star_color.png",
                                                  height: 60 / screenHeight,
                                                ),
                                                onPressed: () async {
                                                  var data =
                                                      snapshot.data[index];
                                                  await click_star(
                                                    data.address,
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        )),
                                  );
                                }),
                          );
                  }
                  return Center(
                    child: SizedBox(
                        width: 60,
                        height: 60,
                        child:
                            // CircularProgressIndicator(
                            //   strokeWidth: 5.0,
                            //   valueColor: new AlwaysStoppedAnimation<Color>(
                            //     Colors.pinkAccent,
                            //   ),
                            // ),
                            buildSpinKitThreeBounce(100, screenWidth)),
                  );
                },
              ),
            ),
          ],
        ));
  }

  void listClicked(AsyncSnapshot snapshot, int index, BuildContext context) {
    String type1 = snapshot.data[index].type;
    if (type1 == "restaurant") {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: restaurant_sublist(
                index: index,
               data:snapshot.data[index],
                userId: userId,
                loginOption: loginOption),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    } else if (type1 == "kids_cafe") {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: kid_cafe_sublist(
              index: index,
              data: snapshot.data[index],
              userId: userId,
              loginOption: loginOption,
            ),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    } else if (type1 == "examination_institution") {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: examination_institution_sublist(
              index: index,
            data: snapshot.data[index],
              loginOption: loginOption,
            ),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    } else {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: experience_center_sublist(
              index: index,
              data: snapshot.data[index],
              userId: userId,
              loginOption: loginOption,
            ),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    }
  }

  Future _getstar() async {

    var star_list1 = [];
    // starColor = [];
    var data = await http
        .get('http://13.209.41.43/starlist?user_id=$userId$loginOption');

    var jsonData = json.decode(data.body);
    for (var r in jsonData) {
      Star_list star_list = Star_list(
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
          r["chair"],
          r["fare"],
          r["Examination_item"],
          r["type"]);

      star_list1.add(star_list);
      // starColor.add(true);
    }

    return star_list1;
  }


}

class Star_list {
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
  final String fare;
  final String Examination_item;
  final String type;

  Star_list(
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
      this.chair,
      this.fare,
      this.Examination_item,
      this.type);
}
