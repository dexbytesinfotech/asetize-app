class AddVehicleForManager {
  AddVehicleForManagerData? data;
  String? message;

  AddVehicleForManager({this.data, this.message});

  AddVehicleForManager.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new AddVehicleForManagerData.fromJson(json['data']) : null;
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

class AddVehicleForManagerData {
  int? id;
  String? name;
  String? shortName;
  String? registrationNumber;
  String? phone;
  String? email;
  String? address;
  String? city;
  List<Blocks>? blocks;

  AddVehicleForManagerData(
      {this.id,
        this.name,
        this.shortName,
        this.registrationNumber,
        this.phone,
        this.email,
        this.address,
        this.city,
        this.blocks});

  AddVehicleForManagerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    registrationNumber = json['registration_number '];
    phone = json['phone '];
    email = json['email '];
    address = json['address'];
    city = json['city'];
    if (json['blocks'] != null) {
      blocks = <Blocks>[];
      json['blocks'].forEach((v) {
        blocks!.add(new Blocks.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['registration_number '] = this.registrationNumber;
    data['phone '] = this.phone;
    data['email '] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    if (this.blocks != null) {
      data['blocks'] = this.blocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Blocks {
  int? id;
  String? blockName;
  List<HousesListData>? houses;

  Blocks({this.id, this.blockName, this.houses});

  Blocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blockName = json['block_name'];
    if (json['houses'] != null) {
      houses = <HousesListData>[];
      json['houses'].forEach((v) {
        houses!.add(new HousesListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['block_name'] = this.blockName;
    if (this.houses != null) {
      data['houses'] = this.houses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HousesListData {
  int? id;
  String? houseNumber;
  Owner? owner;
  int? membersCount;
  int? vehiclesCount;

  HousesListData({this.id, this.houseNumber, this.owner, this.membersCount,
    this.vehiclesCount});

  HousesListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houseNumber = json['house_number'];
    owner = json['owner'] != null ? new Owner.fromJson(json['owner']) : null;
    membersCount = json['members_count'];
    vehiclesCount = json['vehicles_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['house_number'] = this.houseNumber;
    if (this.owner != null) {
      data['owner'] = this.owner!.toJson();
    }
    data['members_count'] = this.membersCount;
    data['vehicles_count'] = this.vehiclesCount;
    return data;
  }
}

class Owner {
  int? id;
  String? name;
  String? profilePhoto;
  String? email;
  String? countryCode;
  String? phone;
  String? shortDescription;
  AdditionalInfo? additionalInfo;
  String? jobTitle;

  Owner(
      {this.id,
        this.name,
        this.profilePhoto,
        this.email,
        this.countryCode,
        this.phone,
        this.shortDescription,
        this.additionalInfo,
        this.jobTitle});

  Owner.fromJson(Map<String, dynamic> json) {
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
