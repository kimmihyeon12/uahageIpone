import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class StarManage {
  Future click_star(
      userIdloginOption,
      store_name1,
      address1,
      phone1,
      menu1,
      bed1,
      tableware1,
      meetingroom1,
      diapers1,
      playroom1,
      carriage1,
      nursingroom1,
      chair1,
      fare1,
      Examination_item1,
      star_color,
      liststringdata) async {
    Map<String, dynamic> ss = {
      "user_id": userIdloginOption,
      "store_name": store_name1,
      "address": address1,
      "phone": phone1,
      "menu": menu1,
      "bed": bed1,
      "tableware": tableware1,
      "meetingroom": meetingroom1,
      "diapers": diapers1,
      "playroom": playroom1,
      "carriage": carriage1,
      "nursingroom": nursingroom1,
      "chair": chair1,
      "fare": fare1,
      "Examination_item": Examination_item1,
      "star_color": star_color,
      "type": liststringdata
    };

    var response = await http.post(
      "http://211.223.46.144:3000/star",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
    return response.body;
  }

  getStarColor(userId, loginOption, liststringdata) async {
    List<bool> star_color_list = [];
    var data = await http.get(
        'http://211.223.46.144:3000/starcolor?user_id=$userId$loginOption&tablename=$liststringdata');
    var dec = jsonDecode(data.body);

    for (int i = 0; i < dec.length; i++) {
      if (dec[i]["store_name"] != null) {
        star_color_list.add(true);
      } else {
        star_color_list.add(false);
      }
    }
    return star_color_list;
  }

  getSubStarColor(userId, loginOption, storename) async {
    print('getSubStarColor: $storename');
    var response;
    var star_color = false;
    try {
      Map<String, String> bb = {
        "userId": userId + loginOption,
        "storeName": storename
      };
      response = await http.post(
        "http://211.223.46.144:3000/getStarColor",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(bb),
      );

      if (response.statusCode == 200) {
        star_color = true;
      } else {
        star_color = false;
      }

      return star_color;
    } catch (err) {
      print(err);
    }
  }
}
