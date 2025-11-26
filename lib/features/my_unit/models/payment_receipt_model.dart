class PaymentReceiptModel {
  String? pdfUrl;
  String? message;

  PaymentReceiptModel({this.pdfUrl, this.message});

  PaymentReceiptModel.fromJson(Map<String, dynamic> json) {
    pdfUrl = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this.pdfUrl;
    data['message'] = this.message;
    return data;
  }
}
