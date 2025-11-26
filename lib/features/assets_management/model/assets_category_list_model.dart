class AssetsCategoryListModel {
  List<AssetsCategoryListData>? data;
  String? message;

  AssetsCategoryListModel({this.data, this.message});

  AssetsCategoryListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AssetsCategoryListData>[];
      json['data'].forEach((v) {
        data!.add(new AssetsCategoryListData.fromJson(v));
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

class AssetsCategoryListData {
  int? id;
  String? name;

  AssetsCategoryListData({this.id, this.name});

  AssetsCategoryListData.fromJson(Map<String, dynamic> json) {
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
