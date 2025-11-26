class PaymentSummaryModel {
  PaymentSummaryData? data;
  String? message;
  PaymentSummaryModel({this.data, this.message});
  PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentSummaryData.fromJson(json['data']) : null;
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

class PaymentSummaryData {
  String? totalBalance;
  String? totalPayment;
  String? totalExpenses;
  String? totalBalanceColor;
  String? totalPaymentColor;
  String? totalExpensesColor;
  PaymentSummaryData({this.totalBalance, this.totalPayment, this.totalExpenses,this.totalBalanceColor,
    this.totalPaymentColor,
    this.totalExpensesColor});
  PaymentSummaryData.fromJson(Map<String, dynamic> json) {
    totalBalance = json['total_balance'];
    totalPayment = json['total_payment'];
    totalExpenses = json['total_expenses'];
    totalBalanceColor = json['total_balance_color'];
    totalPaymentColor = json['total_payment_color'];
    totalExpensesColor = json['total_expenses_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_balance'] = this.totalBalance;
    data['total_payment'] = this.totalPayment;
    data['total_expenses'] = this.totalExpenses;
    data['total_balance_color'] = this.totalBalanceColor;
    data['total_payment_color'] = this.totalPaymentColor;
    data['total_expenses_color'] = this.totalExpensesColor;
    return data;
  }
}
