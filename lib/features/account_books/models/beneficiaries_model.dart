class BeneficiariesModel {
  List<BeneficiariesData>? data;
  String? message;

  BeneficiariesModel({this.data, this.message});

  BeneficiariesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BeneficiariesData>[];
      json['data'].forEach((v) {
        data!.add(new BeneficiariesData.fromJson(v));
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

class BeneficiariesData {
  int? id;
  String? firstName;
  String? lastName;
  String? mobileNumber;
  String? expenseCategoryId;
  String? expenseCategoryName;
  String? createdAt;

  BeneficiariesData(
      {this.id,
        this.firstName,
        this.lastName,
        this.mobileNumber,
        this.expenseCategoryId,
        this.expenseCategoryName,
        this.createdAt});

  BeneficiariesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobileNumber = json['mobile_number'];
    expenseCategoryId = json['expense_category_id'];
    expenseCategoryName = json['expense_category_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile_number'] = this.mobileNumber;
    data['expense_category_id'] = this.expenseCategoryId;
    data['expense_category_name'] = this.expenseCategoryName;
    data['created_at'] = this.createdAt;
    return data;
  }
}