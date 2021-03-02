import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:uahage/NavigationPage/Navigationbar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

//dsda

//dsa
//sada//
class registrationPage extends StatefulWidget {
  String userId;
  String loginOption;
  registrationPage({Key key, this.userId, this.loginOption}) : super(key: key);
  @override
  _registrationPageState createState() => _registrationPageState();
}

class _registrationPageState extends State<registrationPage> {
  //gender image , gender image color
  bool isIOS = Platform.isIOS;

  var boy = true;
  var girl = true;
  var boy_image = [
    './assets/registrationPage/boy_grey.png',
    './assets/registrationPage/boy_pink.png'
  ];
  var girl_image = [
    './assets/registrationPage/girl_grey.png',
    './assets/registrationPage/girl_pink.png'
  ];
  String birthday = "";
  String nickName = "";
  bool isIdValid = false;
  String loginOption = "";
  String gender = "";
  String userAge = "";
  String userId = "";
  bool saveError = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loginOption = widget.loginOption;
      userId = widget.userId;
    });
  }

  Future checkNickname() async {
    var data;
    try {
      var response =
          await http.get("http://13.209.41.43/getNicknames/$nickName");
      if (response.statusCode == 200) {
        data = jsonDecode(response.body)["message"];

        setState(() {
          isIdValid = true;
        });
        return data;
      } else {
        data = jsonDecode(response.body)["message"];
        setState(() {
          isIdValid = false;
        });
        return data;
      }
    } catch (err) {
      // print(err);
      return data["message"];
    }
  }

  Future saveToDatabase(String type) async {
    Map<String, dynamic> ss = type == "withNickname"
        ? {
            "email": userId + loginOption,
            "nickname": nickName,
            "gender": gender,
            "birthday": birthday,
            "age": userAge,
            "URL": "",
          }
        : {
            "email": userId + loginOption,
            "nickname": "",
            "gender": "",
            "birthday": "",
            "age": "",
            "URL": "",
          };
    // print(ss);
    var response = await http.post(
      "http://13.209.41.43/saveUser",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
    response.statusCode == 200
        ? setState(() {
            saveError = false;
          })
        : setState(() {
            saveError = true;
          });
    return jsonDecode(response.body)["message"];
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  // year calendar
  String year, month, yearMonthDay, yearMonthDayTime;
  TextEditingController yController = TextEditingController();
  var changeimage = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    var _fontsize = 62.5 / screenHeight;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FocusScopeNode currentFocus = FocusScope.of(context);

    return isIOS
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "회원가입",
                style: TextStyle(
                  fontSize: 73 / screenWidth,
                  color: Colors.white,
                  fontFamily: 'NotoSansCJKkr_Bold',
                ),
              ),
              backgroundColor: Color(0xffff7292),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 250 / screenHeight)),

                  //membership_Nickname

                  Container(
                    child: Container(
                      child: Row(
                        children: [
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 150 / screenWidth)),
                          Text(
                            "닉네임",
                            style: TextStyle(
                                fontSize: 57 / screenWidth,
                                color: Color.fromARGB(255, 255, 114, 148),
                                fontFamily: 'NotoSansCJKkr_Medium'),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 88 / screenWidth)),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(
                                right: 121 / screenWidth,
                              ),
                              child: Stack(
                                children: [
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        nickName = value;
                                      });
                                    },
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: const Color(0xff3a3939),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "NotoSansCJKkr_Bold",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 62.5 / screenWidth,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          right: 410 / screenWidth),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: const Color(0xffff7292),
                                        ),

                                        //Color.fromRGBO(255, 114, 148, 1.0)
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffff7292)),
                                      ),
                                      hintText: '닉네임를 입력하세요',
                                      hintStyle: TextStyle(
                                          color: Color(0xffcccccc),
                                          fontSize: 57 / screenWidth,
                                          letterSpacing: -1.0),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      width: 350 / screenWidth,
                                      height: 143 / screenHeight,
                                      child: FlatButton(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(8.0),
                                        ),
                                        onPressed: nickName != ""
                                            ? () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      FutureBuilder(
                                                          future:
                                                              checkNickname(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(20.0))),
                                                                title: // 사용 가능한 닉네임입니다.
                                                                    Text(
                                                                        snapshot
                                                                            .data,
                                                                        style: TextStyle(
                                                                            color: const Color(
                                                                                0xff4d4d4d),
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontFamily:
                                                                                "NotoSansCJKkr_Medium",
                                                                            fontStyle: FontStyle
                                                                                .normal,
                                                                            fontSize: 62.5 /
                                                                                screenWidth),
                                                                        textAlign:
                                                                            TextAlign.left),
                                                                actions: [
                                                                  FlatButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: // 확인
                                                                          buildText(
                                                                              _fontsize))
                                                                ],
                                                              );
                                                            } else if (snapshot
                                                                .hasError)
                                                              return AlertDialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(20.0))),
                                                                title:
                                                                    // id already exists.
                                                                    Text(
                                                                        snapshot
                                                                            .error,
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xff4d4d4d),
                                                                            fontWeight: FontWeight
                                                                                .w500,
                                                                            fontFamily:
                                                                                "NotoSansCJKkr_Medium",
                                                                            fontStyle: FontStyle
                                                                                .normal,
                                                                            fontSize: 62.5 /
                                                                                screenWidth),
                                                                        textAlign:
                                                                            TextAlign.left),
                                                                actions: [
                                                                  FlatButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: // 확인
                                                                          buildText(
                                                                              _fontsize))
                                                                ],
                                                              );

                                                            return Center(
                                                              child: SizedBox(
                                                                  height: 200 /
                                                                      screenHeight,
                                                                  width: 200 /
                                                                      screenWidth,
                                                                  child: buildSpinKitThreeBounce(
                                                                      80,
                                                                      screenWidth)
                                                                  //     CircularProgressIndicator(
                                                                  //   strokeWidth:
                                                                  //       5.0,
                                                                  //   valueColor:
                                                                  //       new AlwaysStoppedAnimation<
                                                                  //           Color>(
                                                                  //     Colors
                                                                  //         .pinkAccent,
                                                                  //   ),
                                                                  // )
                                                                  ),
                                                            );
                                                          }),
                                                );
                                              }
                                            : () {},
                                        color: nickName == ""
                                            ? Color(0xffcacaca)
                                            : Color(0xffff7292),
                                        child: Text(
                                          "중복확인",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'NotoSansCJKkr_Medium',
                                            fontSize: 50 / screenWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 76 / screenHeight)),

                  //baby_Gender
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                      Widget>[
                    Padding(padding: EdgeInsets.only(left: 91 / screenWidth)),
                    Container(
                      child: Text(
                        "아이성별",
                        style: TextStyle(
                            fontSize: 57 / screenWidth,
                            color: Color.fromARGB(255, 255, 114, 148),
                            fontFamily: 'NotoSansCJKkr_Medium'),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(left: 80 / screenWidth)),
                    InkWell(
                      onTap: () {
                        _pressedbaby('boy');
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 364 / screenHeight,
                          child: Image.asset(boy ? boy_image[0] : boy_image[1]),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 11)),
                      ]),
                    ),
                    Padding(padding: EdgeInsets.only(left: 98 / screenWidth)),
                    InkWell(
                      onTap: () {
                        _pressedbaby('girl');
                      },
                      child: Column(children: <Widget>[
                        Container(
                          height: 364 / screenHeight,
                          child:
                              Image.asset(girl ? girl_image[0] : girl_image[1]),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 11)),
                      ]),
                    ),
                  ]),

                  //baby_birtyday
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        99 / screenWidth, 117 / screenHeight, 0, 0),
                    child: Row(
                      children: [
                        // 아이생일
                        Text(
                          "아이생일",
                          style: TextStyle(
                              fontSize: 57 / screenWidth,
                              color: Color.fromARGB(255, 255, 114, 148),
                              fontFamily: 'NotoSansCJKkr_Medium'),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                                82 / screenWidth, 0, 118 / screenWidth, 0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: yearPicker,
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: yController,
                                      onChanged: (txt) {
                                        setState(() {
                                          birthday = txt;
                                        });
                                      },
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Color(0xffff7292),
                                          fontSize: 73 / screenWidth,
                                          fontFamily: 'NotoSansCJKkr_Medium',
                                          fontStyle: FontStyle.normal,
                                          letterSpacing: -1.0),
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color(0xffff7292),
                                          ),
                                          //Color.fromRGBO(255, 114, 148, 1.0)
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffff7292)),
                                        ),
                                        hintText: '생년월일을 선택해주세요',
                                        hintStyle: TextStyle(
                                            color: const Color(0xffff7292),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "NotoSansCJKkr",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 66.0 / screenWidth),
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      yearPicker();
                                    },
                                    icon: Image.asset(
                                      './assets/registrationPage/calendar.png',
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, 98 / screenHeight, 0, 0 / screenHeight),
                  ),
                  //Parental age group

                  Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 147 / screenWidth)),
                        Text(
                          "보호자\n 연령대",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 57 / screenWidth,
                              color: Color.fromARGB(255, 255, 114, 148),
                              fontFamily: 'NotoSansCJKkr_Medium'),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 62 / screenWidth)),
                        InkWell(
                          child: Image.asset(
                            changeimage[0]
                                ? './assets/registrationPage/10_pink.png'
                                : './assets/registrationPage/10_grey.png',
                            height: 196 / screenHeight,
                            width: 251 / screenWidth,
                          ),
                          onTap: () {
                            _change('10');
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 55 / screenWidth)),
                        InkWell(
                          child: Image.asset(
                            changeimage[1]
                                ? './assets/registrationPage/20_pink.png'
                                : './assets/registrationPage/20_grey.png',
                            height: 196 / screenHeight,
                            width: 251 / screenWidth,
                          ),
                          onTap: () {
                            _change('20');
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 55 / screenWidth)),
                        InkWell(
                          child: Image.asset(
                            changeimage[2]
                                ? './assets/registrationPage/30_pink.png'
                                : './assets/registrationPage/30_grey.png',
                            height: 196 / screenHeight,
                            width: 251 / screenWidth,
                          ),
                          onTap: () {
                            _change('30');
                          },
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 25 / screenWidth)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 147 / screenWidth)),
                        Text(
                          "보호자\n 연령대",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 57 / screenWidth,
                              color: Colors.transparent,
                              fontFamily: 'NotoSansCJKkr_Medium'),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 62 / screenWidth)),
                        InkWell(
                          child: Image.asset(
                            changeimage[3]
                                ? './assets/registrationPage/40_pink.png'
                                : './assets/registrationPage/40_grey.png',
                            height: 196 / screenHeight,
                            width: 251 / screenWidth,
                          ),
                          onTap: () {
                            _change('40');
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 55 / screenWidth)),
                        InkWell(
                          child: Image.asset(
                            changeimage[4]
                                ? './assets/registrationPage/50_pink.png'
                                : './assets/registrationPage/50_grey.png',
                            height: 196 / screenHeight,
                            width: 251 / screenWidth,
                          ),
                          onTap: () {
                            _change('50');
                          },
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 55 / screenWidth)),
                        InkWell(
                          child: Image.asset(
                            changeimage[5]
                                ? './assets/registrationPage/others_pink.png'
                                : './assets/registrationPage/others_grey.png',
                            height: 196 / screenHeight,
                            width: 251 / screenWidth,
                          ),
                          onTap: () {
                            _change('ohters');
                          },
                        ),
                      ],
                    ),
                  ]),
                  Padding(padding: EdgeInsets.only(top: 125 / screenHeight)),

                  //ok button
                  Container(
                    width: 1200 / screenWidth,
                    height: 194 / screenHeight,
                    // margin: EdgeInsets.only(bottom: 70/(2667/ScreenHeight)),
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      onPressed: isIdValid &&
                              userAge != "" &&
                              birthday != "" &&
                              birthday != "" &&
                              nickName != ""
                          ? () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              await prefs.setString('uahageUserId', userId);
                              await prefs.setString(
                                  "uahageLoginOption", loginOption);
                              showDialog(
                                context: context,
                                builder: (context) => FutureBuilder(
                                    future: saveToDatabase("withNickname"),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          title: // 사용 가능한 닉네임입니다.
                                              Text(snapshot.data,
                                                  style: TextStyle(
                                                      color: const Color(
                                                          0xff4d4d4d),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily:
                                                          "NotoSansCJKkr_Medium",
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      fontSize:
                                                          62.5 / screenWidth),
                                                  textAlign: TextAlign.left),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  saveError
                                                      ? null
                                                      : Navigator
                                                          .pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => navigationPage(
                                                                    oldNickname:
                                                                        nickName,
                                                                    userId:
                                                                        userId,
                                                                    loginOption:
                                                                        loginOption),
                                                              ));
                                                },
                                                child: // 확인
                                                    buildText(_fontsize))
                                          ],
                                        );
                                      } else if (snapshot.hasError)
                                        return buildAlertDialog(snapshot,
                                            screenWidth, context, _fontsize);

                                      return buildCenterProgress(
                                          screenHeight, screenWidth);
                                    }),
                              );
                            }
                          : () {},
                      color: isIdValid &&
                              userAge != "" &&
                              birthday != "" &&
                              birthday != "" &&
                              nickName != ""
                          ? Color(0xffff7292)
                          : Color(0xffcccccc),
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'NotoSansCJKkr_Medium',
                          fontSize: 57 / screenWidth,
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 200 / screenHeight)),

                  //next
                  Center(
                    child: FlatButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        await prefs.setString('uahageUserId', userId);
                        await prefs.setString("uahageLoginOption", loginOption);
                        showDialog(
                          context: context,
                          builder: (context) => FutureBuilder(
                            future: saveToDatabase(""),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0))),
                                  title: // 사용 가능한 닉네임입니다.
                                      Text(snapshot.data,
                                          style: TextStyle(
                                              color: const Color(0xff4d4d4d),
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  "NotoSansCJKkr_Medium",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 62.5 / screenWidth),
                                          textAlign: TextAlign.left),
                                  actions: [
                                    FlatButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          if (!saveError) {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();

                                            await prefs.setString(
                                                'uahageUserId', userId);
                                            await prefs.setString(
                                                "uahageLoginOption",
                                                loginOption);
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    navigationPage(
                                                        userId: userId,
                                                        loginOption:
                                                            loginOption),
                                              ),
                                            );
                                          }
                                        },
                                        child: // 확인
                                            buildText(_fontsize))
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                buildAlertDialog(
                                    snapshot, screenWidth, context, _fontsize);
                              }
                              return buildCenterProgress(
                                  screenHeight, screenWidth);
                            },
                          ),
                        );
                      },
                      child: Text(
                        "건너뛰기",
                        style: TextStyle(
                          color: Color.fromRGBO(255, 114, 148, 1.0),
                          fontFamily: 'NotoSansCJKkr_Medium',
                          fontSize: 57 / screenWidth,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(180 / screenHeight),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Color.fromRGBO(255, 114, 148, 1.0),
                  centerTitle: true,
                  title: Text(
                    "회원가입",
                    style: TextStyle(
                      fontSize: 73 / screenWidth,
                      fontFamily: 'NotoSansCJKkr_Bold',
                      letterSpacing: 0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    //custom appbar
                    // Container(
                    //     alignment: Alignment(0.0, 0.0),
                    //     color: Color.fromARGB(255, 255, 114, 148),
                    //     width: MediaQuery.of(context).size.width,
                    //     height: 178 / screenHeight,
                    //     child: Text(
                    //       "회원가입",
                    //       style: TextStyle(
                    //         fontSize: 73 / screenWidth,
                    //         color: Colors.white,
                    //         fontFamily: 'NotoSansCJKkr_Bold',
                    //       ),
                    //     )),

                    Padding(padding: EdgeInsets.only(top: 250 / screenHeight)),

                    //membership_Nickname

                    Container(
                      child: Container(
                        child: Row(
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 150 / screenWidth)),
                            Text(
                              "닉네임",
                              style: TextStyle(
                                  fontSize: 57 / screenWidth,
                                  color: Color.fromARGB(255, 255, 114, 148),
                                  fontFamily: 'NotoSansCJKkr_Medium'),
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(left: 88 / screenWidth)),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: 121 / screenWidth,
                                ),
                                child: Stack(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) {
                                        setState(() {
                                          nickName = value;
                                        });
                                      },
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: const Color(0xff3a3939),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "NotoSansCJKkr_Bold",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 62.5 / screenWidth,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            right: 410 / screenWidth),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: const Color(0xffff7292),
                                          ),

                                          //Color.fromRGBO(255, 114, 148, 1.0)
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xffff7292)),
                                        ),
                                        hintText: '닉네임를 입력하세요',
                                        hintStyle: TextStyle(
                                            color: Color(0xffcccccc),
                                            fontSize: 57 / screenWidth,
                                            letterSpacing: -1.0),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        width: 350 / screenWidth,
                                        height: 143 / screenHeight,
                                        child: FlatButton(
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(8.0),
                                          ),
                                          onPressed: nickName != ""
                                              ? () {
                                                  currentFocus.unfocus();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        FutureBuilder(
                                                            future:
                                                                checkNickname(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                  .hasData) {
                                                                return AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20.0))),
                                                                  title: // 사용 가능한 닉네임입니다.
                                                                      Text(
                                                                          snapshot
                                                                              .data,
                                                                          style: TextStyle(
                                                                              color: const Color(0xff4d4d4d),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "NotoSansCJKkr_Medium",
                                                                              fontStyle: FontStyle.normal,
                                                                              fontSize: 62.5 / screenWidth),
                                                                          textAlign: TextAlign.left),
                                                                  actions: [
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: // 확인
                                                                            buildText(_fontsize))
                                                                  ],
                                                                );
                                                              } else if (snapshot
                                                                  .hasError)
                                                                return AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20.0))),
                                                                  title:
                                                                      // id already exists.
                                                                      Text(
                                                                          snapshot
                                                                              .error,
                                                                          style: TextStyle(
                                                                              color: Color(0xff4d4d4d),
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "NotoSansCJKkr_Medium",
                                                                              fontStyle: FontStyle.normal,
                                                                              fontSize: 62.5 / screenWidth),
                                                                          textAlign: TextAlign.left),
                                                                  actions: [
                                                                    FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: // 확인
                                                                            buildText(_fontsize))
                                                                  ],
                                                                );

                                                              return Center(
                                                                child: SizedBox(
                                                                    height: 200 /
                                                                        screenHeight,
                                                                    width: 200 /
                                                                        screenWidth,
                                                                    child: buildSpinKitThreeBounce(
                                                                        80,
                                                                        screenWidth)
                                                                    //     CircularProgressIndicator(
                                                                    //   strokeWidth:
                                                                    //       5.0,
                                                                    //   valueColor:
                                                                    //       new AlwaysStoppedAnimation<
                                                                    //           Color>(
                                                                    //     Colors
                                                                    //         .pinkAccent,
                                                                    //   ),
                                                                    // )
                                                                    ),
                                                              );
                                                            }),
                                                  );
                                                }
                                              : () {},
                                          color: nickName == ""
                                              ? Color(0xffcacaca)
                                              : Color(0xffff7292),
                                          child: Text(
                                            "중복확인",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily:
                                                  'NotoSansCJKkr_Medium',
                                              fontSize: 50 / screenWidth,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 76 / screenHeight)),

                    //baby_Gender
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 91 / screenWidth)),
                          Container(
                            child: Text(
                              "아이성별",
                              style: TextStyle(
                                  fontSize: 57 / screenWidth,
                                  color: Color.fromARGB(255, 255, 114, 148),
                                  fontFamily: 'NotoSansCJKkr_Medium'),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 80 / screenWidth)),
                          InkWell(
                            onTap: () {
                              _pressedbaby('boy');
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 364 / screenHeight,
                                child: Image.asset(
                                    boy ? boy_image[0] : boy_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 98 / screenWidth)),
                          InkWell(
                            onTap: () {
                              _pressedbaby('girl');
                            },
                            child: Column(children: <Widget>[
                              Container(
                                height: 364 / screenHeight,
                                child: Image.asset(
                                    girl ? girl_image[0] : girl_image[1]),
                              ),
                              Padding(padding: EdgeInsets.only(bottom: 11)),
                            ]),
                          ),
                        ]),

                    //baby_birtyday
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          99 / screenWidth, 117 / screenHeight, 0, 0),
                      child: Row(
                        children: [
                          // 아이생일
                          Text(
                            "아이생일",
                            style: TextStyle(
                                fontSize: 57 / screenWidth,
                                color: Color.fromARGB(255, 255, 114, 148),
                                fontFamily: 'NotoSansCJKkr_Medium'),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  82 / screenWidth, 0, 118 / screenWidth, 0),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: yearPicker,
                                    child: AbsorbPointer(
                                      child: TextFormField(
                                        controller: yController,
                                        // onChanged: (txt) {
                                        //   setState(() {
                                        //     birthday = txt;
                                        //   });
                                        // },
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(0xffff7292),
                                            fontSize: 73 / screenWidth,
                                            fontFamily: 'NotoSansCJKkr_Medium',
                                            fontStyle: FontStyle.normal,
                                            letterSpacing: -1.0),
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: const Color(0xffff7292),
                                            ),
                                            //Color.fromRGBO(255, 114, 148, 1.0)
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xffff7292)),
                                          ),
                                          hintText: '생년월일을 선택해주세요',
                                          hintStyle: TextStyle(
                                              color: Color(0xffd4d4d4),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "NotoSansCJKkr",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 66.0 / screenWidth),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () {
                                        yearPicker();
                                      },
                                      icon: Image.asset(
                                        './assets/registrationPage/calendar.png',
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, 98 / screenHeight, 0, 0 / screenHeight),
                    ),
                    //Parental age group

                    Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 147 / screenWidth)),
                          Text(
                            "보호자\n 연령대",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 57 / screenWidth,
                                color: Color.fromARGB(255, 255, 114, 148),
                                fontFamily: 'NotoSansCJKkr_Medium'),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 62 / screenWidth)),
                          InkWell(
                            child: Image.asset(
                              changeimage[0]
                                  ? './assets/registrationPage/10_pink.png'
                                  : './assets/registrationPage/10_grey.png',
                              height: 196 / screenHeight,
                              width: 251 / screenWidth,
                            ),
                            onTap: () {
                              _change('10');
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 55 / screenWidth)),
                          InkWell(
                            child: Image.asset(
                              changeimage[1]
                                  ? './assets/registrationPage/20_pink.png'
                                  : './assets/registrationPage/20_grey.png',
                              height: 196 / screenHeight,
                              width: 251 / screenWidth,
                            ),
                            onTap: () {
                              _change('20');
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 55 / screenWidth)),
                          InkWell(
                            child: Image.asset(
                              changeimage[2]
                                  ? './assets/registrationPage/30_pink.png'
                                  : './assets/registrationPage/30_grey.png',
                              height: 196 / screenHeight,
                              width: 251 / screenWidth,
                            ),
                            onTap: () {
                              _change('30');
                            },
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 25 / screenWidth)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding:
                                  EdgeInsets.only(left: 147 / screenWidth)),
                          Text(
                            "보호자\n 연령대",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 57 / screenWidth,
                                color: Colors.transparent,
                                fontFamily: 'NotoSansCJKkr_Medium'),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 62 / screenWidth)),
                          InkWell(
                            child: Image.asset(
                              changeimage[3]
                                  ? './assets/registrationPage/40_pink.png'
                                  : './assets/registrationPage/40_grey.png',
                              height: 196 / screenHeight,
                              width: 251 / screenWidth,
                            ),
                            onTap: () {
                              _change('40');
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 55 / screenWidth)),
                          InkWell(
                            child: Image.asset(
                              changeimage[4]
                                  ? './assets/registrationPage/50_pink.png'
                                  : './assets/registrationPage/50_grey.png',
                              height: 196 / screenHeight,
                              width: 251 / screenWidth,
                            ),
                            onTap: () {
                              _change('50');
                            },
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 55 / screenWidth)),
                          InkWell(
                            child: Image.asset(
                              changeimage[5]
                                  ? './assets/registrationPage/others_pink.png'
                                  : './assets/registrationPage/others_grey.png',
                              height: 196 / screenHeight,
                              width: 251 / screenWidth,
                            ),
                            onTap: () {
                              _change('ohters');
                            },
                          ),
                        ],
                      ),
                    ]),
                    Padding(padding: EdgeInsets.only(top: 125 / screenHeight)),

                    //ok button
                    Container(
                      width: 1200 / screenWidth,
                      height: 194 / screenHeight,
                      // margin: EdgeInsets.only(bottom: 70/(2667/ScreenHeight)),
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                        onPressed: isIdValid &&
                                userAge != "" &&
                                birthday != "" &&
                                birthday != "" &&
                                nickName != ""
                            ? () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                await prefs.setString('uahageUserId', userId);
                                await prefs.setString(
                                    "uahageLoginOption", loginOption);
                                showDialog(
                                  context: context,
                                  builder: (context) => FutureBuilder(
                                      future: saveToDatabase("withNickname"),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) async {
                                            Navigator.pop(context);
                                            saveError
                                                ? null
                                                : Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          navigationPage(
                                                              oldNickname:
                                                                  nickName,
                                                              userId: userId,
                                                              loginOption:
                                                                  loginOption),
                                                    ));
                                          });
                                        } else if (snapshot.hasError)
                                          return buildAlertDialog(snapshot,
                                              screenWidth, context, _fontsize);

                                        return buildCenterProgress(
                                            screenHeight, screenWidth);
                                      }),
                                );
                              }
                            : () {},
                        color: isIdValid &&
                                userAge != "" &&
                                birthday != "" &&
                                birthday != "" &&
                                nickName != ""
                            ? Color(0xffff7292)
                            : Color(0xffcccccc),
                        child: Text(
                          "OK",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'NotoSansCJKkr_Medium',
                            fontSize: 57 / screenWidth,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 200 / screenHeight)),

                    //next
                    Center(
                      child: FlatButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          await prefs.setString('uahageUserId', userId);
                          await prefs.setString(
                              "uahageLoginOption", loginOption);
                          showDialog(
                            context: context,
                            builder: (context) => FutureBuilder(
                              future: saveToDatabase(""),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    Navigator.pop(context);
                                    if (!saveError) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      await prefs.setString(
                                          'uahageUserId', userId);
                                      await prefs.setString(
                                          "uahageLoginOption", loginOption);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => navigationPage(
                                              userId: userId,
                                              loginOption: loginOption),
                                        ),
                                      );
                                    }
                                  });
                                } else if (snapshot.hasError) {
                                  buildAlertDialog(snapshot, screenWidth,
                                      context, _fontsize);
                                }
                                return buildCenterProgress(
                                    screenHeight, screenWidth);
                              },
                            ),
                          );
                        },
                        child: Text(
                          "건너뛰기",
                          style: TextStyle(
                            color: Color.fromRGBO(255, 114, 148, 1.0),
                            fontFamily: 'NotoSansCJKkr_Medium',
                            fontSize: 57 / screenWidth,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  Center buildCenterProgress(double screenHeight, double screenWidth) {
    return Center(
      child: SizedBox(
          height: 200 / screenHeight,
          width: 200 / screenWidth,
          child: buildSpinKitThreeBounce(80, screenWidth)
          // CircularProgressIndicator(
          //   strokeWidth: 5.0,
          //   valueColor: new AlwaysStoppedAnimation<Color>(
          //     Colors.pinkAccent,
          //   ),
          // )
          ),
    );
  }

  AlertDialog buildAlertDialog(AsyncSnapshot snapshot, double screenWidth,
      BuildContext context, double _fontsize) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title:
          // id already exists.
          Text(snapshot.error,
              style: TextStyle(
                  color: Color(0xff4d4d4d),
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansCJKkr_Medium",
                  fontStyle: FontStyle.normal,
                  fontSize: 62.5 / screenWidth),
              textAlign: TextAlign.left),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: // 확인
                buildText(_fontsize))
      ],
    );
  }

  Text buildText(double _fontsize) {
    return Text("확인",
        style: TextStyle(
            color: const Color(0xffff7292),
            fontWeight: FontWeight.w500,
            fontFamily: "NotoSansCJKkr_Medium",
            fontStyle: FontStyle.normal,
            fontSize: _fontsize),
        textAlign: TextAlign.center);
  }

  //gender event
  _pressedbaby(String value) {
    print(value);
    print(boy);
    if (value == 'boy') {
      if (boy) {
        setState(() {
          gender = value;
          boy = false;
          girl = true;
        });
      }
    }
    if (value == 'girl') {
      if (girl) {
        setState(() {
          gender = value;
          girl = false;
          boy = true;
        });
      }
    }
  }

  //picker(캘린더)
  yearPicker() {
    final year = DateTime.now().year;
    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    // double screenWidth = 1501 / MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: Text(
            '생년월일을 입력하세요',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(255, 114, 148, 1.0),
              fontSize: 56 / screenHeight,
            ),
            textAlign: TextAlign.center,
          ),
          content: Container(
              height: MediaQuery.of(context).size.height / 5.0,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) async {
                  var datee = newDate.toString().substring(0, 10).split('-');
                  yController.text =
                      datee[0] + "년 " + datee[1] + "월 " + datee[2] + "일";
                },
                minimumYear: 2000,
                maximumYear: year,
                mode: CupertinoDatePickerMode.date,
              )),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '확인',
                style: TextStyle(
                  color: Color.fromRGBO(255, 114, 148, 1.0),
                  fontFamily: 'NotoSansCJKkr_Medium',
                  fontSize: 57 / screenHeight,
                ),
              ),
              onPressed: () {
                setState(() {
                  birthday = yController.text;
                  Navigator.of(context).pop();
                });
              },
            ),
            // FlatButton(
            //   child: Text(
            //     '아니요',
            //     style: TextStyle(
            //       color: Color.fromRGBO(255, 114, 148, 1.0),
            //       fontFamily: 'NotoSansCJKkr_Medium',
            //       fontSize: 57 / screenHeight,
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
          ],
        );
      },
    );
  }

  //changimagecolor
  void _change(String age) {
    if (age == '10') {
      setState(() {
        userAge = "10";
        changeimage[0] = true;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '20') {
      setState(() {
        userAge = "20";
        changeimage[0] = false;
        changeimage[1] = true;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '30') {
      setState(() {
        userAge = "30";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = true;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '40') {
      setState(() {
        userAge = "40";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = true;
        changeimage[4] = false;
        changeimage[5] = false;
      });
    } else if (age == '50') {
      setState(() {
        userAge = "50";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = true;
        changeimage[5] = false;
      });
    } else {
      setState(() {
        userAge = ">60";
        changeimage[0] = false;
        changeimage[1] = false;
        changeimage[2] = false;
        changeimage[3] = false;
        changeimage[4] = false;
        changeimage[5] = true;
      });
    }
  }
}
