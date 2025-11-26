class AssetsMemberListModel {
  List<AssetsMemberListData>? data;
  String? message;
  Pagination? pagination;

  AssetsMemberListModel({this.data, this.message, this.pagination});

  AssetsMemberListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AssetsMemberListData>[];
      json['data'].forEach((v) {
        data!.add(new AssetsMemberListData.fromJson(v));
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

class AssetsMemberListData {
  int? id;
  String? name;
  String? profilePhoto;
  String? countryCode;
  String? phone;

  AssetsMemberListData({this.id, this.name, this.profilePhoto, this.countryCode, this.phone});

  AssetsMemberListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePhoto = json['profile_photo'];
    countryCode = json['country_code'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_photo'] = this.profilePhoto;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    return data;
  }
}

class Pagination {
  int? currentPage;
  String? prevPageApiUrl;
  String? nextPageApiUrl;
  int? lastPage;
  int? perPage;
  int? total;

  Pagination(
      {this.currentPage,
        this.prevPageApiUrl,
        this.nextPageApiUrl,
        this.lastPage,
        this.perPage,
        this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    prevPageApiUrl = json['prev_page_api_url'];
    nextPageApiUrl = json['next_page_api_url'];
    lastPage = json['last_page'];
    perPage = json['per_page'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['prev_page_api_url'] = this.prevPageApiUrl;
    data['next_page_api_url'] = this.nextPageApiUrl;
    data['last_page'] = this.lastPage;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    return data;
  }
}
