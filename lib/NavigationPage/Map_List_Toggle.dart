import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Map_List_Toggle extends StatefulWidget {
  Map_List_Toggle({Key key, this.latitude, this.longitude, this.searchkey})
      : super(key: key);
  String latitude;
  String longitude;
  var searchkey;
  @override
  _Map_List_ToggleState createState() => _Map_List_ToggleState();
}

class _Map_List_ToggleState extends State<Map_List_Toggle> {
  @override
  var switchbtn = false;
  WebViewController controller;
  var searchbtn = false;
  var i = 0;

  List<String> store_namelist = List(500);
  List<String> addresslist = List(500);

  Widget build(BuildContext context) {
    var latitude = widget.latitude;
    var longitude = widget.longitude;
    var searchkey = widget.searchkey;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var ScreenHeight = MediaQuery.of(context).size.height;
    var ScreenWidth = MediaQuery.of(context).size.width;
    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;

    return switchbtn
        ? WillPopScope(
            onWillPop: _onbackpressed,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                toolbarHeight: 250 / screenHeight,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Row(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                      top: 500 / screenHeight,
                    )),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_sharp),
                      iconSize: 100 / screenWidth,
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          searchbtn = false;
                          print(searchbtn);
                        });
                      },
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                      left: 900 / screenWidth,
                    )),
                    InkWell(
                      child: Image.asset(
                        './assets/off.png',
                        width: 290 / screenWidth,
                        height: 183 / screenHeight,
                      ),
                      onTap: () {
                        setState(() {
                          switchbtn = false;
                          print(searchbtn);
                          i = 0;
                        });
                      },
                    ),
                  ],
                ),
              ),
              body: ListView.builder(
                  itemCount: i,
                  itemBuilder: (context, index) {
                    print('snapshot.data.length');
                    // print(snapshot.data.id[index]);
                    return Card(
                      elevation: 0.3,
                      child: InkWell(
                        child: Container(
                            height: 400 / screenHeight,
                            padding: EdgeInsets.only(
                              top: 30 / screenHeight,
                              left: 26 / screenWidth,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                  top: 200 /
                                      (1501 /
                                          MediaQuery.of(context).size.width),
                                )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 750 / screenWidth,
                                      height: 100 / screenHeight,
                                      child: Text(
                                        store_namelist[index],
                                        style: TextStyle(
                                          fontSize: 56 / screenWidth,
                                          fontFamily: 'NotoSansCJKkr_Medium',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                      top: 10 / screenHeight,
                                    )),
                                    SafeArea(
                                      child: Container(
                                        height: 80 / screenHeight,
                                        width: 800 / screenWidth,
                                        child: Text(
                                          addresslist[index],
                                          style: TextStyle(
                                            // fontFamily: 'NatoSans',
                                            color: Colors.grey,
                                            fontSize: 45 / screenWidth,
                                            fontFamily: 'NotoSansCJKkr_Medium',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    );
                  }),
            ),
          )
        : WillPopScope(
            onWillPop: _onbackpressed,
            child: Scaffold(
              body: SafeArea(
                child: Stack(children: [
                  WebView(
                    onWebViewCreated:
                        (WebViewController webViewController) async {
                      controller = webViewController;
                      await controller.loadUrl(
                          'http://119.200.163.240:3000/homesearch?lat=$latitude&long=$longitude&address=%27$searchkey%27');
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels: Set.from([
                      JavascriptChannel(
                          name: 'Print',
                          onMessageReceived: (JavascriptMessage message) {
                            var messages = message.message;
                            var ex = messages.split(",");
                            print(ex);
                            setState(() {
                              for (int j = 0; j < 2; j++) {
                                store_namelist[i] = ex[0];
                                addresslist[i] = ex[1];
                                print(i.toString() +
                                    "store_namelist" +
                                    store_namelist[i]);
                                print(i.toString() +
                                    "addresslist" +
                                    addresslist[i]);
                              }
                              i++;
                            });
                          })
                    ]),
                  ),
                  Row(
                    children: [
                      Padding(
                          padding: EdgeInsets.only(
                        top: 250 / screenHeight,
                      )),
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_sharp),
                        iconSize: 100 / screenWidth,
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            searchbtn = false;

                            print(searchbtn);
                          });
                        },
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                        left: 950 / screenWidth,
                      )),
                      FutureBuilder(
                        future: Future.delayed(Duration(milliseconds: 550)),
                        builder: (c, s) =>
                            s.connectionState == ConnectionState.done
                                ? InkWell(
                                    child: Image.asset(
                                      './assets/on.png',
                                      width: 290 / screenWidth,
                                      height: 183 / screenHeight,
                                    ),
                                    onTap: () {
                                      setState(() {
                                        switchbtn = true;
                                        print(switchbtn);
                                      });
                                    },
                                  )
                                : Text(
                                    "Loading..",
                                    style: TextStyle(
                                      fontSize: 45 / screenWidth,
                                      fontFamily: 'NotoSansCJKkr_Bold',
                                      letterSpacing: 0,
                                      color: Color(0xffff7292),
                                    ),
                                  ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          );
  }

  Future<bool> _onbackpressed() {
    setState(() {
      //  searchbtn = false;
      //  switchbtn = false;
      return Navigator.pop(context, 'Yep!');
      i = 0;
    });
  }
}
