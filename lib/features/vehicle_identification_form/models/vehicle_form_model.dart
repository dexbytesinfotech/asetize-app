class VehicleDataFormModel {
  Data? data;
  String? message;

  VehicleDataFormModel({this.data, this.message});

  VehicleDataFormModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? registrationNumber;
  String? ownerName;
  String? vehicleType;
  String? make;
  String? model;
  String? colors;
  String? filePath;
  String? registrationPhoto;
  User? user;

  Data(
      {this.id,
        this.registrationNumber,
        this.ownerName,
        this.vehicleType,
        this.make,
        this.model,
        this.colors,
        this.filePath,
        this.registrationPhoto,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registrationNumber = json['registration_number'];
    ownerName = json['owner_name'];
    vehicleType = json['vehicle_type'];
    make = json['make'];
    model = json['model'];
    colors = json['colors'];
    filePath = json['file_path'];
    registrationPhoto = json['registration_photo'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['registration_number'] = this.registrationNumber;
    data['owner_name'] = this.ownerName;
    data['vehicle_type'] = this.vehicleType;
    data['make'] = this.make;
    data['model'] = this.model;
    data['colors'] = this.colors;
    data['file_path'] = this.filePath;
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

  User({this.name, this.profilePhoto, this.email, this.phone});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profilePhoto = json['profile_photo'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_photo'] = this.profilePhoto;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}