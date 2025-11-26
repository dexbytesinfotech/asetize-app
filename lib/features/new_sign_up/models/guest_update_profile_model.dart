class GuestUpdateProfileModel {
  GuestUpdateProfileData? data;
  String? message;

  GuestUpdateProfileModel({this.data, this.message});

  GuestUpdateProfileModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GuestUpdateProfileData.fromJson(json['data']) : null;
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

class GuestUpdateProfileData {
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  bool? globalNotifications;
  String? defaultLang;
  List<Companies>? companies;
  String? token;
  List<Roles>? roles;
  bool? isCompleteProfile;

  GuestUpdateProfileData(
      {this.name,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.globalNotifications,
        this.defaultLang,
        this.companies,
        this.token,
        this.roles,
        this.isCompleteProfile});

  GuestUpdateProfileData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    globalNotifications = json['global_notifications'];
    defaultLang = json['default_lang'];
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(new Companies.fromJson(v));
      });
    }
    token = json['token'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(new Roles.fromJson(v));
      });
    }
    isCompleteProfile = json['is_complete_profile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['global_notifications'] = this.globalNotifications;
    data['default_lang'] = this.defaultLang;
    if (this.companies != null) {
      data['companies'] = this.companies!.map((v) => v.toJson()).toList();
    }
    data['token'] = this.token;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    data['is_complete_profile'] = this.isCompleteProfile;
    return data;
  }
}

class Companies {
  int? id;
  String? name;
  String? roleName;
  String? status;

  Companies({this.id, this.name, this.roleName, this.status});

  Companies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roleName = json['role_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role_name'] = this.roleName;
    data['status'] = this.status;
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
