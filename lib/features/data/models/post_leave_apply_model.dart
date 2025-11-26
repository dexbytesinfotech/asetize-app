class PostLeaveApplyModel {
  LeaveApplyData? data;
  String? message;

  PostLeaveApplyModel({this.data, this.message});

  PostLeaveApplyModel.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new LeaveApplyData.fromJson(json['data']) : null;
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

class LeaveApplyData {
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

  LeaveApplyData(
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
      this.createdAt});

  LeaveApplyData.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
