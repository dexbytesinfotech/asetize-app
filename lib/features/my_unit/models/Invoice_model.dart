class Invoice {
  List<InvoiceData>? data;
  String? message;

  Invoice({this.data, this.message});

  Invoice.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <InvoiceData>[];
      json['data'].forEach((v) {
        data!.add(new InvoiceData.fromJson(v));
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

class InvoiceData {
  int? id;
  String? invoiceNumber;
  String? durations;
  String? createdAt;
  String? dueDate;
  String? billMode;
  String? amount;
  String? status;
  String? invoiceFile;

  InvoiceData(
      {this.id,
        this.invoiceNumber,
        this.durations,
        this.createdAt,
        this.dueDate,
        this.billMode,
        this.amount,
        this.status,
        this.invoiceFile});

  InvoiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNumber = json['invoice_number'];
    durations = json['durations'];
    createdAt = json['created_at'];
    dueDate = json['due_date'];
    billMode = json['bill_mode'];
    amount = json['amount'];
    status = json['status'];
    invoiceFile = json['invoice_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invoice_number'] = this.invoiceNumber;
    data['durations'] = this.durations;
    data['created_at'] = this.createdAt;
    data['due_date'] = this.dueDate;
    data['bill_mode'] = this.billMode;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['invoice_file'] = this.invoiceFile;
    return data;
  }
}



/*
class Invoice {
  final int id;
  final String invoiceNumber;
  final String durations;
  final String createdAt;
  final String dueDate;
  final String billMode;
  final String amount;
  final String status;
  final String invoiceFile;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.durations,
    required this.createdAt,
    required this.dueDate,
    required this.billMode,
    required this.amount,
    required this.status,
    required this.invoiceFile,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      durations: json['durations'],
      createdAt: json['created_at'],
      dueDate: json['due_date'],
      billMode: json['bill_mode'],
      amount: json['amount'],
      status: json['status'],
      invoiceFile: json['invoice_file'] ?? '',
    );
  }
}
*/
