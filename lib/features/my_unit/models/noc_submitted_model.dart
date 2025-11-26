class NOCSubmittedModel {
  NOCSubmittedData? data;
  String? message;

  NOCSubmittedModel({this.data, this.message});

  NOCSubmittedModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new NOCSubmittedData.fromJson(json['data']) : null;
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

class NOCSubmittedData {
  int? id;
  String? title;
  String? desciption;
  String? status;
  String? purpose;
  int? houseId;
  String? remarks;
  String? nocFile;
  String? requester;
  String? createdAt;
  String? updatedAt;

  NOCSubmittedData(
      {this.id,
        this.title,
        this.desciption,
        this.status,
        this.purpose,
        this.houseId,
        this.remarks,
        this.nocFile,
        this.requester,
        this.createdAt,
        this.updatedAt});

  NOCSubmittedData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desciption = json['desciption'];
    status = json['status'];
    purpose = json['purpose'];
    houseId = json['house_id'];
    remarks = json['remarks'];
    nocFile = json['noc_file'];
    requester = json['requester'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desciption'] = this.desciption;
    data['status'] = this.status;
    data['purpose'] = this.purpose;
    data['house_id'] = this.houseId;
    data['remarks'] = this.remarks;
    data['noc_file'] = this.nocFile;
    data['requester'] = this.requester;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
