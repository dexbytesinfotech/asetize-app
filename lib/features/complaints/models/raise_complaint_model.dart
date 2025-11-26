import 'complaint_data_model.dart';

class RaiseComplaintModel {
  ComplaintData? data;
  String? message;

  RaiseComplaintModel({this.data, this.message});

  RaiseComplaintModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ComplaintData.fromJson(json['data']) : null;
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

