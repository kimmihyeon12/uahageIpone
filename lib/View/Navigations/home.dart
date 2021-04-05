import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uahage/View/Navigations/HomeSub/searchBar.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:uahage/View/Navigations/HomeSub/list.dart';
import 'package:uahage/Widget//appBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class homePage extends StatefulWidget {
  String loginOption;
  String userId;
  var latitude;
  var longitude;
  // String oldNickname;
  homePage({
    Key key,
    this.userId,
    this.loginOption,
    this.latitude,
    this.longitude,
  }) : super(key: key);
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  String loginOption = "";
  String userId = "";
  String Area = "";
  String Locality = "";
  var searchkey = "";

  var latitude;
  var longitude;
  var i;

  WebViewController controller;
  List<String> store_namelist = List(500);
  List<String> addresslist = List(500);
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    setState(() {
      loginOption = widget.loginOption;
      userId = widget.userId ?? "";
      latitude = widget.latitude ?? "";
      longitude = widget.longitude ?? "";
    });
    super.initState();
  }

  toast show_toast = new toast();

  int index = 1;

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size.w,
    );
  }

  var homeimage = [
    "./assets/homePage/restaurant.png",
    "./assets/homePage/hospital.png",
    "./assets/homePage/careCenter.png",
    "./assets/homePage/kindergarten.png",
    "./assets/homePage/kidsCafe.png",
    "./assets/homePage/experiencecenter.png",
    "./assets/homePage/amusementpark.png",
    "./assets/homePage/toylibrary.png",
    "./assets/homePage/childcareCenter.png"
  ];

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    bool isIOS = Platform.isIOS;
    bool isIphoneX = Device.get().isIphoneX;
    ScreenUtil.init(context, width: 2345, height: 5076);
    // if (isIphoneX) {
    //   ScreenUtil.init(context, width: 2345, height: 5076);
    // } else if (isIOS) {
    //   ScreenUtil.init(context, width: 781.5, height: 1390);
    // } else {
    //   ScreenUtil.init(context, width: 1500, height: 2667);
    // }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    print(Platform.operatingSystem);

    appbar bar = new appbar();

    imageView(fileName) {
      return CachedNetworkImage(
        imageUrl:
            "https://uahage.s3.ap-northeast-2.amazonaws.com/homepage/$fileName.png",
        // placeholder: (context, url) => buildSpinKitThreeBounce(50, screenWidth),
        fit: BoxFit.fill,
      );
    }

    return GestureDetector(
      onPanDown: (a) {
        currentFocus.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: bar.navHome_abbbar("우아하게", context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 2344.w,
                height: 1412.h,
                child: Stack(
                  children: [
                    PageView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return imageView("image${index + 1}");
                      },
                      onPageChanged: (int page) {
                        setState(() {
                          print(page);
                          index = page + 1;
                        });
                      },
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: new BoxDecoration(
                            color: Colors.pink[200],
                            //   image: DecorationImage(
                            //     image: AssetImage('./assets/path.png'),
                            //   ),
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: EdgeInsets.only(top: 131.h, right: 96.w),
                        padding:
                            EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                        child: Text(
                          '$index/5',
                          style: TextStyle(
                            fontSize: 98.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(78.w, 85.h, 78.w, 0),
                height: 281.h,
                child: Theme(
                  data: new ThemeData(
                      primaryColor: Color.fromRGBO(255, 114, 148, 1.0),
                      fontFamily: 'NotoSansCJKkr_Medium'
                      // primaryColorDark: Colors.red,
                      ),
                  child: TextField(
                    controller: _controller,
                    onChanged: (txt) {
                      setState(() {
                        searchkey = txt;
                      });
                    },
                    // autofocus: false,
                    // showCursor: false,
                    cursorColor: Color(0xffff7292),
                    style: TextStyle(
                        color: Color(0xffcccccc),
                        fontSize: 96.sp,
                        letterSpacing: -1.0),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(0xffff7292),
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0,
                            color: Color(0xffff7292),
                          )),
                      contentPadding: EdgeInsets.fromLTRB(117.w, 0, 0, 0),
                      hintText: "장소, 주소, 상호명을 검색해주세요",
                      hintStyle: TextStyle(
                          color: Color(0xffcccccc),
                          fontSize: 96.sp,
                          fontFamily: 'NotoSansCJKkr_Medium',
                          letterSpacing: -1.0),
                      suffixIcon: IconButton(
                          onPressed: searchkey != ""
                              ? () {
                                  FocusScope.of(context).unfocus();

                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Keyword(
                                                  userId: userId,
                                                  loginOption: loginOption,
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                  searchkey: searchkey)))
                                      .then((value) {
                                    _controller.clear();
                                    searchkey = "";
                                  });
                                  // currentFocus.unfocus();
                                }
                              : () {
                                  _controller.clear();
                                  FocusScope.of(context).unfocus();
                                  show_toast.showToast(context, "주소를 입력해주세요!");
                                },
                          icon: Image.asset(
                            "./assets/homePage/search.png",
                            width: 138.w,
                            height: 136.h,
                          )),
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                top: 146.h,
              )),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        left: 122.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[0],
                          width: 339.w,
                          height: 329.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListPage(
                                        userId: userId,
                                        loginOption: loginOption,
                                        latitude: latitude,
                                        longitude: longitude,
                                        Area: Area,
                                        Locality: Locality,
                                        tableType: "restaurant",
                                      )));
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 285.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[1],
                          width: 263.w,
                          height: 398.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListPage(
                                        userId: userId,
                                        loginOption: loginOption,
                                        latitude: latitude,
                                        longitude: longitude,
                                        tableType: "Examination_institution",
                                      )));
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 308.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[2],
                          width: 292.w,
                          height: 412.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          show_toast.showToast(context, " 서비스 준비 중이에요!  ");
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 317.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[3],
                          width: 255.w,
                          height: 387.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          show_toast.showToast(context, " 서비스 준비 중이에요!  ");
                        },
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    top: 188.h,
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        left: 144.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[4],
                          width: 296.w,
                          height: 391.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListPage(
                                        userId: userId,
                                        loginOption: loginOption,
                                        latitude: latitude,
                                        longitude: longitude,
                                        tableType: "Kids_cafe",
                                      )));
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 325.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[5],
                          width: 237.w,
                          height: 357.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListPage(
                                        userId: userId,
                                        loginOption: loginOption,
                                        latitude: latitude,
                                        longitude: longitude,
                                        tableType: "Experience_center",
                                      )));
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 350.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[6],
                          width: 222.w,
                          height: 372.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          show_toast.showToast(context, " 서비스 준비 중이에요!  ");
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 232.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[7],
                          width: 455.w,
                          height: 315.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          show_toast.showToast(context, " 서비스 준비 중이에요!  ");
                        },
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                    top: 235.h,
                  )),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        left: 142.w,
                      )),
                      GestureDetector(
                        child: Image.asset(
                          homeimage[8],
                          width: 293.w,
                          height: 345.h,
                        ),
                        onTap: () {
                          currentFocus.unfocus();
                          show_toast.showToast(context, " 서비스 준비 중이에요!  ");
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(
                top: 120.h,
              )),
              Container(
                padding: EdgeInsets.only(
                  left: 140.w,
                  top: 120.h,
                  bottom: 120.h,
                ),
                color: Color.fromRGBO(247, 248, 250, 1.0),
                // height: 650 .h,
                width: 2435.w,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "./assets/homePage/logo_grey.png",
                        width: 399.w,
                        height: 99.h,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        top: 57.h,
                      )),
                      Text(
                        "상호명 : (주)호호컴퍼니\n대표이사 : 김화영     사업자등록번호 : 322-86-01766\n유선번호 : 061-331-3116  팩스 : 061-331-3117\nemail : hohoco0701@gmail.com \n주소 : 전라남도 나주시 빛가람로 740 한빛타워 6층 601호\ncopyrightⓒ 호호컴퍼니 Inc. All Rights Reserved.            \n사업자 정보 확인   |   이용약관   |   개인정보처리방침",
                        style: TextStyle(
                            fontFamily: "NotoSansCJKkr_Medium",
                            height: 1.8,
                            //   letterSpacing: -1.0,
                            fontSize: 65.sp,
                            color: Color.fromRGBO(151, 151, 151, 1.0)),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
