class NocRequestHistoryModel {
  List<NocRequestData>? data;
  String? message;

  NocRequestHistoryModel({this.data, this.message});

  NocRequestHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NocRequestData>[];
      json['data'].forEach((v) {
        data!.add(new NocRequestData.fromJson(v));
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

class NocRequestData {
  int? id;
  String? title;
  String? description;
  String? status;
  String? purpose;
  int? houseId;
  String? remarks;
  String? requester;
  String? createdAt;
  String? updatedAt;

  NocRequestData(
      {this.id,
        this.title,
        this.description,
        this.status,
        this.purpose,
        this.houseId,
        this.remarks,
        this.requester,
        this.createdAt,
        this.updatedAt});

  NocRequestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['desciption'];
    status = json['status'];
    purpose = json['purpose'];
    houseId = json['house_id'];
    remarks = json['remarks'];
    requester = json['requester'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desciption'] = this.description;
    data['status'] = this.status;
    data['purpose'] = this.purpose;
    data['house_id'] = this.houseId;
    data['remarks'] = this.remarks;
    data['requester'] = this.requester;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
