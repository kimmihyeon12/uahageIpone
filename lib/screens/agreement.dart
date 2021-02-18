import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:uahage/NavigationPage/Navigationbar.dart';
import 'package:uahage/screens/announce.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'registrationPage.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;

class agreementPage extends StatefulWidget {
  agreementPage({Key key, this.loginOption}) : super(key: key);

  final String loginOption;
  @override
  _agreementPageState createState() => _agreementPageState();
}

class _agreementPageState extends State<agreementPage> {
  //kakao login----------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------
  bool _isKakaoTalkInstalled = false;
  String _accountEmail;
  String _ageRange;
  String _gender;
  bool isAlreadyRegistered = false;

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    print('kakao Install : ' + installed.toString());

    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  Future checkNickname() async {
    var data;
    try {
      var response = await http
          .get("http://13.209.41.43/getEmail?email=$_accountEmail$loginOption");
      print("length " + response.body);
      if (response.statusCode == 200) {
        data = jsonDecode(response.body)["length"];

        setState(() {
          data == 1 ? isAlreadyRegistered = true : isAlreadyRegistered = false;
        });
      }
      // else {
      //   data = jsonDecode(response.body)["message"];

      //   return data;
      // }
    } catch (err) {
      // print(err);
      return data["message"];
    }
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode);
      AccessTokenStore.instance.toStore(token);

