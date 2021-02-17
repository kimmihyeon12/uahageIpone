import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class map_list extends StatefulWidget {
  map_list({Key key, this.latitude, this.longitude, this.list})
      : super(key: key);
  String latitude;
  String longitude;
  String list;
  @override
  _map_listState createState() => _map_listState();
}

class _map_listState extends State<map_list> {
  String latitude = "";
  String longitude = "";
  String searchKey = "";
  //
  getCurrentLocation() async {
    final geoposition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      latitude = geoposition.latitude.toString();
      longitude = geoposition.longitude.toString();
    });
  }

  searchAddress(searchKey) async {
    // ignore: unnecessary_statements
    print(searchKey);
    searchKey != ""
        ? controller
            .loadUrl('http://13.209.41.43/getAddress?address=$searchKey')
        : null;
  }

  // WebViewController _controller;
  WebViewController controller;

  @override
  void initState() {
    super.initState();
    if (widget.latitude == 'NaN' || widget.longitude == 'NaN') {
      getCurrentLocation();
    } else
      setState(() {
        latitude = widget.latitude;
        longitude = widget.longitude;
      });
    // getCurrentLocation();
  }

  int zoom = 4;
  int position = 1;
  final key = UniqueKey();

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

  SpinKitThreeBounce buildSpinKitThreeBounce(double size, double screenWidth) {
    return SpinKitThreeBounce(
      color: Color(0xffFF728E),
      size: size / screenWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    var listrequest = widget.list;

    double screenHeight = 2668 / MediaQuery.of(context).size.height;
    double screenWidth = 1500 / MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: position,
              children: [
                WebView(
                  key: key,
                  onPageFinished: doneLoading,
                  onPageStarted: startLoading,
                  onWebViewCreated: (WebViewController webViewController) {
                    controller = webViewController;
                    controller.loadUrl(
                        // latitude == 'NaN' ||
                        //       longitude == 'NaN' ||
                        //       latitude == '' ||
                        //       longitude == ''
                        //   ? 'http://13.209.41.43/test' :
                        'http://13.209.41.43/test/$listrequest?lat=$latitude&long=$longitude&zoomLevel=$zoom');
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                ),
                Container(
                  color: Colors.white,
                  child:
                      Center(child: buildSpinKitThreeBounce(80, screenWidth)),
                ),
              ],
            ),
            Row(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () async {
                      //var response = await getMap(latitude, longitude);
                      if (latitude == 'NaN' ||
                          longitude == 'NaN' ||
                          latitude == '' ||
                          longitude == '') await getCurrentLocation();
                      controller.loadUrl(
                          // 'http://13.209.41.43/getPos?lat=$latitude&long=$longitude&address=$searchKey');
                          'http://13.209.41.43/test/$listrequest?lat=$latitude&long=$longitude&zoomLevel=$zoom');
                      print(listrequest);
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 48 / screenWidth, bottom: 76 / screenHeight),
                      child: SizedBox(
                        height: 159 / screenHeight,
                        width: 161 / screenWidth,
                        child: Image.asset("assets/searchPage/location.png"),
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.bottomRight,
                //   child: Container(
                //     margin: EdgeInsets.fromLTRB(
                //         1060 / screenWidth, 0, 0, 47 / screenHeight),
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       // crossAxisAlignment: CrossAxisAlignment.end,
                //       children: [
                //         IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 zoom -= 1;
                //               });
                //               controller.loadUrl(
                //                   "http://13.209.41.43/test/$listrequest?lat=$latitude&long=$longitude&zoomLevel=$zoom");
                //             },
                //             icon: Image.asset(
                //               "assets/searchPage/plus.png",
                //               width: 105 / screenWidth,
                //               height: 105 / screenHeight,
                //             )),
                //         IconButton(
                //             onPressed: () {
                //               setState(() {
                //                 zoom += 1;
                //               });
                //               controller.loadUrl(
                //                   "http://13.209.41.43/test/$listrequest?lat=$latitude&long=$longitude&zoomLevel=$zoom");
                //             },
                //             icon: Image.asset(
                //               "assets/searchPage/minus.png",
                //               width: 105 / screenWidth,
                //               height: 105 / screenHeight,
                //             )),
                //       ],
                //     ),
                //   ),
                // )
                // //
              ],
            ),
          ],
        ),
      ),
    );
  }
}
