import 'package:asetize/core/core.dart';
import 'package:asetize/features/data/models/user_response_model.dart';

class GetLeaveDataModel {
  List<LeaveAppliedData>? data;
  String? message;
  LeavePagination? pagination;

  GetLeaveDataModel({this.data, this.message, this.pagination});

  GetLeaveDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LeaveAppliedData>[];
      json['data'].forEach((v) {
        data!.add(new LeaveAppliedData.fromJson(v));
      });
    }
    message = json['message'];
    pagination = json['pagination'] != null
        ? new LeavePagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class LeaveAppliedData {
  int? id;
  String? name;
  String? status;
  String? duration;
  String? leaveType;
  String? reason;
  String? startDate;
  String? endDate;
  String? assignedName;
  String? assignedId;
  String? createdAt;
  double? totalDays;
  String? messages;
  User? user;

  LeaveAppliedData(
      {this.id,
      this.name,
      this.status,
      this.duration,
      this.leaveType,
      this.reason,
      this.startDate,
      this.endDate,
      this.assignedName,
      this.assignedId,
      this.createdAt,
      this.totalDays,
      this.messages,
      this.user});

  LeaveAppliedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    duration = json['duration'];
    leaveType = json['leave_type'];
    reason = json['reason'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    assignedName = json['assigned_name'];
    assignedId = json['assigned_id'];
    createdAt = json['created_at'];
    totalDays = projectUtil.intToDouble(json['total_days']);
    messages = json['messages'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['leave_type'] = this.leaveType;
    data['reason'] = this.reason;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['assigned_name'] = this.assignedName;
    data['assigned_id'] = this.assignedId;
    data['created_at'] = this.createdAt;
    data['total_days'] = this.totalDays;
    data['messages'] = this.messages;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class LeavePagination {
  int? currentPage;
  String? prevPageApiUrl;
  String? nextPageApiUrl;
  int? perPage;

  LeavePagination(
      {this.currentPage,
      this.prevPageApiUrl,
      this.nextPageApiUrl,
      this.perPage});

  LeavePagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    prevPageApiUrl = json['prev_page_api_url'];
    nextPageApiUrl = json['next_page_api_url'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['prev_page_api_url'] = this.prevPageApiUrl;
    data['next_page_api_url'] = this.nextPageApiUrl;
    data['per_page'] = this.perPage;
    return data;
  }
}
