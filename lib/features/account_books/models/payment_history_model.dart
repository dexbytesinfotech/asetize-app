class PaymentHistoryModel {
  List<HistoryData>? data;
  String? message;
  Pagination? pagination;
  PaymentHistoryModel({this.data, this.message, this.pagination});
  PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HistoryData>[];
      json['data'].forEach((v) {
        data!.add(new HistoryData.fromJson(v));
      });
    }
    message = json['message'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}
class HistoryData {
  int? id;
  String? title;
  String? description;
  String? subTitle;
  String? amount;
  String? type;
  String? date;
  String? table;
  String? paymentMode;
  String? voucherNumber;

  HistoryData(
      {this.id,
        this.title,
        this.description,
        this.subTitle,
        this.amount,
        this.type,
        this.date,
        this.table,
        this.paymentMode,
        this.voucherNumber

      });

  HistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    subTitle = json['sub_title'];
    amount = json['amount'];
    type = json['type'];
    date = json['date'];
    table = json['table'];
    voucherNumber = json["voucher_number"];
    paymentMode = json["payment_mode"];
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
    data['voucher_number'] = this.voucherNumber;
    data['payment_mode'] = this.paymentMode;
    return data;
  }
}
class Pagination {
  int? currentPage;
  String? prevPageApiUrl;
  String? nextPageApiUrl;
  int? perPage;

  Pagination(
      {this.currentPage,
        this.prevPageApiUrl,
        this.nextPageApiUrl,
        this.perPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    prevPageApiUrl = json['prev_page_api_url'];
    nextPageApiUrl = json['next_page_api_url'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['prev_page_api_url'] = this.prevPageApiUrl;
    data['next_page_api_url'] = this.nextPageApiUrl;
    data['per_page'] = this.perPage;
    return data;
  }
}
