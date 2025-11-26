class InvoiceSummaryModel {
  SummaryData? data;
  String? message;

  InvoiceSummaryModel({this.data, this.message});

  InvoiceSummaryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SummaryData.fromJson(json['data']) : null;
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


class SummaryData {
  bool? isDue;
  String? totalBalance;
  String? previousBalance;
  String? latetInvoiceDue;
  String? openingBalance;
  int? unpaidInvoicesCount;
  String? unpaidPaidMessage;
  String? unpaidPaidMessageTextColor;
  String? totalBalanceColor;
  String? latetInvoiceDueColor;
  String? previousBalanceColor;
  String? unpaidInvoicesCountLabel;

  SummaryData(
      { this.isDue = false,
        this.totalBalance,
        this.previousBalance,
        this.latetInvoiceDue,
        this.openingBalance,
        this.unpaidInvoicesCount,
        this.unpaidPaidMessage,
        this.unpaidPaidMessageTextColor,
        this.totalBalanceColor,
        this.latetInvoiceDueColor,
        this.unpaidInvoicesCountLabel,
        this.previousBalanceColor});

  SummaryData.fromJson(Map<String, dynamic> json) {
    isDue = json['is_due'];
    totalBalance = json['total_balance'];
    previousBalance = json['previous_balance'];
    latetInvoiceDue = json['latet_invoice_due'];
    openingBalance = json['opening_balance'];
    unpaidInvoicesCount = json['unpaid_invoices_count'];
    unpaidPaidMessage = json['unpaid_paid_message'];
    unpaidPaidMessageTextColor = json['unpaid_paid_message_text_color'];
    totalBalanceColor = json['total_balance_color'];
    latetInvoiceDueColor = json['latet_invoice_due_color'];
    previousBalanceColor = json['previous_balance_color'];
    unpaidInvoicesCountLabel = json['unpaid_invoices_count_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_due'] = this.isDue;
    data['total_balance'] = this.totalBalance;
    data['previous_balance'] = this.previousBalance;
    data['latet_invoice_due'] = this.latetInvoiceDue;
    data['opening_balance'] = this.openingBalance;
    data['unpaid_invoices_count'] = this.unpaidInvoicesCount;
    data['unpaid_paid_message'] = this.unpaidPaidMessage;
    data['unpaid_paid_message_text_color'] = this.unpaidPaidMessageTextColor;
    data['total_balance_color'] = this.totalBalanceColor;
    data['latet_invoice_due_color'] = this.latetInvoiceDueColor;
    data['previous_balance_color'] = this.previousBalanceColor;
    data['unpaid_invoices_count_label'] = this.unpaidInvoicesCountLabel;
    return data;
  }
}


