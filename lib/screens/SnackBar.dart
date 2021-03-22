import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class SnackBarpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width:  1500 , height:  2667 );
    return Container(
      width:1501.w,
      height:2667.h,
      color: Colors.black54,
      child: Align(
        alignment: Alignment(0.0, 1.0),
        child: Container(
          height: 150 .h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black54,
          ),
          margin: EdgeInsets.only(
              bottom: 50 .h,
              left: 40 .w,
              right: 40 .w),
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: EdgeInsets.only(left: 80 .w),
            child: Align(
              alignment: Alignment(-1.0, 0.0),
              child: Text(
                "인터넷 연결상태가 좋지않습니다.",
                style: TextStyle(
                  fontSize: 55 .sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
