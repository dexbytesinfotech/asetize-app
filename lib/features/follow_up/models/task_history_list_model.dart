class TaskHistoryListModel {
  List<TaskHistoryListData>? data;
  String? message;

  TaskHistoryListModel({this.data, this.message});

  TaskHistoryListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TaskHistoryListData>[];
      json['data'].forEach((v) {
        data!.add(new TaskHistoryListData.fromJson(v));
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

class TaskHistoryListData {
  int? id;
  int? taskId;
  int? userId;
  bool? isMyActivity;
  String? type;
  String? description;
  String? createdAt;
  String? updatedAt;
  User? user;

  TaskHistoryListData(
      {this.id,
        this.taskId,
        this.userId,
        this.isMyActivity,
        this.type,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.user});

  TaskHistoryListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    isMyActivity = json['is_my_activity'];
    type = json['type'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['user_id'] = this.userId;
    data['is_my_activity'] = this.isMyActivity;
    data['type'] = this.type;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  AdditionalInfo? additionalInfo;

  User(
      {this.id,
        this.name,
        this.email,
        this.jobTitle,
        this.profilePhoto,
        this.additionalInfo});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    jobTitle = json['job_title'];
    profilePhoto = json['profile_photo'];
    additionalInfo = json['additional_info'] != null
        ? new AdditionalInfo.fromJson(json['additional_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['job_title'] = this.jobTitle;
    data['profile_photo'] = this.profilePhoto;
    if (this.additionalInfo != null) {
      data['additional_info'] = this.additionalInfo!.toJson();
    }
    return data;
  }
}

class AdditionalInfo {
  String? phone;
  String? bloodGroup;

  AdditionalInfo({this.phone, this.bloodGroup});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    bloodGroup = json['blood_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['blood_group'] = this.bloodGroup;
    return data;
  }
}
