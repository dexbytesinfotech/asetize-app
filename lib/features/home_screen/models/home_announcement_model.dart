class HomeAnnouncementModel {
  HomeAnnouncementData? data;
  String? message;

  HomeAnnouncementModel({this.data, this.message});

  HomeAnnouncementModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HomeAnnouncementData.fromJson(json['data']) : null;
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

class HomeAnnouncementData {
  List<Announcements>? announcements;

  HomeAnnouncementData({this.announcements});

  HomeAnnouncementData.fromJson(Map<String, dynamic> json) {
    if (json['announcements'] != null) {
      announcements = <Announcements>[];
      json['announcements'].forEach((v) {
        announcements!.add(new Announcements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.announcements != null) {
      data['announcements'] =
          this.announcements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Announcements {
  int? id;
  String? title;
  String? featuredImage;
  String? content;
  String? publishedAt;

  Announcements(
      {this.id,
        this.title,
        this.featuredImage,
        this.content,
        this.publishedAt});

  Announcements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    featuredImage = json['featured_image'];
    content = json['content'];
    publishedAt = json['published_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['featured_image'] = this.featuredImage;
    data['content'] = this.content;
    data['published_at'] = this.publishedAt;
    return data;
  }
}