class FaqDataModel {
  bool? success;
  List<Data>? data;
  String? message;

  FaqDataModel({this.success, this.data, this.message});

  FaqDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? descriptions;
  int? categoryId;
  String? categoryName;
  String? roleType;
  String? status;

  Data(
      {this.id,
      this.title,
      this.descriptions,
      this.categoryId,
      this.categoryName,
      this.roleType,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descriptions = json['descriptions'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    roleType = json['role_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['descriptions'] = this.descriptions;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['role_type'] = this.roleType;
    data['status'] = this.status;
    return data;
  }
}
