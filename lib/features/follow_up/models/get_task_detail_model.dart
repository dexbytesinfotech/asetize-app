class GetTaskDetailModel {
  GetTaskDetailData? data;
  String? message;

  GetTaskDetailModel({this.data, this.message});

  GetTaskDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new GetTaskDetailData.fromJson(json['data']) : null;
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

class GetTaskDetailData {
  int? id;
  String? title;
  String? description;
  String? moduleName;
  int? moduleId;
  String? dueDate;
  String? dueDateDisplay;
  String? priority;
  int? houseId;
  String? houseNumber;
  HouseOwner? houseOwner;

  CreatedBy? createdBy;
  String? createdAt;
  String? updatedAt;
  String? status;
  CreatedBy? assignee;
  List<Followups>? followups;
  LastFollowups? lastFollowups;
  List<String>? completedImages;
  List<String>? taskImages;


  String? completedRemark;
  CreatedBy? completedBy;
  String? completedAt;
  Complaint? complaint;
  bool? hasApprovedQuotation;


  GetTaskDetailData(
      {this.id,
        this.title,
        this.description,
        this.moduleName,
        this.moduleId,
        this.houseOwner,
        this.dueDate,
        this.priority,
        this.houseId,
        this.houseNumber,
        this.createdBy,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.assignee,
        this.followups,
        this.lastFollowups,
        this.completedRemark,
        this.completedImages,
        this.taskImages,
        this.completedBy,
        this.dueDateDisplay,
        this.complaint,
        this.hasApprovedQuotation,
        this.completedAt});

  GetTaskDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    moduleName = json['module_name'];
    moduleId = json['module_id'];
    dueDate = json['due_date'];
    priority = json['priority'];
    houseId = json['house_id'];
    hasApprovedQuotation = json['has_approved_quotation'];
    dueDateDisplay = json['due_date_display'];

    houseNumber = json['house_number'];
    houseOwner = json['house_owner'] != null
        ? new HouseOwner.fromJson(json['house_owner'])
        : null;
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    completedImages = json['completed_images'].cast<String>();
    taskImages = json['task_images'].cast<String>();

    status = json['status'];
    assignee = json['assignee'] != null
        ? new CreatedBy.fromJson(json['assignee'])
        : null;
    if (json['followups'] != null) {
      followups = <Followups>[];
      json['followups'].forEach((v) {
        followups!.add(new Followups.fromJson(v));
      });
    }
    lastFollowups = json['last_followups'] != null
        ? new LastFollowups.fromJson(json['last_followups'])
        : null;
    completedRemark = json['completed_remark'];
    completedBy = json['completedBy'] != null
        ? new CreatedBy.fromJson(json['completedBy'])
        : null;
    completedAt = json['completed_at'];
    complaint = json['complaint'] != null ? new Complaint.fromJson(json['complaint']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['module_name'] = this.moduleName;
    data['module_id'] = this.moduleId;
    data['has_approved_quotation'] = this.hasApprovedQuotation;
    data['due_date'] = this.dueDate;
    data['due_date_display'] = this.dueDateDisplay;
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
    if (this.followups != null) {
      data['followups'] = this.followups!.map((v) => v.toJson()).toList();
    }
    if (this.lastFollowups != null) {
      data['last_followups'] = this.lastFollowups!.toJson();
    }
    data['completed_remark'] = this.completedRemark;
    if (this.completedBy != null) {
      data['completedBy'] = this.completedBy!.toJson();
    }
    data['completed_at'] = this.completedAt;
    data['completed_images'] = this.completedImages;
    data['task_images'] = this.taskImages;
    if (this.complaint != null) {
      data['complaint'] = this.complaint!.toJson();
    }

    return data;
  }
}

class CreatedBy {
  int? id;
  String? name;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  AdditionalInfo? additionalInfo;

  CreatedBy(
      {this.name,
        this.email,
        this.jobTitle,
        this.profilePhoto,
        this.additionalInfo});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
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
    data['id'] = this.id;
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

class Followups {
  int? id;
  int? taskId;
  int? userId;
  String? remark;
  String? followupDate;
  String? createdAt;
  String? updatedAt;

  Followups(
      {this.id,
        this.taskId,
        this.userId,
        this.remark,
        this.followupDate,
        this.createdAt,
        this.updatedAt});

  Followups.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    userId = json['user_id'];
    remark = json['remark'];
    followupDate = json['followup_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['user_id'] = this.userId;
    data['remark'] = this.remark;
    data['followup_date'] = this.followupDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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

class AdditionalInfoForHouseOnwer {
  String? phone;
  String? bloodGroup;

  AdditionalInfoForHouseOnwer({this.phone, this.bloodGroup});

  AdditionalInfoForHouseOnwer.fromJson(Map<String, dynamic> json) {
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


class HouseOwner {
  int? id;
  String? name;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  AdditionalInfoForHouseOnwer? additionalInfoForHouseOnwer;

  HouseOwner({
    this.id,
    this.name,
    this.email,
    this.jobTitle,
    this.profilePhoto,
    this.additionalInfoForHouseOnwer,
  });

  HouseOwner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    jobTitle = json['job_title'];
    profilePhoto = json['profile_photo'];
    additionalInfoForHouseOnwer = json['additional_info'] != null
        ? AdditionalInfoForHouseOnwer.fromJson(json['additional_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['job_title'] = jobTitle;
    data['profile_photo'] = profilePhoto;
    if (additionalInfoForHouseOnwer != null) {
      data['additional_info'] = additionalInfoForHouseOnwer!.toJson();
    }
    return data;
  }
}


class Complaint {
  int? id;
  String? user;
  String? profilePhoto;
  String? title;
  String? content;
  String? file;
  String? status;
  String? categoryName;
  bool? isMyComplain;
  String? createdAt;
  String? updatedAt;

  Complaint({this.id, this.user, this.profilePhoto, this.title, this.content, this.file, this.status, this.categoryName, this.isMyComplain, this.createdAt, this.updatedAt});

  Complaint.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    profilePhoto = json['profile_photo'];
    title = json['title'];
    content = json['content'];
    file = json['file'];
    status = json['status'];
    categoryName = json['category_name'];
    isMyComplain = json['is_my_complain'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['profile_photo'] = this.profilePhoto;
    data['title'] = this.title;
    data['content'] = this.content;
    data['file'] = this.file;
    data['status'] = this.status;
    data['category_name'] = this.categoryName;
    data['is_my_complain'] = this.isMyComplain;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
