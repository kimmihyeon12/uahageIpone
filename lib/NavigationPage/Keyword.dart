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
  toast show_toast = new toast();
  @override
  Widget build(BuildContext context) {
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;
    FocusScopeNode currentFocus = FocusScope.of(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: WebView(
            // initialUrl:
            //     'http://13.209.41.43/searchlist?lat=$latitude&long=$longitude&searchkey=%27$searchkey%27',
            onWebViewCreated: (WebViewController webViewController) async {
              controller = webViewController;
              print(searchkey);
              print(
                  'http://13.209.41.43/searchlist?lat=$latitude&long=$longitude&searchkey=$searchkey');
              await controller.loadUrl(
                  'http://13.209.41.43/searchlist?lat=$latitude&long=$longitude&searchkey=%27$searchkey%27');
              // showToggle = true;
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {
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
                                  searchkey: messages)));
                    } else {
                      show_toast.showToast(context, "  옳바르게 입력해주세요!  ");

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
      ),
    );
  }
}
