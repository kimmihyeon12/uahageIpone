// To parse this JSON data, do
//
//     final restaurant = restaurantFromJson(jsonString);

import 'dart:convert';

Restaurant restaurantFromJson(String str) =>
    Restaurant.fromJson(json.decode(str));

String restaurantToJson(Restaurant data) => json.encode(data.toJson());

class Restaurant {
  Restaurant({
    this.id,
    this.storeName,
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
    this.picture,
    this.ad,
    this.lat,
    this.lon,
    this.clss,
    this.pnu,
    this.addressSeparation,
    this.newAddress,
    this.oldAddress,
    this.postalCode,
  });

  String id;
  String storeName;
  String address;
  String phone;
  String carriage;
  String bed;
  String tableware;
  String nursingroom;
  String meetingroom;
  String diapers;
  String playroom;
  String chair;
  String picture;
  String ad;
  String lat;
  String lon;
  String clss;
  String pnu;
  String addressSeparation;
  String newAddress;
  String oldAddress;
  String postalCode;

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    storeName = json["store_name"];
    address = json["address"];
    phone = json["phone"];
    carriage = json["carriage"];
    bed = json["bed"];
    tableware = json["tableware"];
    nursingroom = json["nursingroom"];
    meetingroom = json["meetingroom"];
    diapers = json["diapers"];
    playroom = json["playroom"];
    chair = json["chair"];
    picture = json["picture"];
    ad = json["ad"];
    lat = json["lat"];
    lon = json["lon"];
    clss = json["CLSS"];
    pnu = json["PNU"];
    addressSeparation = json["Address_Separation"];
    newAddress = json["new_address"];
    oldAddress = json["old_address"];
    postalCode = json["Postal_code"];
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
        "address": address,
        "phone": phone,
        "carriage": carriage,
        "bed": bed,
        "tableware": tableware,
        "nursingroom": nursingroom,
        "meetingroom": meetingroom,
        "diapers": diapers,
        "playroom": playroom,
        "chair": chair,
        "picture": picture,
        "ad": ad,
        "lat": lat,
        "lon": lon,
        "CLSS": clss,
        "PNU": pnu,
        "Address_Separation": addressSeparation,
        "new_address": newAddress,
        "old_address": oldAddress,
        "Postal_code": postalCode,
      };
}
