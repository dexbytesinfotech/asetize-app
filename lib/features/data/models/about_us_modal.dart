class AboutUsModal {
  List<AboutData>? aboutData;
  String? message;

  AboutUsModal({this.aboutData, this.message});

  AboutUsModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      aboutData = <AboutData>[];
      json['data'].forEach((v) {
        aboutData!.add(new AboutData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (aboutData != null) {
      data['data'] = aboutData!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class AboutData {
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

  AboutData(
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

  AboutData.fromJson(Map<String, dynamic> json) {
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
    data['id'] = id;
    data['title'] = title;
    data['slug'] = slug;
    data['content'] = content;
    data['status'] = status;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['post_type'] = postType;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
