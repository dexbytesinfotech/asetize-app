import 'complaint_data_model.dart';

class ComplaintCommentModel {
  ComplaintComments? data;
  String? message;

  ComplaintCommentModel({this.data, this.message});

  ComplaintCommentModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ComplaintComments.fromJson(json['data']) : null;
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

