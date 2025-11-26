class SelectContactModel {
  bool clickStatus;
  int id;
  String name;
  String image;
  String image1;

  SelectContactModel(
      {required this.clickStatus,
      required this.name,
      this.id = 0,
      required this.image,
      required this.image1});

  factory SelectContactModel.fromJson(Map<String, dynamic> json) {
    return SelectContactModel(
      clickStatus: json['clickStatus'],
      name: json['name'],
      image: json['image'],
      image1: json['image'],
    );
  }
}
