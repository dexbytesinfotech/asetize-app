class HouseBlocModel {
  List<HouseData>? data;
  String? message;

  HouseBlocModel({this.data, this.message});

  HouseBlocModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HouseData>[];
      json['data'].forEach((v) {
        data!.add(new HouseData.fromJson(v));
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

class HouseData {
  int? id;
  String? blockName;
  int? totalFloor;
  List<String>? floors;

  HouseData({this.blockName, this.totalFloor, this.floors});

  HouseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    blockName = json['block_name'];
    totalFloor = json['total_floor'];
    floors = json['floors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['block_name'] = this.blockName;
    data['total_floor'] = this.totalFloor;
    data['floors'] = this.floors;
    return data;
  }
}
