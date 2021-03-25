class examinationinstitution {
  examinationinstitution({
    this.id,
    this.store_name,
    this.address,
    this.phone,
    this.Examination_item,
  });

  int id;
  String store_name;
  String address;
  String phone;
  String Examination_item;

  factory examinationinstitution.fromJson(Map<String, dynamic> json) =>
      examinationinstitution(
        id: json["id"],
        store_name: json["store_name"],
        address: json["address"],
        phone: json["phone"],
        Examination_item: json["Examination_item"],
      );
}
