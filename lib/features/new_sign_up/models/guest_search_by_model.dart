class GuestSearchByModel {
  List<GuestSearchByData>? data;
  String? message;

  GuestSearchByModel({this.data, this.message});

  GuestSearchByModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GuestSearchByData>[];
      json['data'].forEach((v) {
        data!.add(new GuestSearchByData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class GuestSearchByData {
  int? id;
  String? name;
  String? shortName;
  String? registrationNumber;
  String? address;
  String? logo;
  List<Blocks>? blocks;

  GuestSearchByData(
      {this.id,
        this.name,
        this.shortName,
        this.registrationNumber,
        this.address,
        this.logo,
        this.blocks});

  GuestSearchByData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    shortName = json['short_name'];
    logo = json['logo'];
    registrationNumber = json['registration_number '];
    address = json['address'];
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
    data['logo'] = this.logo;
    data['short_name'] = this.shortName;
    data['registration_number '] = this.registrationNumber;
    data['address'] = this.address;
    if (this.blocks != null) {
      data['blocks'] = this.blocks!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Blocks {
  int? id;
  String? blockName;
  List<Houses2>? houses;

  Blocks({this.id, this.blockName, this.houses});

  Blocks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blockName = json['block_name'];
    if (json['houses'] != null) {
      houses = <Houses2>[];
      json['houses'].forEach((v) {
        houses!.add(new Houses2.fromJson(v));
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

class Houses2 {
  int? id;
  String? houseNumber;

  Houses2({this.id, this.houseNumber});

  Houses2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    houseNumber = json['house_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['house_number'] = this.houseNumber;
    return data;
  }
}