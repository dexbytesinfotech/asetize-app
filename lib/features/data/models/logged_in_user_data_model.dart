class LoggedInUserInfoModel {
  int? id;
  String? name;
  String? email;
  String? phone;
  int? countryCode;
  List<Roles>? roles;
  String? phoneVerifiedAt;
  String? emailVerifiedAt;
  String? lastLogin;
  bool? globalNotifications;
  String? defaultLang;
  String? token;
  int? messageCount;
  int? notificationCount;

  LoggedInUserInfoModel(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.countryCode,
      this.roles,
      this.phoneVerifiedAt,
      this.emailVerifiedAt,
      this.lastLogin,
      this.globalNotifications,
      this.defaultLang,
      this.token,
      this.messageCount,
      this.notificationCount});

  LoggedInUserInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    countryCode = json['country_code'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    phoneVerifiedAt = json['phone_verified_at'];
    emailVerifiedAt = json['email_verified_at'];
    lastLogin = json['last_login'];
    globalNotifications = json['global_notifications'];
    defaultLang = json['default_lang'];
    token = json['token'];
    messageCount = json['message_count'];
    notificationCount = json['notification_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    data['phone_verified_at'] = this.phoneVerifiedAt;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['last_login'] = this.lastLogin;
    data['global_notifications'] = this.globalNotifications;
    data['default_lang'] = this.defaultLang;
    data['token'] = this.token;
    data['message_count'] = this.messageCount;
    data['notification_count'] = this.notificationCount;
    return data;
  }
}

class Roles {
  int? id;
  String? name;

  Roles({this.id, this.name});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
