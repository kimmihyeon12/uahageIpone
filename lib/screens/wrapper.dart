import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uahage/NavigationPage/Navigationbar.dart';
import 'package:uahage/screens/loginPage.dart';

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
    // _saveUserId();
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
    // bool data = widget.data;

    // final user = Provider.of<User>(context);
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
