class FaqModal {
  List<FAQ>? faqList;
  String? message;

  FaqModal({this.faqList, this.message});

  FaqModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      faqList = <FAQ>[];
      json['data'].forEach((v) {
        faqList!.add(new FAQ.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> faqList = new Map<String, dynamic>();
    if (this.faqList != null) {
      faqList['data'] = this.faqList!.map((v) => v.toJson()).toList();
    }
    faqList['message'] = this.message;
    return faqList;
  }
}

class FAQ {
  int? id;
  String? title;
  String? descriptions;
  int? categoryId;
  String? categoryName;
  String? roleType;
  String? status;

  FAQ(
      {this.id,
      this.title,
      this.descriptions,
      this.categoryId,
      this.categoryName,
      this.roleType,
      this.status});

  FAQ.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    descriptions = json['descriptions'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    roleType = json['role_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> faqList = new Map<String, dynamic>();
    faqList['id'] = this.id;
    faqList['title'] = this.title;
    faqList['descriptions'] = this.descriptions;
    faqList['category_id'] = this.categoryId;
    faqList['category_name'] = this.categoryName;
    faqList['role_type'] = this.roleType;
    faqList['status'] = this.status;
    return faqList;
  }
}
