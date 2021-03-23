import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uahage/NavigationPage/Map_List_Toggle.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:uahage/ToastManage.dart';

class Keyword extends StatefulWidget {
  Keyword(
      {Key key,
      this.latitude,
      this.longitude,
      this.searchkey,
      this.userId,
      this.loginOption})
      : super(key: key);
  String userId;
  String loginOption;
  String latitude;
  String longitude;
  String searchkey;

  @override
  _KeywordState createState() => _KeywordState();
}

class _KeywordState extends State<Keyword> {
  var messages;
  String userId = "";
  String loginOption = "";
  String searchkey;
  String latitude;
  String longitude;
  WebViewController controller;
  @override
  void initState() {
    super.initState();
    loginOption = widget.loginOption;
    userId = widget.userId ?? "";
    latitude = widget.latitude;
    longitude = widget.longitude;
    searchkey = widget.searchkey;
  }

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  int position = 1;

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  toast show_toast = new toast();
  @override
  Widget build(BuildContext context) {
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: WebView(
                onPageFinished: doneLoading,
                onPageStarted: startLoading,
                // initialUrl:
                //     'http://211.223.46.144:3000/searchlist?lat=$latitude&long=$longitude&searchkey=%27$searchkey%27',
                onWebViewCreated: (WebViewController webViewController) async {
                  controller = webViewController;

                  await controller.loadUrl(
                      'http://211.223.46.144:3000/map/searchlist?lat=$latitude&long=$longitude&searchkey=%27$searchkey%27');
                  // showToggle = true;
                },
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels: Set.from([
                  JavascriptChannel(
                      name: 'Print',
                      onMessageReceived: (JavascriptMessage message) async {
                        messages = message.message;
                        print('messages: ' + messages);
                        //    controller.evaluateJavascript(javascriptString)
                        // return Map_List_Toggle(latitude:latitude,longitude:longitude,searchkey:messages);
                        if (messages != 'null') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Map_List_Toggle(
                                  userId: userId,
                                  loginOption: loginOption,
                                  latitude: latitude,
                                  longitude: longitude,
                                  searchkey: messages),
                            ),
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "  옳바르게 입력해주세요!  ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black45,
                            textColor: Colors.white,
                            fontSize: 48 / screenWidth,
                          );
                          currentFocus.unfocus();
                          Navigator.pop(context);
                        }
                        // setState(() {
                        //   searchkey = messages;
                        //   addressbtn = false;
                        // });
                      }),
                ]),
              ),
            ),
            position == 1
                ? Center(
                    child: Container(
                      color: Colors.white,
                      child: Center(
                          child: buildSpinKitThreeBounce(80, screenWidth)),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
