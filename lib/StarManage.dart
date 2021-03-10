import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class StarManage {
  void click_star(
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
      "http://13.209.41.43/star",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ss),
    );
  }

  getStarColor(userId, loginOption, liststringdata) async {
    List<String> star_color_list = [];
    var data = await http.get(
        'http://13.209.41.43/starcolor?user_id=$userId$loginOption&tablename=$liststringdata');
    var dec = jsonDecode(data.body);

    for (int i = 0; i < dec.length; i++) {
      star_color_list.add(dec[i]["store_name"].toString());
    }
    return star_color_list;
  }
}
