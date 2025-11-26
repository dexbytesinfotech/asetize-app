class GetTaskCommentListModel {
  List<GetTaskCommentData>? data;
  String? message;

  GetTaskCommentListModel({this.data, this.message});

  GetTaskCommentListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetTaskCommentData>[];
      json['data'].forEach((v) {
        data!.add(new GetTaskCommentData.fromJson(v));
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

class GetTaskCommentData {
  int? id;
  int? taskId;
  int? userId;
  String? comment;
  String? createdAt;
  String? updatedAt;
  User? user;

  GetTaskCommentData(
      {this.id,
        this.taskId,
        this.userId,
        this.comment,
        this.createdAt,
        this.updatedAt,
        this.user});

  GetTaskCommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? name;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  AdditionalInfo? additionalInfo;

  User(
      {this.name,
        this.email,
        this.jobTitle,
        this.profilePhoto,
        this.additionalInfo});

  User.fromJson(Map<String, dynamic> json) {
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
