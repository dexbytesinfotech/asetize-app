class TaskListModel {
  List<TaskListData>? data;
  String? message;
  Pagination? pagination;

  TaskListModel({this.data, this.message, this.pagination});

  TaskListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TaskListData>[];
      json['data'].forEach((v) {
        data!.add(new TaskListData.fromJson(v));
      });
    }
    message = json['message'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
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

class TaskListData {
  int? id;
  String? title;
  String? description;
  String? moduleName;
  int? moduleId;
  String? dueDate;
  String? priority;
  int? houseId;
  String? houseNumber;
  HouseOwner? houseOwner;
  HouseOwner? createdBy;
  String? createdAt;
  String? updatedAt;
  String? status;
  HouseOwner? assignee;
  LastFollowups? lastFollowups;
  String? completedRemark;
  List<String>? completedImages;
  HouseOwner? completedBy;
  String? completedAt;

  TaskListData(
      {this.id,
        this.title,
        this.description,
        this.moduleName,
        this.moduleId,
        this.dueDate,
        this.priority,
        this.houseId,
        this.houseNumber,
        this.houseOwner,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.assignee,
        this.lastFollowups,
        this.completedRemark,
        this.completedImages,
        this.completedBy,
        this.completedAt});

  TaskListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    moduleName = json['module_name'];
    moduleId = json['module_id'];
    dueDate = json['due_date'];
    priority = json['priority'];
    houseId = json['house_id'];
    houseNumber = json['house_number'];
    houseOwner = json['house_owner'] != null
        ? new HouseOwner.fromJson(json['house_owner'])
        : null;
    createdBy = json['created_by'] != null
        ? new HouseOwner.fromJson(json['created_by'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    status = json['status'];
    assignee = json['assignee'] != null
        ? new HouseOwner.fromJson(json['assignee'])
        : null;
    lastFollowups = json['last_followups'] != null
        ? new LastFollowups.fromJson(json['last_followups'])
        : null;
    completedRemark = json['completed_remark'];
    completedImages = json['completed_images'].cast<String>();
    completedBy = json['completedBy'] != null
        ? new HouseOwner.fromJson(json['completedBy'])
        : null;
    completedAt = json['completed_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['module_name'] = this.moduleName;
    data['module_id'] = this.moduleId;
    data['due_date'] = this.dueDate;
    data['priority'] = this.priority;
    data['house_id'] = this.houseId;
    data['house_number'] = this.houseNumber;
    if (this.houseOwner != null) {
      data['house_owner'] = this.houseOwner!.toJson();
    }
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['status'] = this.status;
    if (this.assignee != null) {
      data['assignee'] = this.assignee!.toJson();
    }
    if (this.lastFollowups != null) {
      data['last_followups'] = this.lastFollowups!.toJson();
    }
    data['completed_remark'] = this.completedRemark;
    data['completed_images'] = this.completedImages;
    if (this.completedBy != null) {
      data['completedBy'] = this.completedBy!.toJson();
    }
    data['completed_at'] = this.completedAt;
    return data;
  }
}

class HouseOwner {
  String? name;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  AdditionalInfo? additionalInfo;

  HouseOwner(
      {this.name,
        this.email,
        this.jobTitle,
        this.profilePhoto,
        this.additionalInfo});

  HouseOwner.fromJson(Map<String, dynamic> json) {
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

class LastFollowups {
  int? id;
  int? taskId;
  int? userId;
  String? remarks;
  String? status;
  String? followupDate;
  String? createdAt;
  String? updatedAt;

  LastFollowups(
      {this.id,
        this.taskId,
        this.userId,
        this.remarks,
        this.status,
        this.followupDate,
        this.createdAt,
        this.updatedAt});

  LastFollowups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    remarks = json['remarks'];
    status = json['status'];
    followupDate = json['followup_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['user_id'] = this.userId;
    data['remarks'] = this.remarks;
    data['status'] = this.status;
    data['followup_date'] = this.followupDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Pagination {
  int? currentPage;
  String? prevPageApiUrl;
  String? nextPageApiUrl;
  int? perPage;

  Pagination(
      {this.currentPage,
        this.prevPageApiUrl,
        this.nextPageApiUrl,
        this.perPage});

  Pagination.fromJson(Map<String, dynamic> json) {
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
