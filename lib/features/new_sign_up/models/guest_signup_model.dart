class GuestSignupModel {
  GuestSignInData? data;
  String? message;

  GuestSignupModel({this.data, this.message});

  GuestSignupModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GuestSignInData.fromJson(json['data']) : null;
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

class GuestSignInData {
  String? token;
  String? email;

  GuestSignInData({this.token, this.email});

  GuestSignInData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['email'] = this.email;
    return data;
  }
}
