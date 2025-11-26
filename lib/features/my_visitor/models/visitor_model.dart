class VisitorModel {
  List<VisitorData>? data;
  String? message;
  Pagination? pagination;

  VisitorModel({this.data, this.message, this.pagination});

  VisitorModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VisitorData>[];
      json['data'].forEach((v) {
        data!.add(new VisitorData.fromJson(v));
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

class VisitorData {
  int? entryId;
  int? visitorId;
  String? status;
  String? housesNames;
  String? totalVisitors;
  String? name;
  String? phone;
  String? countryCode;
  String? visitorCode;
  String? photo;
  String? photoUrl;
  String? visitorType;
  String? visitorTypeName;
  String? organization;
  String? entryTime;
  String? exitTime;
  Vehicle? vehicle;
  List<Houses>? houses;

  VisitorData(
      {this.entryId,
        this.visitorId,
        this.status,
        this.housesNames,
        this.totalVisitors,
        this.name,
        this.phone,
        this.countryCode,
        this.visitorCode,
        this.photo,
        this.photoUrl,
        this.visitorType,
        this.visitorTypeName,
        this.organization,
        this.entryTime,
        this.exitTime,
        this.vehicle,
        this.houses});

  VisitorData.fromJson(Map<String, dynamic> json) {
    entryId = json['entry_id'];
    visitorId = json['visitor_id'];
    status = json['status'];
    housesNames = json['houses_names'];
    totalVisitors = json['total_visitors'];
    name = json['name'];
    phone = json['phone'];
    countryCode = json['country_code'];
    visitorCode = json['visitor_code'];
    photo = json['photo'];
    photoUrl = json['photo_url'];
    visitorType = json['visitor_type'];
    visitorTypeName = json['visitor_type_name'];
    organization = json['organization'];
    entryTime = json['entry_time'];
    exitTime = json['exit_time'];
    vehicle =
    json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
    if (json['houses'] != null) {
      houses = <Houses>[];
      json['houses'].forEach((v) {
        houses!.add(new Houses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entry_id'] = this.entryId;
    data['visitor_id'] = this.visitorId;
    data['status'] = this.status;
    data['houses_names'] = this.housesNames;
    data['total_visitors'] = this.totalVisitors;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['country_code'] = this.countryCode;
    data['visitor_code'] = this.visitorCode;
    data['photo'] = this.photo;
    data['photo_url'] = this.photoUrl;
    data['visitor_type'] = this.visitorType;
    data['visitor_type_name'] = this.visitorTypeName;
    data['organization'] = this.organization;
    data['entry_time'] = this.entryTime;
    data['exit_time'] = this.exitTime;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle!.toJson();
    }
    if (this.houses != null) {
      data['houses'] = this.houses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Vehicle {
  String? vehicleType;
  String? vehicleNumber;
  String? status;

  Vehicle({this.vehicleType, this.vehicleNumber, this.status});

  Vehicle.fromJson(Map<String, dynamic> json) {
    vehicleType = json['vehicle_type'];
    vehicleNumber = json['vehicle_number'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_type'] = this.vehicleType;
    data['vehicle_number'] = this.vehicleNumber;
    data['status'] = this.status;
    return data;
  }
}

class Houses {
  int? entryHouseId;
  bool? preApproved;
  String? approvalStatus;
  String? houseName;
  String? ownerName;
  String? ownerPhone;

  Houses(
      {this.entryHouseId,
        this.preApproved,
        this.approvalStatus,
        this.houseName,
        this.ownerName,
        this.ownerPhone});

  Houses.fromJson(Map<String, dynamic> json) {
    entryHouseId = json['entry_house_id'];
    preApproved = json['pre_approved'];
    approvalStatus = json['approval_status'];
    houseName = json['house_name'];
    ownerName = json['owner_name'];
    ownerPhone = json['owner_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['entry_house_id'] = this.entryHouseId;
    data['pre_approved'] = this.preApproved;
    data['approval_status'] = this.approvalStatus;
    data['house_name'] = this.houseName;
    data['owner_name'] = this.ownerName;
    data['owner_phone'] = this.ownerPhone;
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
