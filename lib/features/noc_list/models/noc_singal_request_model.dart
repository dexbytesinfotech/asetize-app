class SingalDataModel {
  SingalData? data;
  String? message;

  SingalDataModel({this.data, this.message});

  SingalDataModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SingalData.fromJson(json['data']) : null;
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

class SingalData {
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
  String? countryCode;
  String? requestedBy;
  String? requestedByPhone;
  String? requestedByCountryCode;
  String? approvedBy;
  String? houseNumber;
  String? address;
  String? issueDate;
  bool? isCompleted;
  bool? isCompletedPayment;
  bool? isEntryPassCreated;
  String? paymentReceipt;
  String? paymentStatus;
  int? invoiceId;
  bool? isCompletedPoliceVerification;
  int? companyId;
  Broker? broker;
  String? nocFile;
  String? requester;
  String? createdAt;
  String? updatedAt;
  String? visitorType;
  String? remarkForRejection;
  String? visitorTypePurposes;
  String? visitorEntryStatus;
  int? visitorEntryId;
  SingalData(
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
        this.countryCode,
        this.requestedBy,
        this.requestedByPhone,
        this.requestedByCountryCode,
        this.approvedBy,
        this.houseNumber,
        this.address,
        this.issueDate,
        this.isCompleted,
        this.isCompletedPayment,
        this.isEntryPassCreated,
        this.paymentReceipt,
        this.paymentStatus,
        this.invoiceId,
        this.isCompletedPoliceVerification,
        this.companyId,
        this.broker,
        this.nocFile,
        this.requester,
        this.createdAt,
        this.updatedAt,
        this.visitorType,
        this.remarkForRejection,
        this.visitorTypePurposes,  this.visitorEntryStatus,
        this.visitorEntryId


      });

  SingalData.fromJson(Map<String, dynamic> json) {
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
    countryCode = json['country_code'];
    requestedBy = json['requested_by'];
    requestedByCountryCode = json['requested_by_country_code'];
    approvedBy = json['approved_by'];
    requestedByPhone = json['requested_by_phone'];
    houseNumber = json['house_number'];
    address = json['address'];
    issueDate = json['issue_date'];
    isCompleted = json['is_completed'];
    isCompletedPayment = json['is_completed_payment'];
    isEntryPassCreated = json['is_entry_pass_created'];
    paymentReceipt = json['payment_receipt'];
    paymentStatus = json['payment_status'];
    invoiceId = json['invoice_id'];
    isCompletedPoliceVerification = json['is_completed_police_verification'];
    companyId = json['company_id'];
    broker =
    json['broker'] != null ? new Broker.fromJson(json['broker']) : null;
    nocFile = json['noc_file'];
    requester = json['requester'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    visitorType = json['visitor_type'];
    remarkForRejection = json['action_remark'];
    visitorTypePurposes = json['visitor_type_purposes'];
    visitorEntryStatus = json['visitor_entry_status'];
    visitorEntryId = json['visitor_entry_id'];
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
    data['requested_by_country_code'] = this.requestedByCountryCode;
    data['country_code'] = this.countryCode;
    data['requested_by'] = this.requestedBy;
    data['approved_by'] = this.approvedBy;
    data['requested_by_phone'] = this.requestedByPhone;
    data['house_number'] = this.houseNumber;
    data['address'] = this.address;
    data['issue_date'] = this.issueDate;
    data['is_completed'] = this.isCompleted;
    data['is_completed_payment'] = this.isCompletedPayment;
    data['payment_receipt'] = this.paymentReceipt;
    data['payment_status'] = this.paymentStatus;
    data['invoice_id'] = this.invoiceId;
    data['is_completed_police_verification'] =
        this.isCompletedPoliceVerification;
    data['is_entry_pass_created'] =
        this.isEntryPassCreated;
    data['company_id'] = this.companyId;
    if (this.broker != null) {
      data['broker'] = this.broker!.toJson();
    }
    data['noc_file'] = this.nocFile;
    data['action_remark'] = this.remarkForRejection;
    data['requester'] = this.requester;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['visitor_type'] = this.visitorType;
    data['visitor_type_purposes'] = this.visitorTypePurposes;
    data['visitor_entry_status'] = this.visitorEntryStatus;
    data['visitor_entry_id'] = this.visitorEntryId;
    return data;
  }
}

class Broker {
  int? id;
  String? name;
  String? profilePhoto;
  String? email;
  String? countryCode;
  String? phone;
  String? shortDescription;
  AdditionalInfo? additionalInfo;
  String? jobTitle;

  Broker(
      {this.id,
        this.name,
        this.profilePhoto,
        this.email,
        this.countryCode,
        this.phone,
        this.shortDescription,
        this.additionalInfo,
        this.jobTitle});

  Broker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePhoto = json['profile_photo'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    shortDescription = json['short_description'];
    additionalInfo = json['additional_info'] != null
        ? new AdditionalInfo.fromJson(json['additional_info'])
        : null;
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_photo'] = this.profilePhoto;
    data['email'] = this.email;
    data['country_code'] = this.countryCode;
    data['phone'] = this.phone;
    data['short_description'] = this.shortDescription;
    if (this.additionalInfo != null) {
      data['additional_info'] = this.additionalInfo!.toJson();
    }
    data['job_title'] = this.jobTitle;
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
