import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class appbar extends StatelessWidget {
  sub_appbar(String text, context, star_color) {
    ScreenUtil.init(context, width: 2345, height: 5075);
    return  PreferredSize(
      preferredSize: Size.fromHeight(553.h),
      child: Container(
        color: Colors.white,
        height: 553.h,
        
        child: Container(
          
          margin:EdgeInsets.only(top: 350.h,),
          child: Row(
            children: [

              Padding(padding:EdgeInsets.only( left: 62.w)),
              InkWell(

                child:   Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
                onTap: (){   Navigator.pop(context, star_color);},
              ),


              Container(
                width: 2000.w,
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 107.sp,
                      fontFamily: 'NotoSansCJKkr_Bold',
                      letterSpacing: 0,
                      color:Color.fromRGBO(255, 114, 148, 1.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
    
    PreferredSize(
      preferredSize: Size.fromHeight(553.h),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, centerTitle: true,
        // iconTheme: IconThemeData(
        //   color: Color(0xffff7292), //change your color here
        // ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xffff7292)),
          onPressed: () {
            Navigator.pop(context, star_color);
            print(star_color.toString());
          },
        ),
        title: Text(
          text,
          style: TextStyle(
              color: Color(0xffff7292),
              fontFamily: "NotoSansCJKkr_Medium",
              fontSize: 107.0.sp),
        ),
      ),
    );
  }

  navHome_abbbar(String text, context) {
    ScreenUtil.init(context, width: 2435, height: 5075);
    return PreferredSize(
      preferredSize: Size.fromHeight(553.h),
      child: Container(
        color: Color.fromRGBO(255, 114, 148, 1.0),
        height: 553.h,
        child: Container(
          margin: EdgeInsets.only(top: 350.h, left: 968.w),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 107.sp,
              fontFamily: 'NotoSansCJKkr_Bold',
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      // ),
    );
  }

  screen_appbar(String text, context) {
    ScreenUtil.init(context, width: 2345, height: 5075);
    return PreferredSize(
      preferredSize: Size.fromHeight(178.h),
      child: Container(
        color: Color.fromRGBO(255, 114, 148, 1.0),
        height: 178.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Container(
                      height: 76.h,
                      width: 43.w,
                      margin: EdgeInsets.only(left: 31.w),
                      child: Image.asset("./assets/agreementPage/back.png"),
                    ),
                  ),
                ),
                Container(
                    height: 178.h,
                    width: 1500.w,
                    child: // 약관동의
                        // 위치기반서비스 이용약관
                        Center(
                      child: Text(text,
                          style: TextStyle(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.w700,
                              fontFamily: "NotoSansCJKkr_Bold",
                              fontStyle: FontStyle.normal,
                              fontSize: 75.sp),
                          textAlign: TextAlign.left),
                    )),
              ],
            ),
          ],
        ),
      ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
