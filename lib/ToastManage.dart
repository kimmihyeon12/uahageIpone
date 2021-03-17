import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class toast extends StatelessWidget {

  showToast(context , text) {
    print("주소복사");
    double screenWidth = 1501 / MediaQuery.of(context).size.width;
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black45,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
           text,
            style: TextStyle(
              fontSize: 45 / screenWidth,
              fontFamily: 'NotoSansCJKkr_Medium',
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 1),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
