class VerifyOtpModel {
  VerifyOtpData? data;
  String? message;

  VerifyOtpModel({this.data, this.message});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new VerifyOtpData.fromJson(json['data']) : null;
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

class VerifyOtpData {
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? countryCode;
  List<Roles>? roles;
  String? emailVerifiedAt;
  String? lastLogin;
  bool? globalNotifications;
  String? defaultLang;
  String? token;
  String? createdAt;
  String? updatedAt;

  VerifyOtpData(
      {this.name,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.countryCode,
        this.roles,
        this.emailVerifiedAt,
        this.lastLogin,
        this.globalNotifications,
        this.defaultLang,
        this.token,
        this.createdAt,
        this.updatedAt});

  VerifyOtpData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    countryCode = json['country_code'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    emailVerifiedAt = json['email_verified_at'];
    lastLogin = json['last_login'];
    globalNotifications = json['global_notifications'];
    defaultLang = json['default_lang'];
    token = json['token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    data['email_verified_at'] = this.emailVerifiedAt;
    data['last_login'] = this.lastLogin;
    data['global_notifications'] = this.globalNotifications;
    data['default_lang'] = this.defaultLang;
    data['token'] = this.token;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Roles {
  String? name;

  Roles({this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
