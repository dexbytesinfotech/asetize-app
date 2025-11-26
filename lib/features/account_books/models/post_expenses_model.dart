class PostExpensesModel {
  ExpensesData? data;
  String? message;
  PostExpensesModel({this.data, this.message});
  PostExpensesModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new ExpensesData.fromJson(json['data']) : null;
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
class ExpensesData {
  int? id;
  String? title;
  String? description;
  String? amount;
  String? date;
  String? paymentMode;
  int? categoryId;

  ExpensesData(
      {this.id,
        this.title,
        this.description,
        this.amount,
        this.date,
        this.paymentMode,
        this.categoryId});

  ExpensesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    amount = json['amount'];
    date = json['date'];
    paymentMode = json['payment_mode'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['payment_mode'] = this.paymentMode;
    data['category_id'] = this.categoryId;
    return data;
  }
}
