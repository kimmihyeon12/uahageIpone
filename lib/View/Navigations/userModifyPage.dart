import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uahage/Widget/toast.dart';
import 'package:uahage/Widget/showDialog.dart';

class UserModify extends StatefulWidget {
  final loginOption;
  final userId;
  final dynamic recievedImage;
  const UserModify({Key key, this.loginOption, this.userId, this.recievedImage})
      : super(key: key);
  @override
  _UserModifyState createState() => _UserModifyState();
}

class _UserModifyState extends State<UserModify> {
  TextEditingController yController = TextEditingController();

  String birthday = "";
  String nickName = "";
  String oldNickname = "";
  String userId = "";
  String year, month, yearMonthDay, yearMonthDayTime;
  var changeimage = [false, false, false, false, false, false];
  var genderImage = [false, false];
  bool isIdValid = false;
  String loginOption = "";
  String gender = "";
  String userAge = "";
  String _uploadedFileURL = "";
  File _image;
  String imageLink = "";
  bool isIOS = Platform.isIOS;
  dynamic recievedImage;

  toast show_toast = new toast();
  Future checkNickname() async {
    var data;
    print("nick in func: $nickName");
    try {
      var response =
          await http.get("http://211.223.46.144:3000/getNicknames/$nickName");
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
      return err["message"];
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Color.fromRGBO(255, 114, 148, 1.0),
                      ),
                      title: new Text('겔러리'),
                      onTap: () async {
                        await _imgFromGallery();
                        // print("Calling upload func");

                        // print(_uploadedFileURL);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(
                      Icons.photo_camera,
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                    title: new Text('카메라'),
                    onTap: () async {
                      await _imgFromCamera();
                      // print("Calling upload func");

                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                    leading: new Icon(
                      Icons.delete_rounded,
                      color: Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                    title: new Text('삭제'),
                    onTap: () async {
                      await deleteFile();
                      setState(() {
                        _image = null;
                        imageLink = "";
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future deleteFile() async {
    try {
      await http
          .put(
            "http://211.223.46.144:3000/updateImage/$userId$loginOption",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"URL": ""}),
          )
          .then((value) => print(value.body))
          .catchError((err) => print(err));
    } catch (error) {}
  }

  Future _imgFromCamera() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 20);

    setState(() {
      recievedImage = null;
      _image = File(image.path);
    });
    await uploadFile(_image);
  }

  Future _imgFromGallery() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 20);

    setState(() {
      // recievedImage = null;
      _image = File(image.path);
      recievedImage = null;
    });
  }

  uploadFile(File file) async {
    if (imageLink != "") {
      try {
        // print(ss);
        await http.post(
          "http://211.223.46.144:3000/api/profile/deleteImage",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"fileName": imageLink}),
        );
      } catch (err) {
        print(err);
      }
    }

    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profileImage":
            await MultipartFile.fromFile(file.path, filename: fileName),
      });
      Dio dio = new Dio();
      var response;
      try {
        response = await dio.post(
            'http://211.223.46.144:3000/api/profile/imgUpload/$userId$loginOption',
            data: formData);
        setState(() {
          _uploadedFileURL = response.data["location"];
          imageLink = _uploadedFileURL;
        });
        print("Printing after upload imagelink " + _uploadedFileURL);
        await _saveURL(_uploadedFileURL);
      } catch (err) {
        print(err);
      }
    } catch (err) {
      print(err);
    }
  }

  _saveURL(_uploadedFileURL) async {
    try {
      await http
          .put(
            "http://211.223.46.144:3000/updateImage/$userId$loginOption",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"URL": _uploadedFileURL}),
          )
          .then((value) => print(value.body))
          .catchError((err) => print(err));
    } catch (error) {}
  }

  Future updateNickname() async {
    Map<String, dynamic> ss = {
      "userId": userId + loginOption,
      // "oldNickname": oldNickname,
      "gender": gender,
      "birthday": birthday,
      "age": userAge,
    };
    print(ss);
    var response = await http.post(
      "http://211.223.46.144:3000/updateNickname/$nickName",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
    return jsonDecode(response.body)["message"];
  }

  @override
  void initState() {
    super.initState();
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    recievedImage = widget.recievedImage ?? null;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 2435, height: 5075);
    FocusScopeNode currentFocus = FocusScope.of(context);
    isIOS
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
            .copyWith(
                statusBarBrightness:
                    Brightness.dark // Dark == white status bar -- for IOS.
                ))
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            systemNavigationBarColor: Color(0xffd9d4d5), // navigation bar color
            statusBarColor: Color(0xffd9d4d5), // status bar color
          ));
    var _fontsize = 52.5.sp;

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.fromLTRB(60.w, 80.h, 0, 0),
                    child: InkWell(
                      onTap: () async {
                        Navigator.pop(context, false);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "./assets/myPage/back.png",
                            width: 96.w,
                            height: 76.h,
                          ),
                          // 내 정보
                          Container(
                            margin: EdgeInsets.only(left: 33.w),
                            child: Text("내 정보",
                                style: TextStyle(
                                  color: Color.fromRGBO(255, 114, 148, 1.0),
                                  fontFamily: 'NotoSansCJKkr_Medium',
                                  fontSize: 96.sp,
                                ),
                                textAlign: TextAlign.left),
                          ),

                          //
                        ],
                      ),
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 520.h, 0, 0),
                  child: Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 684.h,
                          width: 684.w,
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("./assets/myPage/avatar.png"),
                            child: (() {
                              // your code here
                              if (recievedImage != null) {
                                if (recievedImage is String) {
                                  setState(() {
                                    imageLink = recievedImage;
                                  });

                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              recievedImage), //imageURL
                                          fit: BoxFit.cover),
                                    ),
                                  );
                                } else
                                  return Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(
                                              recievedImage), //imageURL
                                          fit: BoxFit.cover),
                                    ),
                                  );
                              } else if (_image != null) {
                                print("1");
                                print("here " + imageLink);
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: FileImage(_image), //imageURL
                                        fit: BoxFit.cover),
                                  ),
                                );
                              } else if (imageLink != "" && imageLink != null) {
                                print("2");
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: NetworkImage(imageLink),
                                        fit: BoxFit.cover),
                                  ),
                                );
                              } else {
                                print("3");
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "./assets/myPage/avatar.png"),
                                    ),
                                  ),
                                );
                              }
                            }()),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            // margin: EdgeInsets.fromLTRB(
                            //     330 .w, 341 .h, 0, 0),
                            child: InkWell(
                              onTap: loginOption != "login"
                                  ? () {
                                      _showPicker(context);
                                    }
                                  : () {
                                      show_toast.showToast(context, "로그인해주세요!");
                                    },
                              child: Image.asset(
                                "./assets/myPage/camera.png",
                                height: 167.h,
                                width: 167.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                    top: 264.h,
                  ),
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 닉네임
                        Container(
                          margin: EdgeInsets.fromLTRB(257.w, 80.h, 88.w, 0),
                          child: Text("닉네임",
                              style: TextStyle(
                                  color: const Color(0xffff7292),
                                  fontFamily: "NotoSansCJKkr_Medium",
                                  fontSize: 96.sp),
                              textAlign: TextAlign.left),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 128.w,
                            ),
                            child: Stack(
                              children: [
                                TextFormField(
                                  cursorColor: Color(0xffff7292),
                                  maxLength: 10,
                                  onChanged: (txt) {
                                    txt.length <= 10
                                        ? setState(() {
                                            nickName = txt;
                                          })
                                        : null;
                                  },
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Color(0xff3a3939),
                                      fontFamily: "NotoSansCJKkr_Bold",
                                      fontSize: 96.sp),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(right: 410.w),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xffff7292),
                                      ),

                                      //Color.fromRGBO(255, 114, 148, 1.0)
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffff7292)),
                                    ),
                                    hintText: '닉네임을 입력하세요',
                                    hintStyle: TextStyle(
                                        color: const Color(0xffcacaca),
                                        fontFamily: "NotoSansCJKkr_Medium",
                                        fontSize: 96.sp),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: FlatButton(
                                    height: 223.h,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    color: nickName == ""
                                        ? Color(0xffcacaca)
                                        : Color(0xffff7292),
                                    onPressed:
                                        loginOption != "login" && nickName != ""
                                            ? () {
                                                print(nickName);
                                                currentFocus.unfocus();
                                                buildShowDialogOnOk(
                                                    checkNickname(),
                                                    context,
                                                    300.h,
                                                    200.h,
                                                    80.h,
                                                    1500.h,
                                                    _fontsize);
                                              }
                                            : () {},
                                    child: // 중복확인
                                        Text("중복확인",
                                            style: TextStyle(
                                                color: const Color(0xffffffff),
                                                fontFamily:
                                                    "NotoSansCJKkr_Medium",
                                                fontSize: 96.sp),
                                            textAlign: TextAlign.left),
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
                //Gender
                Container(
                  margin: EdgeInsets.fromLTRB(165.w, 123.h, 0, 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 아이성별
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 24.h, 94.w, 0),
                        child: Text("아이성별",
                            style: TextStyle(
                                color: const Color(0xffff7292),
                                fontFamily: "NotoSansCJKkr_Medium",
                                fontSize: 96.sp),
                            textAlign: TextAlign.left),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            gender = "boy";
                            genderImage[0] = !genderImage[0];
                            genderImage[1] = false;
                          });
                        },
                        child: Image.asset(
                          genderImage[0]
                              ? "./assets/myPage/boy_pink.png"
                              : "./assets/myPage/boy_grey.png",
                          height: 566.h,
                          width: 409.w,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 98.w),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              gender = "girl";
                              genderImage[1] = !genderImage[1];
                              genderImage[0] = false;
                            });
                          },
                          child: Image.asset(
                            genderImage[1]
                                ? "./assets/myPage/girl_pink.png"
                                : "./assets/myPage/girl_grey.png",
                            height: 567.h,
                            width: 409.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Birthday

                Container(
                  margin: EdgeInsets.fromLTRB(165.w, 5.h, 0, 0),
                  child: Row(
                    children: [
                      // 아이생일
                      Text("아이생일",
                          style: TextStyle(
                            fontSize: 96.sp,
                            color: const Color(0xffff7292),
                            fontFamily: "NotoSansCJKkr_Medium",
                          ),
                          textAlign: TextAlign.left),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(82.w, 0, 121.w, 0),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: yearPicker,
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: yController,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Color(0xffff7292),
                                        fontSize: 96.sp,
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
                                      hintText: birthday == ""
                                          ? '생년월일을 선택해주세요'
                                          : birthday,
                                      hintStyle: TextStyle(
                                          color: Color(0xffd4d4d4),
                                          fontFamily: "NotoSansCJKkr_Medium",
                                          fontSize: 96.0.sp),
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
                                      "./assets/myPage/calendar.png"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //Ages
                Container(
                  margin: EdgeInsets.fromLTRB(257.w, 91.h, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 보호자 연령대
                      Text("보호자\n연령대",
                          style: TextStyle(
                            color: const Color(0xffff7292),
                            fontWeight: FontWeight.w500,
                            fontFamily: "NotoSansCJKkr_Medium",
                            fontSize: 96.sp,
                          ),
                          textAlign: TextAlign.right),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 93.w),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[0]
                                          ? './assets/registrationPage/10_pink.png'
                                          : './assets/registrationPage/10_grey.png',
                                      height: 306.h,
                                      width: 390.w,
                                    ),
                                    onTap: () {
                                      _change('10');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 88.w),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[1]
                                          ? './assets/registrationPage/20_pink.png'
                                          : './assets/registrationPage/20_grey.png',
                                      height: 306.h,
                                      width: 390.w,
                                    ),
                                    onTap: () {
                                      _change('20');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 55.w),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[2]
                                          ? './assets/registrationPage/30_pink.png'
                                          : './assets/registrationPage/30_grey.png',
                                      height: 306.h,
                                      width: 390.w,
                                    ),
                                    onTap: () {
                                      _change('30');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 88.w, top: 72.h),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[3]
                                          ? './assets/registrationPage/40_pink.png'
                                          : './assets/registrationPage/40_grey.png',
                                      height: 306.h,
                                      width: 390.w,
                                    ),
                                    onTap: () {
                                      _change('40');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 88.w, top: 72.h),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[4]
                                          ? './assets/registrationPage/50_pink.png'
                                          : './assets/registrationPage/50_grey.png',
                                      height: 306.h,
                                      width: 390.w,
                                    ),
                                    onTap: () {
                                      _change('50');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 55.w, top: 72.h),
                                  child: InkWell(
                                    child: Image.asset(
                                      changeimage[5]
                                          ? './assets/registrationPage/others_pink.png'
                                          : './assets/registrationPage/others_grey.png',
                                      height: 306.h,
                                      width: 390.w,
                                    ),
                                    onTap: () {
                                      _change('60');
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //OK
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: 129.h,
                      left: 150.w,
                    ),
                    child: SizedBox(
                      height: 304.w,
                      width: 2000.h,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: isIdValid &&
                                nickName != "" &&
                                yController.text != "" &&
                                gender != "" &&
                                userAge != ""
                            ? Color(0xffff7292)
                            : Color(0xffcacaca),
                        onPressed: isIdValid &&
                                nickName != "" &&
                                yController.text != "" &&
                                gender != "" &&
                                userAge != ""
                            ? () async {
                                print(userAge);
                                await uploadFile(_image);
                                showDialog(
                                  context: context,
                                  builder: (context) => FutureBuilder(
                                    future: updateNickname(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          // Add Your Code here.
                                          Navigator.pop(context);
                                          Navigator.pop(context, true);
                                        });
                                      } else if (snapshot.hasError) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20.0)),
                                          ),
                                          title: Text("${snapshot.error}"),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: // 확인
                                                  Text("확인",
                                                      style: TextStyle(
                                                          color: const Color(
                                                              0xffff7292),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              "NotoSansCJKkr_Medium",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: _fontsize),
                                                      textAlign:
                                                          TextAlign.center),
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(
                                        child: SizedBox(
                                            height: 200.w,
                                            width: 200.w,
                                            child: buildSpinKitThreeBounce(
                                                80.w, 1500.h)),
                                      );
                                    },
                                  ),
                                );
                              }
                            : () {
                                show_toast.showToast(context, "모든 필드를 입력하십시오");
                              },
                        child: // 중복확인
                            Text("OK",
                                style: TextStyle(
                                    color: const Color(0xffffffff),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansCJKkr_Medium",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 96.sp),
                                textAlign: TextAlign.left),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
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

  yearPicker() {
    final year = DateTime.now().year;

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
              color: Color.fromRGBO(255, 114, 148, 1.0),
              fontWeight: FontWeight.w500,
              fontSize: 56.sp,
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
                  fontSize: 57.sp,
                ),
              ),
              onPressed: () {
                setState(() {
                  birthday = yController.text;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
