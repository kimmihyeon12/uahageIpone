import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

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
  var iconimage = [
    "./assets/listPage/menu.png",
    "./assets/listPage/bed.png",
    "./assets/listPage/tableware.png",
    "./assets/listPage/meetingroom.png",
    "./assets/listPage/diapers.png",
    "./assets/listPage/playroom.png",
    "./assets/listPage/playroom.png",
    "./assets/listPage/nursingroom.png",
    "./assets/listPage/chair.png",
  ];
  List<bool> arr = List(500);
  var list = true;
  int _currentMax = 0;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    fToast = FToast();
    fToast.init(context);
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    super.initState();
  }

  Future click_star() async {
    Map<String, dynamic> ss = {
      "user_id": userId + loginOption,
      "address": address1,
      "star_color": false,
    };
    var response = await http.post(
      "http://211.55.236.196:3000/star",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
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

  @override
  Widget build(BuildContext context) {
    print("widget reloaded!");
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromRGBO(255, 114, 148, 1.0),
          elevation: 0,
          centerTitle: true,
          title: Text(
            "즐겨찾기",
            style: TextStyle(
              fontSize: 73 / screenWidth,
              fontFamily: 'NotoSansCJKkr_Medium',
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder(
          future: _getstar(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    strokeWidth: 5.0,
                    valueColor: new AlwaysStoppedAnimation<Color>(
                      Colors.pinkAccent,
                    ),
                  ),
                ),
              );
            } else {
              print("snapshot length " + snapshot.data.length.toString());
              return snapshot.data.length == 0
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 803 / screenHeight),
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
                  : ListView.builder(
                      //        controller: _scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        print('snapshot.data.length');
                        // print(snapshot.data.id[index]);
                        return Card(
                          elevation: 0.3,
                          child: InkWell(
                            child: Container(
                                height: 500 / screenHeight,
                                padding: EdgeInsets.only(
                                  top: 30 / (2667 / ScreenHeight),
                                  left: 26 / (1501 / ScreenWidth),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ((){
                                      if(index % 4 == 1){
                                        return Image.asset(
                                          listimage[0],
                                          height: 414 / (2667 / ScreenHeight),
                                        );
                                      }
                                      else if(index % 4 == 2){
                                        return Image.asset(
                                          listimage[1],
                                          height:
                                          414 / (2667 / ScreenHeight),
                                        );
                                      }
                                      else if(index % 4 == 3){
                                        return Image.asset(
                                          listimage[2],
                                          height:
                                          414 / (2667 / ScreenHeight),
                                        );
                                      }else{
                                        return Image.asset(
                                          listimage[3],
                                          height:
                                          414 / (2667 / ScreenHeight),
                                        );
                                      }
                                    }()),
                                    Padding(
                                        padding: EdgeInsets.only(
                                      left: 53 /
                                          screenWidth,
                                    )),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width:
                                                  750 / screenWidth,
                                              height:
                                                  100 / screenHeight,
                                              child: Text(
                                                snapshot
                                                    .data[index].store_name,
                                                style: TextStyle(
                                                  fontSize: 56 /
                                                      screenWidth,
                                                  fontFamily:
                                                      'NotoSansCJKkr_Medium',
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.all(0),
                                              constraints: BoxConstraints(
                                                maxWidth: 170 /
                                                    screenWidth,
                                                maxHeight: 170 /
                                                    screenHeight,
                                              ),
                                              icon: Image.asset(
                                                // false
                                                //     ? "./assets/listPage/star_grey.png"
                                                //     :
                                                    "./assets/listPage/star_color.png",
                                                height: 60 /
                                                    screenHeight,
                                              ),
                                              onPressed: () async {
                                                setState(() {
                                                  address1 = snapshot
                                                      .data[index].address;

                                                });
                                                click_star();
                                                _showToast(screenWidth);
                                                //setState(() {

                                                // });
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 80 / screenHeight,
                                          width: 800 / screenWidth,
                                          child: Text(
                                            snapshot.data[index].phone,
                                            style: TextStyle(
                                              // fontFamily: 'NatoSans',
                                              color: Colors.grey,
                                              fontSize:
                                                  45 /screenWidth,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                          top: 10 / screenHeight,
                                        )),
                                        Container(
                                          // height: 80 / screenHeight,
                                          width: 800 / screenWidth,
                                          child: Text(
                                            snapshot.data[index].address,
                                            style: TextStyle(
                                              // fontFamily: 'NatoSans',
                                              color: Colors.grey,
                                              fontSize:
                                                  45 / screenWidth,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 150 / screenHeight,
                                          width: 800 / screenWidth,
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            children: [
                                              chair(
                                                  snapshot.data[index].chair),
                                              carriage(snapshot
                                                  .data[index].carriage),
                                              menu(snapshot.data[index].menu),
                                              bed(snapshot.data[index].bed),
                                              tableware(snapshot
                                                  .data[index].tableware),
                                              meetingroom(snapshot
                                                  .data[index].meetingroom),
                                              diapers(snapshot
                                                  .data[index].diapers),
                                              playroom(snapshot
                                                  .data[index].playroom),
                                              nursingroom(snapshot
                                                  .data[index].nursingroom),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        );
                      });
            }
          },
        ));
  }

  Future _getstar() async {
    print("called function");
    var star_list1 = [];
    var data = await http
        .get('http://211.55.236.196:3000/starlist?user_id=$userId$loginOption');

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
          r["Examination_item"]);

      star_list1.add(star_list);
    }

    return star_list1;
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
      this.Examination_item);
}
