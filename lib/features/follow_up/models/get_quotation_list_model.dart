class GetQuotationListModel {
  List<GetQuotationListData>? data;
  String? message;

  GetQuotationListModel({this.data, this.message});

  GetQuotationListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetQuotationListData>[];
      json['data'].forEach((v) {
        data!.add(new GetQuotationListData.fromJson(v));
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

class GetQuotationListData {
  int? id;
  int? taskId;
  String? vendorName;
  int? amount;
  String? amountDisplay;
  String? quotationDate;
  String? attachment;
  int? addedBy;
  int? approvedBy;
  int? rejectedBy;
  String? status;
  String? createdAt;
  String? updatedAt;
  AddedByUser? addedByUser;
  AddedByUser? approvedByUser;
  AddedByUser? rejectedByUser;

  GetQuotationListData(
      {this.id,
        this.taskId,
        this.vendorName,
        this.amount,
        this.amountDisplay,
        this.quotationDate,
        this.attachment,
        this.addedBy,
        this.approvedBy,
        this.rejectedBy,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.addedByUser,
        this.approvedByUser,
        this.rejectedByUser});

  GetQuotationListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskId = json['task_id'];
    vendorName = json['vendor_name'];
    amount = json['amount'];
    amountDisplay = json['amount_display'];
    quotationDate = json['quotation_date'];
    attachment = json['attachment'];
    addedBy = json['added_by'];
    approvedBy = json['approved_by'];
    rejectedBy = json['rejected_by'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    addedByUser = json['added_by_user'] != null
        ? new AddedByUser.fromJson(json['added_by_user'])
        : null;
    approvedByUser = json['approved_by_user'] != null
        ? new AddedByUser.fromJson(json['approved_by_user'])
        : null;
    rejectedByUser = json['rejected_by_user'] != null
        ? new AddedByUser.fromJson(json['rejected_by_user'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['task_id'] = this.taskId;
    data['vendor_name'] = this.vendorName;
    data['amount'] = this.amount;
    data['amount_display'] = this.amountDisplay;
    data['quotation_date'] = this.quotationDate;
    data['attachment'] = this.attachment;
    data['added_by'] = this.addedBy;
    data['approved_by'] = this.approvedBy;
    data['rejected_by'] = this.rejectedBy;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.addedByUser != null) {
      data['added_by_user'] = this.addedByUser!.toJson();
    }
    if (this.approvedByUser != null) {
      data['approved_by_user'] = this.approvedByUser!.toJson();
    }
    if (this.rejectedByUser != null) {
      data['rejected_by_user'] = this.rejectedByUser!.toJson();
    }
    return data;
  }
}

class AddedByUser {
  int? id;
  String? name;
  String? email;
  String? jobTitle;
  String? profilePhoto;
  AdditionalInfo? additionalInfo;

  AddedByUser(
      {this.id,
        this.name,
        this.email,
        this.jobTitle,
        this.profilePhoto,
        this.additionalInfo});

  AddedByUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    jobTitle = json['job_title'];
    profilePhoto = json['profile_photo'];
    additionalInfo = json['additional_info'] != null
        ? new AdditionalInfo.fromJson(json['additional_info'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['job_title'] = this.jobTitle;
    data['profile_photo'] = this.profilePhoto;
    if (this.additionalInfo != null) {
      data['additional_info'] = this.additionalInfo!.toJson();
    }
    return data;
  }
}

class AdditionalInfo {
  String? phone;
  String? bloodGroup;

  AdditionalInfo({this.phone, this.bloodGroup});

  AdditionalInfo.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    bloodGroup = json['blood_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['blood_group'] = this.bloodGroup;
    return data;
  }
}