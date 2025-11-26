class InvoiceTransactionModel {
  List<InvoiceTransactionData>? data;
  String? message;

  InvoiceTransactionModel({this.data, this.message});

  InvoiceTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InvoiceTransactionData>[];
      json['data'].forEach((v) {
        data!.add(new InvoiceTransactionData.fromJson(v));
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

class InvoiceTransactionData {
  int? id;
  String? title;
  String? paymentDate;
  String? amount;
  String? receiptNumber;
  String? paymentMethod;
  String? invoiceNumber;
  String? durations;
  String? transactionReference;
  String? receiptUrl;

  InvoiceTransactionData(
      {this.title,
        this.id,
        this.paymentDate,
        this.amount,
        this.receiptNumber,
        this.paymentMethod,
        this.invoiceNumber,
        this.durations,
        this.transactionReference,
        this.receiptUrl});

  InvoiceTransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    paymentDate = json['payment_date'];
    amount = json['amount'];
    receiptNumber = json['receipt_number'];
    paymentMethod = json['payment_method'];
    invoiceNumber = json['invoice_number'];
    durations = json['durations'];
    transactionReference = json['transaction_reference'];
    receiptUrl = json['receipt_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['payment_date'] = this.paymentDate;
    data['amount'] = this.amount;
    data['receipt_number'] = this.receiptNumber;
    data['payment_method'] = this.paymentMethod;
    data['invoice_number'] = this.invoiceNumber;
    data['durations'] = this.durations;
    data['transaction_reference'] = this.transactionReference;
    data['receipt_url'] = this.receiptUrl;
    return data;
  }
}
