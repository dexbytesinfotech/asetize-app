class VehicleModel {
  List<FindMyVehicle>? data;
  String? message;

  VehicleModel({this.data, this.message});

  VehicleModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FindMyVehicle>[];
      json['data'].forEach((v) {
        data!.add(new FindMyVehicle.fromJson(v));
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

class FindMyVehicle {
  int? id;
  String? registrationNumber;
  String? ownerName;
  String? vehicleType;
  String? phone;
  String? countryCode;
  String? make;
  String? model;
  String? colors;
  String? filePath;
  String? registrationPhoto;
  String? shortDescription;
  User? user;

  FindMyVehicle(
      {this.id,
        this.registrationNumber,
        this.ownerName,
        this.vehicleType,
        this.make,
        this.model,
        this.colors,
        this.filePath,
        this.phone,
        this.countryCode,
        this.shortDescription,
        this.registrationPhoto,
        this.user});

  FindMyVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registrationNumber = json['registration_number'];
    ownerName = json['owner_name'];
    vehicleType = json['vehicle_type']; phone = json['phone'];
    make = json['make'];
    model = json['model'];
    colors = json['colors'];
    filePath = json['file_path'];
    countryCode = json['country_code'];
    registrationPhoto = json['registration_photo'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    shortDescription = json['short_description'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['registration_number'] = this.registrationNumber;
    data['owner_name'] = this.ownerName;
    data['vehicle_type'] = this.vehicleType;
    data['phone'] = this.phone;
    data['make'] = this.make;
    data['model'] = this.model;
    data['colors'] = this.colors;
    data['file_path'] = this.filePath;
    data['country_code'] = this.countryCode;
    data['short_description'] = this.shortDescription;
    data['registration_photo'] = this.registrationPhoto;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? profilePhoto;
  String? email;
  String? phone;
  String? shortDescription;

  User(
      {this.name,
        this.profilePhoto,
        this.email,
        this.phone,
        this.shortDescription});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePhoto = json['profile_photo'];
    email = json['email'];
    phone = json['phone'];
    shortDescription = json['short_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_photo'] = this.profilePhoto;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['short_description'] = this.shortDescription;
    return data;
  }
}