class InvoiceNewDetail {
  InvoiceDetailData? data;
  String? message;

  InvoiceNewDetail({this.data, this.message});

  InvoiceNewDetail.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new InvoiceDetailData.fromJson(json['data']) : null;
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

class InvoiceDetailData {
  String? invoiceNumber;
  String? months;
  String? date;
  String? dueDate;
  String? amount;
  String? status;
  String? file;
  List<Payments>? payments;
  List<Invoices>? invoices;
  InvoiceDetailData(
      {this.invoiceNumber,
        this.months,
        this.date,
        this.dueDate,
        this.amount,
        this.status,
        this.file,
        this.payments,this.invoices

      });

  InvoiceDetailData.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoice_number'];
    months = json['months'];
    date = json['date'];
    dueDate = json['due_date'];
    amount = json['amount'];
    status = json['status'];
    file = json['file'];
    if (json['payments'] != null) {
      payments = <Payments>[];
      json['payments'].forEach((v) {
        payments!.add(new Payments.fromJson(v));
      });
    }
    if (json['invoices'] != null) {
      invoices = <Invoices>[];
      json['invoices'].forEach((v) {
        invoices!.add(new Invoices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_number'] = this.invoiceNumber;
    data['months'] = this.months;
    data['date'] = this.date;
    data['due_date'] = this.dueDate;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['file'] = this.file;
    if (this.payments != null) {
      data['payments'] = this.payments!.map((v) => v.toJson()).toList();
    }
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payments {
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

  Payments(
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

  Payments.fromJson(Map<String, dynamic> json) {
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
class Invoices {
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

  Invoices(
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

  Invoices.fromJson(Map<String, dynamic> json) {
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