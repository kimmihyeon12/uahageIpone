class KidsCafe {
  KidsCafe({
    this.id,
    this.store_name,
    this.address,
    this.phone,
    this.fare,
    this.lat,
    this.lon,
  });

  int id;
  String store_name;
  String address;
  String phone;
  String fare;
  double lat;
  double lon;
  double dist;

  factory KidsCafe.fromJson(Map<String, dynamic> json) => KidsCafe(
        id: json["id"],
        store_name: json["store_name"],
        address: json["address"],
        phone: json["phone"],
        fare: json["fare"],
        lat: json["lat"],
        lon: json["lon"],
      );
}
