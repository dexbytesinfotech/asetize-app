class SuspenseHistoryModel {
  List<SuspiciousHistoryData>? data;
  String? message;

  SuspenseHistoryModel({this.data, this.message});

  SuspenseHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <SuspiciousHistoryData>[];
      json['data'].forEach((v) {
        data!.add(new SuspiciousHistoryData.fromJson(v));
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

class SuspiciousHistoryData {
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

  SuspiciousHistoryData(
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

  SuspiciousHistoryData.fromJson(Map<String, dynamic> json) {
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


