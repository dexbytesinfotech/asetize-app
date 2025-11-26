class InvoiceDetailModel {
  InvoiceDetail? data;
  String? message;
  InvoiceDetailModel({this.data, this.message});
  InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new InvoiceDetail.fromJson(json['data']) : null;
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

class InvoiceDetail {
  String? invoiceNumber;
  String? months;
  String? date;
  String? amount;
  String? receiptNumber;
  String? paymentMethod;
  String? transactionReference;
  String? file;

  InvoiceDetail(
      {this.invoiceNumber,
        this.months,
        this.date,
        this.amount,
        this.receiptNumber,
        this.paymentMethod,
        this.transactionReference,
        this.file});

  InvoiceDetail.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoice_number'];
    months = json['months'];
    date = json['date'];
    amount = json['amount'];
    receiptNumber = json['receipt_number'];
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_number'] = this.invoiceNumber;
    data['months'] = this.months;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['receipt_number'] = this.receiptNumber;
    data['payment_method'] = this.paymentMethod;
    data['transaction_reference'] = this.transactionReference;
    data['file'] = this.file;
    return data;
  }
}
