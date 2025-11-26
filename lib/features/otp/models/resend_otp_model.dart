class ResendOtpModel {
  ResendOtpData? data;
  String? message;

  ResendOtpModel({this.data, this.message});

  ResendOtpModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ResendOtpData.fromJson(json['data']) : null;
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

class ResendOtpData {
  String? email;
  ResendOtpData({this.email});
  ResendOtpData.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    return data;
  }
}
