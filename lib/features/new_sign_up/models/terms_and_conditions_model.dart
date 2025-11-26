class TermsAndConditionModel {
  List<TermsAndConditionData>? data;
  String? message;

  TermsAndConditionModel({this.data, this.message});

  TermsAndConditionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <TermsAndConditionData>[];
      json['data'].forEach((v) {
        data!.add(new TermsAndConditionData.fromJson(v));
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

class TermsAndConditionData {
  int? id;
  String? title;
  String? slug;
  String? content;
  String? status;
  int? userId;
  String? userName;
  String? postType;
  String? createdAt;
  String? updatedAt;

  TermsAndConditionData(
      {this.id,
        this.title,
        this.slug,
        this.content,
        this.status,
        this.userId,
        this.userName,
        this.postType,
        this.createdAt,
        this.updatedAt});

  TermsAndConditionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    slug = json['slug'];
    content = json['content'];
    status = json['status'];
    userId = json['user_id'];
    userName = json['user_name'];
    postType = json['post_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['slug'] = this.slug;
    data['content'] = this.content;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['post_type'] = this.postType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}