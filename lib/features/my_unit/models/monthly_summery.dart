class MonthlySummeryModel {
  MonthlySummeryData? data;
  String? message;

  MonthlySummeryModel({this.data, this.message});

  MonthlySummeryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? MonthlySummeryData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class MonthlySummeryData {
  int? column;
  String? type;
  int? year;
  int? houseId;
  List<Months>? months;

  MonthlySummeryData({this.column, this.type, this.year, this.houseId, this.months});

  MonthlySummeryData.fromJson(Map<String, dynamic> json) {
    column = json['column'];
    type = json['type'];
    year = json['year'];
    houseId = json['house_id'];
    if (json['months'] != null) {
      months = <Months>[];
      json['months'].forEach((v) {
        months!.add(Months.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['column'] = column;
    data['type'] = type;
    data['year'] = year;
    data['house_id'] = houseId;
    if (months != null) {
      data['months'] = months!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Months {
  String? title;
  String? totalInvoiceAmount;
  String? totalPaidAmount;
  String? unpaidAmount;
  int? unpaidPercentage;
  bool? status;
  List<Transactions>? transactions;

  Months(
      {this.title,
        this.totalInvoiceAmount,
        this.totalPaidAmount,
        this.unpaidAmount,
        this.unpaidPercentage,
        this.status,
        this.transactions});

  Months.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    totalInvoiceAmount = json['total_invoice_amount'];
    totalPaidAmount = json['total_paid_amount'];
    unpaidAmount = json['unpaid_amount'];
    unpaidPercentage = json['unpaid_percentage'];
    status = json['status'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['total_invoice_amount'] = totalInvoiceAmount;
    data['total_paid_amount'] = totalPaidAmount;
    data['unpaid_amount'] = unpaidAmount;
    data['unpaid_percentage'] = unpaidPercentage;
    data['status'] = status;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  String? id;
  String? title;
  String? paymentDate;
  String? amount;
  String? receiptNumber;
  String? paymentMethod;
  String? invoiceNumber;
  String? durations;
  String? transactionReference;
  String? receiptUrl;

  Transactions(
      {this.id,
        this.title,
        this.paymentDate,
        this.amount,
        this.receiptNumber,
        this.paymentMethod,
        this.invoiceNumber,
        this.durations,
        this.transactionReference,
        this.receiptUrl});

  Transactions.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['payment_date'] = paymentDate;
    data['amount'] = amount;
    data['receipt_number'] = receiptNumber;
    data['payment_method'] = paymentMethod;
    data['invoice_number'] = invoiceNumber;
    data['durations'] = durations;
    data['transaction_reference'] = transactionReference;
    data['receipt_url'] = receiptUrl;
    return data;
  }
}