      await _initTexts();
      // await _create();
      // await _saveUserId();
      await checkNickname();
      if (isAlreadyRegistered) {
        await _saveUserId();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => navigationPage(
                  userId: _accountEmail, loginOption: loginOption),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => registrationPage(
                userId: _accountEmail,
                loginOption: loginOption,
              ),
            ));
      }
      //push는 쌓임 , pushreplacement는 교체!
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.request();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  Future _loginWithTalk() async {
    try {
      var code = await AuthCodeClient.instance.requestWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  //kakao 자동 login
  // _create() async {
  //   String id = jsonEncode(_accountEmail);
  //   print(id);
  //   // To save database HERE
  // }

  _initTexts() async {
    final User user = await UserApi.instance.me();

    print(
        "=========================[kakao account]=================================");
    print(user.kakaoAccount.toString());
    print(
        "=========================[kakao account]=================================");

    setState(() {
      _accountEmail = user.kakaoAccount.email;
      _ageRange = user.kakaoAccount.ageRange.toString();
      _gender = user.kakaoAccount.gender.toString();
    });
  }

  // _accounteamail 내부 db 저장
  _saveUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uahageUserId', _accountEmail);
    await prefs.setString("uahageLoginOption", loginOption);
    // setState(() {
    //   //userId = (prefs.getString('userId') ?? "");

    // });
  }

  // ************************************Naver Login ******************
  var accesToken;
  var tokenType;
  Future naverLogin() async {
    try {
      await FlutterNaverLogin.logIn();
      NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;
      setState(() {
        accesToken = res.accessToken;
        tokenType = res.tokenType;
      });
      NaverAccountResult resAccount = await FlutterNaverLogin.currentAccount();
      setState(() {
        _accountEmail = resAccount.email;
      });
      print(_accountEmail);
      // await _saveUserId();
      await checkNickname();
      // create database
      if (isAlreadyRegistered) {
        await _saveUserId();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => navigationPage(
                    userId: _accountEmail,
                    loginOption: loginOption,
                  )),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => registrationPage(
                    userId: _accountEmail,
                    loginOption: loginOption,
                  )),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  String loginOption = "";

  @override
  void initState() {
    super.initState();

    setState(() {
      loginOption = widget.loginOption;
    });
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  bool isAllSelected = false;
  bool check1 = false;
  bool check2 = false;
  bool check3 = false;
  bool check4 = false;
  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = "581f27a7aed8a99e5b0a78b33c855dab";

    double screenHeight = 2667 / MediaQuery.of(context).size.height;
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    if (check2 && check3 && check4) {
      setState(() {
        check1 = true;
      });
    } else {
      setState(() {
        check1 = false;
      });
    }
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // head
              Container(
                height: 178 / screenHeight,
                width: 1501 / screenWidth,
                color: Color(0xffff7292),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Container(
                        height: 76 / screenHeight,
                        width: 43 / screenWidth,
                        margin: EdgeInsets.only(left: 31 / screenWidth),
                        child: Image.asset("./assets/agreementPage/back.png"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 424 / screenWidth),
                      child: // 약관동의
                          Text("약관동의",
                              style: TextStyle(
                                  color: const Color(0xffffffff),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "NotoSansCJKkr_Bold",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 75 / screenWidth),
                              textAlign: TextAlign.left),
                    ),
                  ],
                ),
              ),

              // Title

              Container(
                margin: EdgeInsets.only(top: 441 / screenHeight),
                child: // 서비스 약관에 동의해주세요.
                    Text("서비스 약관에 동의해주세요.",
                        style: TextStyle(
                            color: const Color(0xffff7292),
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSansCJKkr_Bold",
                            fontStyle: FontStyle.normal,
                            fontSize: 78 / screenWidth),
                        textAlign: TextAlign.left),
              ),

              // Agreement
              Container(
                margin: EdgeInsets.only(top: 156 / screenHeight),
                width: 1296 / screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  border: Border.all(width: 0.1),
                ),
                child: // 모두 동의합니다.
                    Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91 / screenHeight,
                          margin: EdgeInsets.only(
                              left: 37 / screenWidth,
                              top: 65 / screenHeight,
                              bottom: 65 / screenHeight),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                check1 = check2 = check3 = check4 = !check1;
                              });
                            },
                            child: check1
                                ? Image.asset(
                                    "./assets/agreementPage/checked.png")
                                : Image.asset(
                                    "./assets/agreementPage/unchecked.png"),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            left: 30 / screenWidth,
                          ),
                          child: Text("모두 동의합니다.",
                              style: TextStyle(
                                  color: const Color(0xff000000),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "NotoSansCJKkr_Bold",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 62.5 / screenWidth),
                              textAlign: TextAlign.left),
                        ),
                      ],
                    ),
                    Divider(
                        thickness: 0.1, height: 0, color: Color(0xff000000)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91 / screenHeight,
                          margin: EdgeInsets.only(
                              left: 37 / screenWidth,
                              top: 65 / screenHeight,
                              bottom: 65 / screenHeight),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  check2 = !check2;
                                });
                              },
                              child: check2
                                  ? Image.asset(
                                      "./assets/agreementPage/checked.png")
                                  : Image.asset(
                                      "./assets/agreementPage/unchecked.png")),
                        ),
                        Container(
                          width: 1100 / screenWidth,
                          margin:
                              EdgeInsets.only(left: 34 / screenWidth, right: 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => announce()),
                              );
                            },
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("[필수] 이용약관 동의",
                                    style: TextStyle(
                                        color: const Color(0xff666666),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 62.5 / screenWidth),
                                    textAlign: TextAlign.left),
                                Container(
                                  height: 74 / screenHeight,
                                  margin:
                                      EdgeInsets.only(right: 20 / screenWidth),
                                  child: Image.asset(
                                      "./assets/agreementPage/next.png"),
                                ),
                              ],
                            ),
                          ), // [필수] 이용약관 동의
                        ),
                      ],
                    ),
                    Divider(
                        thickness: 0.2, height: 0, color: Color(0xff000000)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91 / screenHeight,
                          margin: EdgeInsets.only(
                              left: 37 / screenWidth,
                              top: 65 / screenHeight,
                              bottom: 65 / screenHeight),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  check3 = !check3;
                                });
                              },
                              child: check3
                                  ? Image.asset(
                                      "./assets/agreementPage/checked.png")
                                  : Image.asset(
                                      "./assets/agreementPage/unchecked.png")),
                        ),
                        Container(
                          width: 1100 / screenWidth,
                          margin:
                              EdgeInsets.only(left: 34 / screenWidth, right: 0),
                          child: // [필수] 이용약관 동의
                              InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => announce()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("[필수] 개인정보처리방침 동의",
                                    style: TextStyle(
                                        color: const Color(0xff666666),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 62.5 / screenWidth),
                                    textAlign: TextAlign.left),
                                Container(
                                  height: 74 / screenHeight,
                                  margin:
                                      EdgeInsets.only(right: 20 / screenWidth),
                                  child: Image.asset(
                                      "./assets/agreementPage/next.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                        thickness: 0.1, height: 0, color: Color(0xff000000)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 91 / screenHeight,
                          margin: EdgeInsets.only(
                              left: 37 / screenWidth,
                              top: 65 / screenHeight,
                              bottom: 65 / screenHeight),
                          child: InkWell(
                              onTap: () {
                                setState(() {
                                  check4 = !check4;
                                });
                              },
                              child: check4
                                  ? Image.asset(
                                      "./assets/agreementPage/checked.png")
                                  : Image.asset(
                                      "./assets/agreementPage/unchecked.png")),
                        ),
                        Container(
                          width: 1100 / screenWidth,
                          margin: EdgeInsets.only(
                            left: 34 / screenWidth,
                          ),
                          child: // [필수] 이용약관 동의
                              InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => announce()),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("[필수] 위치기반서비스 이용약관 동의",
                                    style: TextStyle(
                                        color: const Color(0xff666666),
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 62.5 / screenWidth),
                                    textAlign: TextAlign.left),
                                Container(
                                  height: 74 / screenHeight,
                                  margin:
                                      EdgeInsets.only(right: 20 / screenWidth),
                                  child: Image.asset(
                                      "./assets/agreementPage/next.png"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Ok button
              Container(
                margin: EdgeInsets.only(top: 243 / screenHeight),
                child: SizedBox(
                  height: 194 / screenHeight,
                  width: 1193 / screenWidth,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    color: check1 ? const Color(0xffff7292) : Color(0xffcacaca),
                    onPressed: () {
                      if (!check1) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: // 이용약관에 동의하셔야 합니다.
                                Text("이용약관에 동의하셔야 합니다.",
                                    style: TextStyle(
                                        color: const Color(0xff4d4d4d),
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
                                      Text("확인",
                                          style: TextStyle(
                                              color: const Color(0xffff7292),
                                              fontWeight: FontWeight.w500,
                                              fontFamily:
                                                  "NotoSansCJKkr_Medium",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 62.5 / screenWidth),
                                          textAlign: TextAlign.center))
                            ],
                          ),
                        );
                      } else {
                        print(loginOption);
                        switch (loginOption) {
                          case "kakao":
                            _initKakaoTalkInstalled();
                            if (_isKakaoTalkInstalled)
                              showDialog(
                                context: context,
                                builder: (ctx) => FutureBuilder(
                                  future: _loginWithTalk(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return AlertDialog(
                                        title: Text(snapshot.data),
                                      );
                                    } else if (snapshot.hasError) {
                                      return AlertDialog(
                                          title: Text(snapshot.error));
                                    }
                                    return Center(
                                      child: SizedBox(
                                          height: 200 / screenHeight,
                                          width: 200 / screenWidth,
                                          child: buildSpinKitThreeBounce(
                                              80, screenWidth)),
                                    );
                                  },
                                ),
                              );
                            else {
                              _loginWithKakao();
                            }
                            break;
                          case "naver":
                            naverLogin();
                            break;
                          case "login":
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      navigationPage(loginOption: loginOption)),
                            );
                            break;
                          default:
                            break;
                        }
                      }
                    },
                    child: // 중복확인
                        Text("OK",
                            style: TextStyle(
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.w500,
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontStyle: FontStyle.normal,
                                fontSize: 62.5 / screenWidth),
                            textAlign: TextAlign.left),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
