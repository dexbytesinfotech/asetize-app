class FindHelperModel {
  List<FindHelperData>? data;
  String? message;
  Pagination? pagination;


  FindHelperModel({this.data, this.message, this.pagination});


  FindHelperModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FindHelperData>[];
      json['data'].forEach((v) {
        data!.add(new FindHelperData.fromJson(v));
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


class FindHelperData {
  String? name;
  String? contact;
  String? countryCode;
  String? skills;
  String? profilePicture;


  FindHelperData({this.name, this.contact, this.skills, this.profilePicture});


  FindHelperData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contact = json['contact'];
    countryCode = json['country_code'];
    skills = json['skills'];
    profilePicture = json['profile_picture'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact'] = this.contact;
    data['country_code'] = this.countryCode;
    data['skills'] = this.skills;
    data['profile_picture'] = this.profilePicture;
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
