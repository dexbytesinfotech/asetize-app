class GuestOtpResendModel {
  GuestOtpResendData? data;
  String? message;

  GuestOtpResendModel({this.data, this.message});

  GuestOtpResendModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GuestOtpResendData.fromJson(json['data']) : null;
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

class GuestOtpResendData {
  String? email;

  GuestOtpResendData({this.email});

  GuestOtpResendData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}