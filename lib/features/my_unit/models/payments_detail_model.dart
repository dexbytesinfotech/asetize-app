class PaymentDetailModel {
  PaymentsDetailData? data;
  String? message;

  PaymentDetailModel({this.data, this.message});

  PaymentDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentsDetailData.fromJson(json['data']) : null;
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

class PaymentsDetailData {
  String? receiptNumber;
  String? paymentDate;
  String? amount;
  String? invoice;
  String? durations;
  String? paymentMethod;
  List<PaymentsDetailInvoices>? invoices;

  PaymentsDetailData(
      {this.receiptNumber,
        this.paymentDate,
        this.amount,
        this.invoice,
        this.durations,
        this.paymentMethod,
        this.invoices});

  PaymentsDetailData.fromJson(Map<String, dynamic> json) {
    receiptNumber = json['receipt_number'];
    paymentDate = json['payment_date'];
    amount = json['amount'];
    invoice = json['invoice'];
    durations = json['durations'];
    paymentMethod = json['payment_method'];
    if (json['invoices'] != null) {
      invoices = <PaymentsDetailInvoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(new PaymentsDetailInvoices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receipt_number'] = this.receiptNumber;
    data['payment_date'] = this.paymentDate;
    data['amount'] = this.amount;
    data['invoice'] = this.invoice;
    data['durations'] = this.durations;
    data['payment_method'] = this.paymentMethod;
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentsDetailInvoices {
  int? id;
  String? title;
  String? description;
  String? subTitle;
  String? amount;
  String? type;
  String? date;
  String? table;
  String? status;
  String? statusColor;
  String? paymentMethod;
  String? balanceAmount;

  PaymentsDetailInvoices(
      {this.id,
        this.title,
        this.description,
        this.subTitle,
        this.amount,
        this.type,
        this.date,
        this.table,
        this.status,
        this.statusColor,
        this.paymentMethod,
        this.balanceAmount});

  PaymentsDetailInvoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    subTitle = json['sub_title'];
    amount = json['amount'];
    type = json['type'];
    date = json['date'];
    table = json['table'];
    status = json['status'];
    statusColor = json['status_color'];
    paymentMethod = json['payment_method'];
    balanceAmount = json['balance_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['sub_title'] = this.subTitle;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['date'] = this.date;
    data['table'] = this.table;
    data['status'] = this.status;
    data['status_color'] = this.statusColor;
    data['payment_method'] = this.paymentMethod;
    data['balance_amount'] = this.balanceAmount;
    return data;
  }
}
