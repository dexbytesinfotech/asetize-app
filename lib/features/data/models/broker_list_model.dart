class BrokerListModel {
  List<BrokerListData>? data;
  String? message;
  Pagination? pagination;

  BrokerListModel({this.data, this.message, this.pagination});

  BrokerListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BrokerListData>[];
      json['data'].forEach((v) {
        data!.add(new BrokerListData.fromJson(v));
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

class BrokerListData {
  int? id;
  String? name;
  String? profilePhoto;
  String? email;
  String? countryCode;
  String? phone;
  String? shortDescription;
  AdditionalInfo? additionalInfo;
  String? jobTitle;

  BrokerListData(
      {this.id,
        this.name,
        this.profilePhoto,
        this.email,
        this.countryCode,
        this.phone,
        this.shortDescription,
        this.additionalInfo,
        this.jobTitle});

  BrokerListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePhoto = json['profile_photo'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    shortDescription = json['short_description'];
    additionalInfo = json['additional_info'] != null
        ? new AdditionalInfo.fromJson(json['additional_info'])
        : null;
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_photo'] = this.profilePhoto;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['short_description'] = this.shortDescription;
    if (this.additionalInfo != null) {
      data['additional_info'] = this.additionalInfo!.toJson();
    }
    data['job_title'] = this.jobTitle;
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