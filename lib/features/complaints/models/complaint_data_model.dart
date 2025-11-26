
class ComplaintDataModel {
  List<ComplaintData>? data;
  String? message;
  Pagination? pagination;

  ComplaintDataModel({this.data, this.message, this.pagination});

  ComplaintDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ComplaintData>[];
      json['data'].forEach((v) {
        data!.add(new ComplaintData.fromJson(v));
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

class ComplaintData {
  int? id;
  String? user;
  String? profilePhoto;
  String? title;
  String? content;
  String? file;
  String? status;
  String? categoryName;
  bool? isMyComplain;
  int? commentCount;
  String? commentTitle;
  List<ComplaintComments>? comments;
  String? assigned;
  String? createdAt;
  String? updatedAt;

  ComplaintData(
      {this.id,
        this.user,
        this.profilePhoto,
        this.title,
        this.content,
        this.file,
        this.status,
        this.categoryName,
        this.isMyComplain,
        this.commentCount,
        this.commentTitle,
        this.comments,
        this.assigned,
        this.createdAt,
        this.updatedAt});

  ComplaintData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    profilePhoto = json['profile_photo'];
    title = json['title'];
    content = json['content'];
    file = json['file'];
    status = json['status'];
    categoryName = json['category_name'];
    isMyComplain = json['is_my_complain'];
    commentCount = json['comment_count'];
    commentTitle = json['comment_title'];
    if (json['comments'] != null) {
      comments = <ComplaintComments>[];
      json['comments'].forEach((v) {
        comments!.add(new ComplaintComments.fromJson(v));
      });
    }
    assigned = json['assigned'];
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
    data['comment_count'] = this.commentCount;
    data['comment_title'] = this.commentTitle;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['assigned'] = this.assigned;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ComplaintComments {
  int? commentId;
  bool? isMyComment;
  ComplaintUser? user;
  String? comment;
  String? createdAt;

  ComplaintComments(
      {this.commentId,
        this.isMyComment,
        this.user,
        this.comment,
        this.createdAt});

  ComplaintComments.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    isMyComment = json['is_my_comment'];
    user = json['user'] != null ? new ComplaintUser.fromJson(json['user']) : null;
    comment = json['comment'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['is_my_comment'] = this.isMyComment;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['comment'] = this.comment;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class ComplaintUser {
  String? name;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  AdditionalInfo? additionalInfo;

  ComplaintUser(
      {this.name,
        this.email,
        this.jobTitle,
        this.profilePhoto,
        this.additionalInfo});

  ComplaintUser.fromJson(Map<String, dynamic> json) {
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
