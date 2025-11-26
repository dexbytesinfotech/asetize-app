class VendorListModel {
  List<VendorListData>? data;
  String? message;

  VendorListModel({this.data, this.message});

  VendorListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VendorListData>[];
      json['data'].forEach((v) {
        data!.add(new VendorListData.fromJson(v));
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

class VendorListData {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? content;
  int? status;

  VendorListData({this.id, this.name, this.email, this.phone, this.content, this.status});

  VendorListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    content = json['content'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['content'] = this.content;
    data['status'] = this.status;
    return data;
  }
}
