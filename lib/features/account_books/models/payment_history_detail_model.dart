class PaymentHistoryDetailModel {
  HistoryDetailData? data;
  String? message;
  PaymentHistoryDetailModel({this.data, this.message});
  PaymentHistoryDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new HistoryDetailData.fromJson(json['data']) : null;
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
class HistoryDetailData {
  String? title;
  String? description;
  String? amount;
  String? date;
  String? paymentMode;

  HistoryDetailData(
      {this.title, this.description, this.amount, this.date, this.paymentMode});

  HistoryDetailData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    amount = json['amount'];
    date = json['date'];
    paymentMode = json['payment_mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['payment_mode'] = this.paymentMode;
    return data;
  }
}
