class FeedDataModel {
  List<FeedData>? data;
  String? message;
  FeedPagination? pagination;

  FeedDataModel({this.data, this.message, this.pagination});

  FeedDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FeedData>[];
      json['data'].forEach((v) {
        data!.add(new FeedData.fromJson(v));
      });
    }
    message = json['message'];
    pagination = json['pagination'] != null
        ? new FeedPagination.fromJson(json['pagination'])
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

class FeedData {
  int? id;
  String? postCategory;
  String? title;
  String? content;
  String? publishedAt;
  FeedUser? feedUser;
  int? likeCount;
  String? likeTitle;
  bool? isLike;
  List<Likes>? likes;
  int? commentCount;
  String? commentTitle;
  List<Comments>? comments;
  String? fileCount;
  List<FeedFiles>? feedFiles;

  FeedData(
      {this.id,
      this.postCategory,
      this.title,
      this.content,
      this.publishedAt,
      this.feedUser,
      this.likeCount,
      this.likeTitle,
      this.isLike,
      this.likes,
      this.commentCount,
      this.commentTitle,
      this.comments,
      this.fileCount,
      this.feedFiles});

  FeedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postCategory = json['post_category'];
    title = json['title'];
    content = json['content'];
    publishedAt = json['published_at'];
    feedUser =
        json['user'] != null ? new FeedUser.fromJson(json['user']) : null;
    likeCount = json['like_count'];
    likeTitle = json['like_title'];
    isLike = json['is_like'];
    if (json['likes'] != null) {
      likes = <Likes>[];
      json['likes'].forEach((v) {
        likes!.add(new Likes.fromJson(v));
      });
    }
    commentCount = json['comment_count'];
    commentTitle = json['comment_title'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
    fileCount = json['file_count'];
    if (json['files'] != null) {
      feedFiles = <FeedFiles>[];
      json['files'].forEach((v) {
        feedFiles!.add(new FeedFiles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_category'] = this.postCategory;
    data['title'] = this.title;
    data['content'] = this.content;
    data['published_at'] = this.publishedAt;
    if (this.feedUser != null) {
      data['user'] = this.feedUser!.toJson();
    }
    data['like_count'] = this.likeCount;
    data['like_title'] = this.likeTitle;
    data['is_like'] = this.isLike;
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    data['comment_count'] = this.commentCount;
    data['comment_title'] = this.commentTitle;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['file_count'] = this.fileCount;
    if (this.feedFiles != null) {
      data['files'] = this.feedFiles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeedUser {
  String? name;
  String? jobTitle;
  String? profilePhoto;

  FeedUser({this.name, this.jobTitle, this.profilePhoto});

  FeedUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    jobTitle = json['job_title'];
    profilePhoto = json['profile_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['job_title'] = this.jobTitle;
    data['profile_photo'] = this.profilePhoto;
    return data;
  }
}

class Likes {
  FeedUser? user;
  String? createdAt;

  Likes({this.user, this.createdAt});

  Likes.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new FeedUser.fromJson(json['user']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}

class FeedFiles {
  String? fileName;
  String? type;
  String? fileSize;
  String? url;
  String? createdAt;

  FeedFiles(
      {this.fileName, this.type, this.fileSize, this.url, this.createdAt});

  FeedFiles.fromJson(Map<String, dynamic> json) {
    fileName = json['file_name'];
    type = json['type'];
    fileSize = json['file_size'];
    url = json['url'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_name'] = this.fileName;
    data['type'] = this.type;
    data['file_size'] = this.fileSize;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class FeedPagination {
  int? currentPage;
  String? prevPageApiUrl;
  String? nextPageApiUrl;
  int? perPage;

  FeedPagination(
      {this.currentPage,
      this.prevPageApiUrl,
      this.nextPageApiUrl,
      this.perPage});

  FeedPagination.fromJson(Map<String, dynamic> json) {
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

class Comments {
  int? commentId;
  bool? isMyComment;
  FeedUser? user;
  String? comment;
  String? createdAt;

  Comments({ this.isMyComment,this.user, this.comment, this.commentId, this.createdAt});

  Comments.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    isMyComment = json['is_my_comment'];
    user = json['user'] != null ? new FeedUser.fromJson(json['user']) : null;
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
