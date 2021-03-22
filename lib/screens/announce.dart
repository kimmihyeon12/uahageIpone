import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uahage/screens/allAppBar.dart';
class announce extends StatefulWidget {
  announce({Key key, this.choice}) : super(key: key);
  String choice;
  @override
  _announceState createState() => _announceState();
}

class _announceState extends State<announce> {
  bool isIOS = Platform.isIOS;
  appbar bar = new appbar();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width:  1500 , height:  2667 );
    return SafeArea(
      child: Scaffold(
        appBar: bar.screen_appbar('위치기반서비스 이용약관',context),

              body:Column(
                children: [
                  Container(
                    width: 1353 .w,
                    height: 2000 .h,
                      margin: EdgeInsets.fromLTRB(73 .w, 90 .h,
                          75 .w, 39 .h),
         child:ListView(
                      children: [

                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Image.asset("./assets/agreementPage/x_btn.png"),
                              ),
                            ),
                            Text(
                                """제1장 총   칙 \n\n제 1 조 (목적)\n  본 약관은 우아하게(이하 “회사”라 합니다)가 제공하는 위치기반서비스(이하 “서비스”)를 이용함에 있어 회사와 이용자 및 개인위치정보주체의 권리, 의무 및 책임사항에 따른 이용조건 및 절차 등 기본적인 사항을 규정함을 목적으로 합니다.\n\n제 2 조 (이용약관의 효력 및 변경)\n1. 본 약관은 서비스를 신청한 이용자 또는 개인위치정보주체가 본 약관에 동의하고 회사가 정한 소정의 절차에 따라 서비스의 이용자로 등록함으로써 효력이 발생합니다.\n2. 이용자가 온라인에서 본 약관의 "동의하기" 버튼을 클릭하였을 경우 본 약관의 내용을 모두 읽고 이를 충분히 이해하였으며, 그 적용에 동의한 것으로 봅니다.
 3. 회사는 위치정보의 보호 및 이용 등에 관한 법률, 콘텐츠산업 진흥법, 전자상거래 등에서의 소비자보호에 관한 법률, 소비자기본법 약관의 규제에 관한 법률 등 관련 법령을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.
 4. 이용자와 계약을 체결한 서비스가 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 수단으로 즉시 통지합니다.
 5. 회사는 본 약관을 변경할 경우에는 변경된 약관과 사유를 적용일자 1주일 전까지 서비스 홈페이지에 게시하거나 이용자에게 전자적 형태(전자우편, SMS 등)로 공지하며, 이용자가 그 기간 안에 이의제기가 없거나, 본 서비스를 이용할 경우 이를 승인한 것으로 봅니다.""",
                                style: TextStyle(
                                    color: const Color(0xff979797),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "NotoSansCJKkr_Medium",

                                    fontSize: 57.0 .sp),
                                ),

                          ],
                        )

                      ],
                    ),


                  ),
                  Divider(thickness: 0.1, height: 0, color: Color(0xff000000)),
                  Container(
                    margin: EdgeInsets.fromLTRB(155.w,
                        45 .h, 154 .w, 46 .h),
                    height: 194 .w,
                    width: 1192.h,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context, widget.choice);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Color(0xffff7292),
                        child: Image.asset(
                          "./assets/agreementPage/ok.png",
                          height: 58.h,
                        )),
                  )
                ],
              ),


          ),


    );
  }
}
