import 'dart:convert';

KidsCafeHelper kidsCafeHelperFromJson(String str) =>
    KidsCafeHelper.fromJson(json.decode(str));

String kidsCafeHelperToJson(KidsCafeHelper data) => json.encode(data.toJson());

class KidsCafeHelper {
  KidsCafeHelper({
    this.id,
    this.storeName,
    this.address,
    this.phone,
    this.fare,
  });

  String id;
  String storeName;
  String address;
  String phone;
  String fare;

  factory KidsCafeHelper.fromJson(Map<String, dynamic> json) => KidsCafeHelper(
        id: json["id"],
        storeName: json["store_name"],
        address: json["address"],
        phone: json["phone"],
        fare: json["fare"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
        "address": address,
        "phone": phone,
        "fare": fare,
      };
}
