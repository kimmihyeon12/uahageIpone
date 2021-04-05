import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uahage/Widget/starManager.dart';
import 'package:uahage/View/Navigations/HomeSub/listSub.dart ';
import 'package:uahage/Widget/appBar.dart';
import 'package:uahage/Widget/icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:uahage/Provider/ConnectivityStatus.dart';

class starPage extends StatefulWidget {
  String loginOption;
  String userId;
  // String oldNickname;
  starPage({Key key, this.userId, this.loginOption}) : super(key: key);
  @override
  _starPageState createState() => _starPageState();
}

class _starPageState extends State<starPage> {
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
  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  Future myFuture;
  icon iconwidget = new icon();
  @override
  void initState() {
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

  bool isIOS = Platform.isIOS;
  bool isIphoneX = Device.get().isIphoneX;
  appbar bar = new appbar();
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectionStatus =
        Provider.of<ConnectivityStatus>(context);
    ScreenUtil.init(context, width: 2435, height: 5075);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: bar.navHome_abbbar("즐겨찾기", context),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                future: connectionStatus != ConnectivityStatus.Offline
                    ? _getstar()
                    : null,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else if (snapshot.hasData) {
                    print("snapshot length " + snapshot.data.length.toString());
                    return snapshot.data.length == 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 1539.h),
                                child: Image.asset(
                                  './assets/starPage/group.png',
                                  height: 508.h,
                                  width: 462.w,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 98.h),
                                child: // 즐겨찾기 목록이 없습니다. 관심장소를 즐겨찾기에 등록해 보세요.
                                    RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        style: TextStyle(
                                            color: const Color(0xffff728e),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKkr_Medium",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 104.sp),
                                        text: "즐겨찾기 목록이 없습니다.\n"),
                                    TextSpan(
                                        style: TextStyle(
                                            color: const Color(0xffadadad),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKkr_Medium",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 75.0.sp),
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
                                  return Dismissible(
                                    key: UniqueKey(),
                                    resizeDuration: Duration(milliseconds: 200),
                                    background: Container(
                                      color: Colors.red[400],
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(right: 30.w),
                                          )
                                        ],
                                      ),
                                    ),
                                    onDismissed: (direction) async {
                                      var data = snapshot.data[index];
                                      await click_star(data.address);
                                      // setState(() {
                                      snapshot.data.removeAt(index);
                                      // });
                                    },
                                    child: Card(
                                      elevation: 0.3,
                                      child: Container(
                                          height: 770.h,
                                          padding: EdgeInsets.only(
                                            top: 40.h,
                                            left: 76.w,
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
                                                  width: 2000.w,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      (() {
                                                        if (index % 4 == 1) {
                                                          return Image.asset(
                                                            listimage[0],
                                                            height: 639.h,
                                                            width: 639.w,
                                                          );
                                                        } else if (index % 4 ==
                                                            2) {
                                                          return Image.asset(
                                                            listimage[1],
                                                            height: 639.h,
                                                            width: 639.w,
                                                          );
                                                        } else if (index % 4 ==
                                                            3) {
                                                          return Image.asset(
                                                            listimage[2],
                                                            height: 639.h,
                                                            width: 639.w,
                                                          );
                                                        } else {
                                                          return Image.asset(
                                                            listimage[3],
                                                            height: 639.h,
                                                            width: 639.w,
                                                          );
                                                        }
                                                      }()),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                        left: 86.w,
                                                      )),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                            top: 10.h,
                                                          )),
                                                          Container(
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  margin:
                                                                  EdgeInsets.only(top: 20.h),
                                                                  width: 900.w,
                                                                  height: 160.h,
                                                                  child: Text(
                                                                    snapshot
                                                                        .data[
                                                                            index]
                                                                        .store_name,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          96.sp,
                                                                      fontFamily:
                                                                          'NotoSansCJKkr_Medium',
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 250.h,
                                                            width: 900.w,
                                                            child: Text(
                                                              snapshot
                                                                  .data[index]
                                                                  .address,
                                                              style: TextStyle(
                                                                // fontFamily: 'NatoSans',
                                                                color:
                                                                    Colors.grey,
                                                                fontSize: 86.sp,
                                                                fontFamily:
                                                                    'NotoSansCJKkr_Medium',
                                                                height: 1.3,
                                                              ),
                                                            ),
                                                          ),
                                      snapshot
                                          .data[index].type  == 'restaurant'
                                                              ? Container(
                                                            margin:
                                                            EdgeInsets.only(top: 15.h),
                                                            height: 175.h,
                                                            width: 900.w,
                                                            alignment:
                                                            Alignment.bottomRight,
                                                            child: Row(
                                                              children: [
                                                                iconwidget.chair(
                                                                    snapshot
                                                                        .data[index].chair,
                                                                    context),
                                                                iconwidget.carriage(
                                                                    snapshot.data[index]
                                                                        .carriage,
                                                                    context),
                                                                iconwidget.menu(
                                                                    snapshot
                                                                        .data[index].menu,
                                                                    context),
                                                                iconwidget.bed(
                                                                    snapshot
                                                                        .data[index].bed,
                                                                    context),
                                                                iconwidget.tableware(
                                                                    snapshot.data[index]
                                                                        .tableware,
                                                                    context),
                                                                iconwidget.meetingroom(
                                                                    snapshot.data[index]
                                                                        .meetingroom,
                                                                    context),
                                                                iconwidget.diapers(
                                                                    snapshot.data[index]
                                                                        .diapers,
                                                                    context),
                                                                iconwidget.playroom(
                                                                    snapshot.data[index]
                                                                        .playroom,
                                                                    context),
                                                                iconwidget.nursingroom(
                                                                    snapshot.data[index]
                                                                        .nursingroom,
                                                                    context),
                                                              ],
                                                            ),
                                                          )
                                                              : Container()
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 30.w, top: 40.h),
                                                child: IconButton(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  padding: EdgeInsets.all(0),
                                                  constraints: BoxConstraints(
                                                    maxWidth: 125.w,
                                                    maxHeight: 95.h,
                                                  ),
                                                  icon: Image.asset(
                                                    "./assets/listPage/star_color.png",
                                                    height: 95.h,
                                                  ),
                                                  onPressed: () async {
                                                    var data =
                                                        snapshot.data[index];
                                                    await click_star(
                                                      data.address,
                                                    );
                                                    //setState(() {
                                                    snapshot.data
                                                        .removeAt(index);
                                                    // });
                                                  },
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
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
                            buildSpinKitThreeBounce(80, 2435.w)),
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
            child: SubListPage(
              index: index++,
              data: snapshot.data[index],
              userId: userId,
              loginOption: loginOption,
              tableType: 'restaurant',
            ),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    } else if (type1 == "kids_cafe") {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: SubListPage(
              index: index++,
              data: snapshot.data[index],
              userId: userId,
              loginOption: loginOption,
              tableType: 'Kids_cafe',
            ),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    } else if (type1 == "examination_institution") {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: SubListPage(
              index: index++,
              data: snapshot.data[index],
              userId: userId,
              loginOption: loginOption,
              tableType: 'Examination_institution',
            ),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    } else {
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: SubListPage(
              index: index++,
              data: snapshot.data[index],
              userId: userId,
              loginOption: loginOption,
              tableType: 'Experience_center',
            ),
            duration: Duration(milliseconds: 250),
            reverseDuration: Duration(milliseconds: 100),
          ));
    }
  }

  var starList = [];

  Future _getstar() async {
    var star_list1 = [];
    // starColor = [];
    var data = await http
        .get('http://hohocompany.co.kr/starlist?user_id=$userId$loginOption');

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
