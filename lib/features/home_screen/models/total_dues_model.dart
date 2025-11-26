class Dues {
  DuesData? data;
  String? message;

  Dues({this.data, this.message});

  Dues.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DuesData.fromJson(json['data']) : null;
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

class DuesData {
  bool? isDue;
  String? totalDueAmount;
  String? label;

  DuesData({this.isDue,this.totalDueAmount, this.label});

  DuesData.fromJson(Map<String, dynamic> json) {
    isDue = json['is_due'];
    totalDueAmount = json['total_due_amount'];
    label = json['label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_due'] = this.isDue;
    data['total_due_amount'] = this.totalDueAmount;
    data['label'] = this.label;
    return data;
  }
}
