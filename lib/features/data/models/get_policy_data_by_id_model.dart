import 'get_policy_data_model.dart';

class GetPolicyDataByIdModel {
  PolicyData? data;
  String? message;

  GetPolicyDataByIdModel({this.data, this.message});

  GetPolicyDataByIdModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PolicyData.fromJson(json['data']) : null;
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
