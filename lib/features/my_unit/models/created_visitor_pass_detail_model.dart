class CreatedVisitorPassDetailModel {
  CreatedVisitorPassDetailData? data;
  String? message;

  CreatedVisitorPassDetailModel({this.data, this.message});

  CreatedVisitorPassDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new CreatedVisitorPassDetailData.fromJson(json['data']) : null;
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

class CreatedVisitorPassDetailData {
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
  List<VisitorHouses>? visitorHousesDetail;
  String? originalEntryTime;
  String? originalExitTime;
  bool? allowCheckin;

  CreatedVisitorPassDetailData(
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
        this.visitorHousesDetail,
        this.originalEntryTime,
        this.originalExitTime,
        this.allowCheckin});

  CreatedVisitorPassDetailData.fromJson(Map<String, dynamic> json) {
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
    if (json['houses'] != null) {
      visitorHousesDetail = <VisitorHouses>[];
      json['houses'].forEach((v) {
        visitorHousesDetail!.add(new VisitorHouses.fromJson(v));
      });
    }
    originalEntryTime = json['original_entry_time'];
    originalExitTime = json['original_exit_time'];
    allowCheckin = json['allow_checkin'];
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
    if (this.visitorHousesDetail != null) {
      data['houses'] = this.visitorHousesDetail!.map((v) => v.toJson()).toList();
    }
    data['original_entry_time'] = this.originalEntryTime;
    data['original_exit_time'] = this.originalExitTime;
    data['allow_checkin'] = this.allowCheckin;
    return data;
  }
}

class VisitorHouses {
  int? entryHouseId;
  bool? preApproved;
  String? approvalStatus;
  String? houseName;
  String? ownerName;
  String? ownerPhone;

  VisitorHouses(
      {this.entryHouseId,
        this.preApproved,
        this.approvalStatus,
        this.houseName,
        this.ownerName,
        this.ownerPhone});

  VisitorHouses.fromJson(Map<String, dynamic> json) {
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
