class AssetHistoryModel {
  List<AssetHistoryData>? data;
  String? message;

  AssetHistoryModel({this.data, this.message});

  AssetHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AssetHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new AssetHistoryData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class AssetHistoryData {
  int? id;
  String? action;
  String? message;
  String? createdAt;
  String? createdTime;
  User? user;

  AssetHistoryData(
      {this.id,
        this.action,
        this.message,
        this.createdAt,
        this.createdTime,
        this.user});

  AssetHistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    action = json['action'];
    message = json['message'];
    createdAt = json['created_at'];
    createdTime = json['created_time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['action'] = this.action;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    data['created_time'] = this.createdTime;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? profilePhoto;
  String? countryCode;
  String? phone;

  User({this.id, this.name, this.profilePhoto, this.countryCode, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePhoto = json['profile_photo'];
    countryCode = json['country_code'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_photo'] = this.profilePhoto;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    return data;
  }
}
