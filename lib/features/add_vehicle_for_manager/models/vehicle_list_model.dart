import '../../data/models/user_response_model.dart';

class VehicleListModel {
  List<VehicleListData>? data;
  String? message;
  Pagination? pagination;

  VehicleListModel({this.data, this.message, this.pagination});

  VehicleListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VehicleListData>[];
      json['data'].forEach((v) {
        data!.add(new VehicleListData.fromJson(v));
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

class VehicleListData {
  int? id;
  String? registrationNumber;
  String? ownerName;
  String? vehicleType;
  String? make;
  String? model;
  String? colors;
  String? filePath;
  int? isParkingAllotted;
  String? blockName;
  String? registrationPhoto;
  User? user;

  VehicleListData(
      {this.id,
        this.registrationNumber,
        this.ownerName,
        this.vehicleType,
        this.make,
        this.model,
        this.colors,
        this.filePath,
        this.isParkingAllotted,
        this.blockName,
        this.registrationPhoto,
        this.user});

  VehicleListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registrationNumber = json['registration_number'];
    ownerName = json['owner_name'];
    vehicleType = json['vehicle_type'];
    make = json['make'];
    model = json['model'];
    colors = json['colors'];
    filePath = json['file_path'];
    isParkingAllotted = json['is_parking_allotted'];
    blockName = json['block_name'];
    registrationPhoto = json['registration_photo'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['registration_number'] = this.registrationNumber;
    data['owner_name'] = this.ownerName;
    data['vehicle_type'] = this.vehicleType;
    data['make'] = this.make;
    data['model'] = this.model;
    data['colors'] = this.colors;
    data['file_path'] = this.filePath;
    data['is_parking_allotted'] = this.isParkingAllotted;
    data['block_name'] = this.blockName;
    data['registration_photo'] = this.registrationPhoto;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
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
