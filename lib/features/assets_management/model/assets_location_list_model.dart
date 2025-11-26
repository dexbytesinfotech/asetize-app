class AssetLocationListModel {
  List<AssetsLocationListData>? data;
  String? message;

  AssetLocationListModel({this.data, this.message});

  AssetLocationListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AssetsLocationListData>[];
      json['data'].forEach((v) {
        data!.add(new AssetsLocationListData.fromJson(v));
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

class AssetsLocationListData {
  int? id;
  String? name;

  AssetsLocationListData({this.id, this.name});

  AssetsLocationListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
