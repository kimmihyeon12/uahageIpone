import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uahage/NavigationPage/Map_List_Toggle.dart';

class Keyword extends StatefulWidget {
  Keyword({Key key, this.latitude, this.longitude, this.searchkey})
      : super(key: key);
  String latitude;
  String longitude;
  String searchkey;
  @override
  _KeywordState createState() => _KeywordState();
}

class _KeywordState extends State<Keyword> {
  var messages;

  WebViewController controller;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var latitude = widget.latitude;
    var longitude = widget.longitude;
    var searchkey = widget.searchkey;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          WebView(
            onWebViewCreated: (WebViewController webViewController) async {
              controller = webViewController;
              print('latitude:' + latitude);
              print('longitude:' + longitude);
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
                    return Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Map_List_Toggle(
                                latitude: latitude,
                                longitude: longitude,
                                searchkey: messages)));
                    // setState(() {
                    //   searchkey = messages;
                    //   addressbtn = false;
                    // });
                  }),
            ]),
          ),
        ]),
      ),
    );
  }
}
