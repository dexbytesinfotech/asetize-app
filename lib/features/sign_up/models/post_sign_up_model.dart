class SignUpModel {
  SignUpData? data;
  String? message;

  SignUpModel({this.data, this.message});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SignUpData.fromJson(json['data']) : null;
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

class SignUpData {
  String? token;
  String? email;

  SignUpData({this.token, this.email});

  SignUpData.fromJson(Map<String, dynamic> json) {
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
