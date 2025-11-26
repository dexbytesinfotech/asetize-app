class PolicyModel {
  List<Data>? data;
  String? message;
  Pagination? pagination;

  PolicyModel({this.data, this.message, this.pagination});

  PolicyModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? id;
  String? title;
  String? content;
  int? fileCount;
  List<Files>? files;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
      this.title,
      this.content,
      this.fileCount,
      this.files,
      this.createdAt,
      this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    fileCount = json['file_count'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['file_count'] = this.fileCount;
    if (this.files != null) {
      data['files'] = this.files!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Files {
  String? fileName;
  String? type;
  String? fileSize;
  String? url;
  String? createdAt;

  Files({this.fileName, this.type, this.fileSize, this.url, this.createdAt});

  Files.fromJson(Map<String, dynamic> json) {
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
