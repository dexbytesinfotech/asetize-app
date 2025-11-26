class ExpenseDetailModel {
  ExpenseDetailData? data;
  String? message;

  ExpenseDetailModel({this.data, this.message});

  ExpenseDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ExpenseDetailData.fromJson(json['data']) : null;
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

class ExpenseDetailData {
  int? id;
  String? title;
  String? description;
  String? amount;
  String? date;
  String? paymentMode;
  int? categoryId;
  int? beneficiaryId;
  String? beneficiaryName;
  String? voucherNumber;
  String? otherDetails;
  String? chequeNumber;
  bool? isVerified;
  String? verifiedBy;
  String? verifiedAt;
  String? createdAt;
  String? voucherPhoto;

  ExpenseDetailData(
      {this.id,
        this.title,
        this.description,
        this.amount,
        this.date,
        this.paymentMode,
        this.categoryId,
        this.beneficiaryId,
        this.beneficiaryName,
        this.voucherNumber,
        this.otherDetails,
        this.chequeNumber,
        this.isVerified,
        this.verifiedBy,
        this.verifiedAt,
        this.createdAt,
        this.voucherPhoto

      });

  ExpenseDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    amount = json['amount'];
    date = json['date'];
    paymentMode = json['payment_mode'];
    categoryId = json['category_id'];
    beneficiaryId = json['beneficiary_id'];
    beneficiaryName = json['beneficiary_name'];
    voucherNumber = json['voucher_number'];
    otherDetails = json['other_details'];
    chequeNumber = json['cheque_number'];
    isVerified = json['is_verified'];
    verifiedBy = json['verified_by'];
    verifiedAt = json['verified_at'];
    createdAt = json['created_at'];
    voucherPhoto = json['voucher_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['payment_mode'] = this.paymentMode;
    data['category_id'] = this.categoryId;
    data['beneficiary_id'] = this.beneficiaryId;
    data['beneficiary_name'] = this.beneficiaryName;
    data['voucher_number'] = this.voucherNumber;
    data['other_details'] = this.otherDetails;
    data['cheque_number'] = this.chequeNumber;
    data['is_verified'] = this.isVerified;
    data['verified_by'] = this.verifiedBy;
    data['verified_at'] = this.verifiedAt;
    data['created_at'] = this.createdAt;
    data['voucher_photo'] = this.voucherPhoto;
    return data;
  }
}
