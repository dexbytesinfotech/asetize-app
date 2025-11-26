class Payment {
  List<PaymentData>? data;
  String? message;

  Payment({this.data, this.message});

  Payment.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PaymentData>[];
      json['data'].forEach((v) {
        data!.add(new PaymentData.fromJson(v));
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

class PaymentData {
  String? invoiceNumber;
  String? durations;
  String? amount;
  String? paymentMethod;
  String? transactionReference;
  String? transactionDate;
  String? receiptNumber;
  String? receiptUrl;

  PaymentData(
      {this.invoiceNumber,
        this.durations,
        this.amount,
        this.paymentMethod,
        this.transactionReference,
        this.transactionDate,
        this.receiptNumber,
        this.receiptUrl});

  PaymentData.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoice_number'];
    durations = json['durations'];
    amount = json['amount'];
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    transactionDate = json['transaction_date'];
    receiptNumber = json['receipt_number'];
    receiptUrl = json['receipt_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_number'] = this.invoiceNumber;
    data['durations'] = this.durations;
    data['amount'] = this.amount;
    data['payment_method'] = this.paymentMethod;
    data['transaction_reference'] = this.transactionReference;
    data['transaction_date'] = this.transactionDate;
    data['receipt_number'] = this.receiptNumber;
    data['receipt_url'] = this.receiptUrl;
    return data;
  }
}
