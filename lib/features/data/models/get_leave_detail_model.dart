import 'package:asetize/features/data/models/user_response_model.dart';
import '../../../core/util/project_util.dart';

class GetLeaveDetailModel {
  LeaveDetail? data;
  String? message;

  GetLeaveDetailModel({this.data, this.message});

  GetLeaveDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LeaveDetail.fromJson(json['data']) : null;
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

class LeaveDetail {
  int? id;
  String? name;
  String? status;
  String? duration;
  String? leaveType;
  String? startDate;
  String? endDate;
  String? assignedName;
  String? assignedId;
  String? createdAt;
  double? totalDays;
  String? reason;
  String? messages;
  User? user;
  Assigned? assigned;

  LeaveDetail(
      {this.id,
      this.name,
      this.status,
      this.duration,
      this.leaveType,
      this.startDate,
      this.endDate,
      this.assignedName,
      this.assignedId,
      this.createdAt,
      this.totalDays,
      this.reason,
      this.messages,
      this.user,
      this.assigned});

  LeaveDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    duration = json['duration'];
    leaveType = json['leave_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    assignedName = json['assigned_name'];
    assignedId = json['assigned_id'];
    createdAt = json['created_at'];
    totalDays = projectUtil.intToDouble(json['total_days']);
    reason = json['reason'];
    messages = json['messages'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    assigned = (json['assigned'] != null
        ? new Assigned.fromJson(json['assigned'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['status'] = this.status;
    data['duration'] = this.duration;
    data['leave_type'] = this.leaveType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['assigned_name'] = this.assignedName;
    data['assigned_id'] = this.assignedId;
    data['created_at'] = this.createdAt;
    data['total_days'] = this.totalDays;
    data['reason'] = this.reason;
    data['messages'] = this.messages;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.assigned != null) {
      data['assigned'] = this.assigned!.toJson();
    }
    return data;
  }
}

class Assigned {
  Assigned();

  Assigned.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
