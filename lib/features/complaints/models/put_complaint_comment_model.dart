class PutComplaintCommentModel {
  CommentData? data;
  String? message;

  PutComplaintCommentModel({this.data, this.message});

  PutComplaintCommentModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CommentData.fromJson(json['data']) : null;
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

class CommentData {
  int? id;
  String? user;
  String? profilePhoto;
  String? title;
  String? content;
  String? file;
  String? status;
  String? categoryName;
  Null? assigned;
  String? createdAt;
  String? updatedAt;

  CommentData(
      {this.id,
        this.user,
        this.profilePhoto,
        this.title,
        this.content,
        this.file,
        this.status,
        this.categoryName,
        this.assigned,
        this.createdAt,
        this.updatedAt});

  CommentData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    profilePhoto = json['profile_photo'];
    title = json['title'];
    content = json['content'];
    file = json['file'];
    status = json['status'];
    categoryName = json['category_name'];
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
    data['assigned'] = this.assigned;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
