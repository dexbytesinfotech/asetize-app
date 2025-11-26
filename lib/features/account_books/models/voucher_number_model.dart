class VoucherNumberModal {
  VoucherNumberData? data;
  String? message;

  VoucherNumberModal({this.data, this.message});

  VoucherNumberModal.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new VoucherNumberData.fromJson(json['data']) : null;
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

class VoucherNumberData {
  String? nextVoucherNumber;

  VoucherNumberData({this.nextVoucherNumber});

  VoucherNumberData.fromJson(Map<String, dynamic> json) {
    nextVoucherNumber = json['next_voucher_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next_voucher_number'] = this.nextVoucherNumber;
    return data;
  }
}
