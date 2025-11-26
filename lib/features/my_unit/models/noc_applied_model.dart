class NOCAppliedListModel {
  List<NOCAppliedListData>? data;
  String? message;

  NOCAppliedListModel({this.data, this.message});

  NOCAppliedListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <NOCAppliedListData>[];
      json['data'].forEach((v) {
        data!.add(new NOCAppliedListData.fromJson(v));
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

class NOCAppliedListData {
  int? id;
  String? title;
  String? desciption;
  String? status;
  String? purpose;
  int? houseId;
  String? remarks;
  String? firstName;
  String? lastName;
  String? phone;
  String? requestedBy;
  String? approvedBy;
  String? houseNumber;
  String? address;
  String? issueDate;
  bool? isCompleted;
  bool? isCompletedPoliceVerification;
  int? companyId;
  String? nocFile;
  String? requester;
  String? createdAt;
  String? updatedAt;

  NOCAppliedListData(
      {this.id,
        this.title,
        this.desciption,
        this.status,
        this.purpose,
        this.houseId,
        this.remarks,
        this.firstName,
        this.lastName,
        this.phone,
        this.requestedBy,
        this.approvedBy,
        this.houseNumber,
        this.address,
        this.issueDate,
        this.isCompleted,
        this.isCompletedPoliceVerification,
        this.companyId,
        this.nocFile,
        this.requester,
        this.createdAt,
        this.updatedAt});

  NOCAppliedListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desciption = json['desciption'];
    status = json['status'];
    purpose = json['purpose'];
    houseId = json['house_id'];
    remarks = json['remarks'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    requestedBy = json['requested_by'];
    approvedBy = json['approved_by'];
    houseNumber = json['house_number'];
    address = json['address'];
    issueDate = json['issue_date'];
    isCompleted = json['is_completed'];
    isCompletedPoliceVerification = json['is_completed_police_verification'];
    companyId = json['company_id'];
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
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['phone'] = this.phone;
    data['requested_by'] = this.requestedBy;
    data['approved_by'] = this.approvedBy;
    data['house_number'] = this.houseNumber;
    data['address'] = this.address;
    data['issue_date'] = this.issueDate;
    data['is_completed'] = this.isCompleted;
    data['is_completed_police_verification'] =
        this.isCompletedPoliceVerification;
    data['company_id'] = this.companyId;
    data['noc_file'] = this.nocFile;
    data['requester'] = this.requester;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}