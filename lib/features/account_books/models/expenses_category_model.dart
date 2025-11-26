class ExpensesCategoryModel {
  List<ExpensesData>? data;
  String? message;
  ExpensesCategoryModel({this.data, this.message});
  ExpensesCategoryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ExpensesData>[];
      json['data'].forEach((v) {
        data!.add(ExpensesData.fromJson(v));
      });
    }
    message = json['message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}
class ExpensesData {
  int? id;
  String? name;

  ExpensesData({this.id, this.name});

  ExpensesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
