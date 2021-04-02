import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/View/Navigations//Navigationbar.dart';
import 'package:uahage/View/Auth/loginPage.dart';

class Wrapper extends StatefulWidget {
  /* bool data;
  Wrapper({Key key, this.data}) : super(key: key);*/
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  String userId = "";
  String loginOption = "";

  @override
  void initState() {
    super.initState();
    _loadUserId();

  }

  _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('uahageUserId') ?? "";
      loginOption = prefs.getString("uahageLoginOption") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {

    print("userID = " + userId);
    if (userId == "") {
      return loginPage();
    } else {
      return navigationPage(
        userId: userId,
        loginOption: loginOption,
        oldNickname: "",
      );
    }
  }
}
