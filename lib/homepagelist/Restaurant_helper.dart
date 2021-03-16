import 'dart:convert';

class Restaurant {
  Restaurant({
    this.id,
    this.store_name,
    this.address,
    this.phone,
    this.carriage,
    this.bed,
    this.tableware,
    this.nursingroom,
    this.meetingroom,
    this.diapers,
    this.playroom,
    this.chair,
    this.menu,
    this.lat,
    this.lon,
  });

  int id;
  String store_name;
  String address;
  String phone;
  String menu;
  String carriage;
  String bed;
  String tableware;
  String nursingroom;
  String meetingroom;
  String diapers;
  String playroom;
  String chair;
  var lat;
  var lon;

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
        id: json["id"],
        store_name: json["store_name"],
        address: json["address"],
        phone: json["phone"],
        menu: json["menu"],
        bed: json["bed"],
        tableware: json["tableware"],
        meetingroom: json["meetingroom"],
        diapers: json["diapers"],
        playroom: json["playroom"],
        carriage: json["carriage"],
        nursingroom: json["nursingroom"],
        chair: json["chair"],
        lat: json["lat"],
        lon: json["lon"]);
  }
}
