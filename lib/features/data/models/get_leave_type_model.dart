import 'package:asetize/core/core.dart';

class GetLeaveTypeModel {
  List<LeaveTypeData>? data;
  String? message;

  GetLeaveTypeModel({this.data, this.message});

  GetLeaveTypeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LeaveTypeData>[];
      json['data'].forEach((v) {
        data!.add(new LeaveTypeData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class LeaveTypeData {
  int? id;
  String? title;
  String? name;
  String? paidStatus;
  double? noOfLeaves;
  double? availableLeave;
  int? monthlyLimit;
  String? colorCode;
  double? totalLeaveTaken;

  LeaveTypeData(
      {this.id,
      this.title,
      this.name,
      this.paidStatus,
      this.noOfLeaves,
      this.availableLeave,
      this.monthlyLimit,
      this.totalLeaveTaken,
      this.colorCode});

  LeaveTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    name = json['name'];
    paidStatus = json['paid_status'];
    noOfLeaves = projectUtil.intToDouble(json['no_of_leaves']);
    availableLeave = projectUtil.intToDouble(json['available_leave']);
    totalLeaveTaken = projectUtil.intToDouble(json['total_leave_taken']);
    monthlyLimit = json['monthly_limit'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['name'] = this.name;
    data['paid_status'] = this.paidStatus;
    data['no_of_leaves'] = this.noOfLeaves;
    data['available_leave'] = this.availableLeave;
    data['total_leave_taken'] = this.totalLeaveTaken;
    data['monthly_limit'] = this.monthlyLimit;
    data['color_code'] = this.colorCode;
    return data;
  }
}
