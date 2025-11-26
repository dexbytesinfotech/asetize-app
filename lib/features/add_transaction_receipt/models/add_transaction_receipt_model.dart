class AddTransactionReceiptModel {
  List<PendingInvoices>? data;
  String? message;

  AddTransactionReceiptModel({this.data, this.message});

  AddTransactionReceiptModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <PendingInvoices>[];
      json['data'].forEach((v) {
        data!.add(new PendingInvoices.fromJson(v));
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


class PendingInvoices {
  int? id;
  String? title;
  String? invoiceNumber;
  String? durations;
  String? invoiceAmountLabel;
  double? payingAmount;
  String? payingAmountLabel;
  double? remainingAmount;
  String? remainingAmountLabel;
  String? status;
  double? nextRunningTotal;
  bool? isChecked;

  PendingInvoices({
    this.id,
    this.title,
    this.invoiceNumber,
    this.durations,
    this.invoiceAmountLabel,
    this.payingAmount,
    this.payingAmountLabel,
    this.remainingAmount,
    this.remainingAmountLabel,
    this.status,
    this.nextRunningTotal,
    this.isChecked,
  });

  PendingInvoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    invoiceNumber = json['invoice_number'];
    durations = json['durations'];
    invoiceAmountLabel = json['invoice_amount_label'];
    payingAmount = _toDouble(json['paying_amount']);
    payingAmountLabel = json['paying_amount_label'];
    remainingAmount = _toDouble(json['remaining_amount']);
    remainingAmountLabel = json['remaining_amount_label'];
    status = json['status'];
    nextRunningTotal = _toDouble(json['next_running_total']);
    isChecked = json['is_checked'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'invoice_number': invoiceNumber,
      'durations': durations,
      'invoice_amount_label': invoiceAmountLabel,
      'paying_amount': payingAmount,
      'paying_amount_label': payingAmountLabel,
      'remaining_amount': remainingAmount,
      'remaining_amount_label': remainingAmountLabel,
      'status': status,
      'next_running_total': nextRunningTotal,
      'is_checked': isChecked,
    };
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString());
  }
}