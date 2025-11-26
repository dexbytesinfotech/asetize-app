class HowToPayModel {
  HowToPayData? data;
  String? message;

  HowToPayModel({this.data, this.message});

  HowToPayModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HowToPayData.fromJson(json['data']) : null;
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

class HowToPayData {
  int? id;
  int? companyId;
  String? bankAccountNumber;
  String? ifscCode;
  String? accountName;
  String? branchName;
  String? upiId;
  String? upiQrCode;
  String? chequePayableName;
  String? chequeSubmissionNote;
  String? paymentNotes;
  String? createdAt;
  String? updatedAt;

  HowToPayData(
      {this.id,
        this.companyId,
        this.bankAccountNumber,
        this.ifscCode,
        this.accountName,
        this.branchName,
        this.upiId,
        this.upiQrCode,
        this.chequePayableName,
        this.chequeSubmissionNote,
        this.paymentNotes,
        this.createdAt,
        this.updatedAt});

  HowToPayData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    bankAccountNumber = json['bank_account_number'];
    ifscCode = json['ifsc_code'];
    accountName = json['account_name'];
    branchName = json['branch_name'];
    upiId = json['upi_id'];
    upiQrCode = json['upi_qr_code'];
    chequePayableName = json['cheque_payable_name'];
    chequeSubmissionNote = json['cheque_submission_note'];
    paymentNotes = json['payment_notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['bank_account_number'] = this.bankAccountNumber;
    data['ifsc_code'] = this.ifscCode;
    data['account_name'] = this.accountName;
    data['branch_name'] = this.branchName;
    data['upi_id'] = this.upiId;
    data['upi_qr_code'] = this.upiQrCode;
    data['cheque_payable_name'] = this.chequePayableName;
    data['cheque_submission_note'] = this.chequeSubmissionNote;
    data['payment_notes'] = this.paymentNotes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}