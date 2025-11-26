class AssetFilterModel {
  AssetFilterData? data;
  String? message;

  AssetFilterModel({this.data, this.message});

  AssetFilterModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? AssetFilterData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class AssetFilterData {
  List<Categories>? categories;
  List<Vendors>? vendors;
  Map<String, dynamic>? statuses; // ✅ Changed from Statuses? to dynamic Map

  AssetFilterData({this.categories, this.vendors, this.statuses});

  AssetFilterData.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }

    if (json['vendors'] != null) {
      vendors = <Vendors>[];
      json['vendors'].forEach((v) {
        vendors!.add(Vendors.fromJson(v));
      });
    }

    // ✅ Just store whatever comes in 'statuses' as a Map
    statuses = json['statuses'] != null
        ? Map<String, dynamic>.from(json['statuses'])
        : {};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (vendors != null) {
      data['vendors'] = vendors!.map((v) => v.toJson()).toList();
    }
    if (statuses != null) {
      data['statuses'] = statuses;
    }
    return data;
  }
}

class Categories {
  int? id;
  String? title;

  Categories({this.id, this.title});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class Vendors {
  int? id;
  String? name;

  Vendors({this.id, this.name});

  Vendors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
