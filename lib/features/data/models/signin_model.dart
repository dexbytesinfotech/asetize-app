class SignInModel {
  SignInData? data;
  String? message;
  String? error;

  SignInModel({this.data, this.message, this.error});

  SignInModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SignInData.fromJson(json['data']) : null;
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    data['error'] = error;
    return data;
  }
}

class SignInData {
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? countryCode;
  List<SignInRoles>? roles;
  String? emailVerifiedAt;
  String? lastLogin;
  bool? globalNotifications;
  String? defaultLang;
  String? token;
  String? createdAt;
  String? updatedAt;
  List<CompaniesNew>? companiesNew;

  SignInData(
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
     this.companiesNew,
      this.createdAt,
      this.updatedAt});

  SignInData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    countryCode = json['country_code'];
    if (json['roles'] != null) {
      roles = <SignInRoles>[];
      json['roles'].forEach((v) {
        roles!.add(new SignInRoles.fromJson(v));
      });
    }
    if (json['companies'] != null) {
      companiesNew = <CompaniesNew>[];
      json['companies'].forEach((v) {
        companiesNew!.add(new CompaniesNew.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['country_code'] = countryCode;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    if (companiesNew != null) {
      data['companies'] = companiesNew!.map((v) => v.toJson()).toList();
    }
    data['email_verified_at'] = emailVerifiedAt;
    data['last_login'] = lastLogin;
    data['global_notifications'] = globalNotifications;
    data['default_lang'] = defaultLang;
    data['token'] = token;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SignInRoles {
  String? name;

  SignInRoles({this.name});

  SignInRoles.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class CompaniesNew {
  int? id;
  String? name;
  String? roleCode;
  String? roleName;

  CompaniesNew({this.id, this.name, this.roleCode, this.roleName});

  CompaniesNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    roleCode = json['role_code'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['role_code'] = roleCode;
    data['role_name'] = roleName;
    return data;
  }
}
