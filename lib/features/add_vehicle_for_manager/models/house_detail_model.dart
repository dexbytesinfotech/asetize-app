import 'package:asetize/features/data/models/user_response_model.dart';

class MembersListModel {
  HouseDetailData? data;
  String? message;

  MembersListModel({this.data, this.message});

  MembersListModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HouseDetailData.fromJson(json['data']) : null;
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

class HouseDetailData {
  int? id;
  String? houseNumber;
  String? sizeInSqft;
  String? openingBalance;
  String? notificationsMessage;
  List<Members>? members;
  List<Vehicles>? vehicles;
  int? membersCount;
  int? vehiclesCount;

  HouseDetailData({this.id,  this.sizeInSqft,
    this.openingBalance, this.notificationsMessage,this.houseNumber, this.members,this.vehicles,  this.membersCount,
    this.vehiclesCount});

  HouseDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houseNumber = json['house_number'];
    sizeInSqft = json['size_in_sqft'];
    openingBalance = json['opening_balance'];
    notificationsMessage = json['notifications_messages'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    } if (json['vehicles'] != null) {
      vehicles = <Vehicles>[];
      json['vehicles'].forEach((v) {
        vehicles!.add( Vehicles.fromJson(v));
      });
    }
    membersCount = json['members_count'];
    vehiclesCount = json['vehicles_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['house_number'] = this.houseNumber;
    data['size_in_sqft'] = this.sizeInSqft;
    data['opening_balance'] = this.openingBalance;
    data['notifications_messages'] = this.notificationsMessage;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    if (this.vehicles != null) {
      data['vehicles'] = this.vehicles!.map((v) => v.toJson()).toList();
    }
    data['members_count'] = this.membersCount;
    data['vehicles_count'] = this.vehiclesCount;
    return data;
  }
}

class Members {
  int? id;
  int? houseMemberId;
  String? name;
  String? profilePhoto;
  String? email;
  String? gender;
  String? relationship;
  String? countryCode;
  String? phone;
  String? shortDescription;
  AdditionalInfo? additionalInfo;
  String? jobTitle;
  bool? isPrimary; // Added new variable
  bool? isPublicContact; // Added new variable
  bool? itsMe; // Added new variable

  Members(
      {this.id,
        this.houseMemberId,
        this.name,
        this.profilePhoto,
        this.email,
        this.gender,
        this.relationship,
        this.countryCode,
        this.phone,
        this.shortDescription,
        this.additionalInfo,
        this.jobTitle,
        this.isPrimary,
        this.isPublicContact,
        this.itsMe = false

      }); // Updated constructor

  Members.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houseMemberId = json['house_member_id'];
    name = json['name'];
    profilePhoto = json['profile_photo'];
    email = json['email'];
    gender = json['gender'];
    relationship = json['relationship'];
    countryCode = json['country_code'];
    phone = json['phone'];
    shortDescription = json['short_description'];
    additionalInfo = json['additional_info'] != null
        ? AdditionalInfo.fromJson(json['additional_info'])
        : null;
    jobTitle = json['job_title'];
    isPrimary = json['is_primery']; // Added new field
    isPublicContact = json['is_public_contact']; // Added new field
    itsMe = json.containsKey('its_me')?json['its_me']:false; // Added new field
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['house_member_id'] = houseMemberId;
    data['name'] = name;
    data['profile_photo'] = profilePhoto;
    data['email'] = email;
    data['gender'] = gender;
    data['relationship'] = relationship;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['short_description'] = shortDescription;
    if (additionalInfo != null) {
      data['additional_info'] = additionalInfo!.toJson();
    }
    data['job_title'] = jobTitle;
    data['is_primery'] = isPrimary; // Added new field
    data['is_public_contact'] = isPublicContact; // Added new field
    data['its_me'] = itsMe; // Added new field
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
class Vehicles {
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

  Vehicles(
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

  Vehicles.fromJson(Map<String, dynamic> json) {
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