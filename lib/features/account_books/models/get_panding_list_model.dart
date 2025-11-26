class GetPendingListDataModel {
  List<GetPendingListData>? data;
  String? message;
  Pagination? pagination;
  GetPendingListDataModel({this.data, this.message, this.pagination});
  GetPendingListDataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <GetPendingListData>[];
      json['data'].forEach((v) {
        data!.add(new GetPendingListData.fromJson(v));
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
class GetPendingListData {
  int? id;
  String? title;
  String? shortDescription;
  String? description;
  String? paymentMethod;
  String? amount;
  String? status;
  String? imagePath;
  String? createdAt;
  String? duplicateEntryMessage;
  bool? duplicateEntry;


  GetPendingListData(
      {this.id,
        this.title,
        this.shortDescription,
        this.description,
        this.paymentMethod,
        this.amount,
        this.status,
        this.imagePath,
        this.duplicateEntry,
        this.duplicateEntryMessage,
        this.createdAt});

  GetPendingListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    shortDescription = json['short_description'];
    description = json['description'];
    paymentMethod = json['payment_method'];
    amount = json['amount'];
    status = json['status'];
    imagePath = json['image_path'];
    createdAt = json['created_at'];
    duplicateEntryMessage = json["duplicate_entry_message"];
    duplicateEntry = json['duplicate_entry'] ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['payment_method'] = this.paymentMethod;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['image_path'] = this.imagePath;
    data['created_at'] = this.createdAt;
    data['duplicate_entry_message'] = duplicateEntryMessage;
    data['duplicate_entry'] = duplicateEntry ?? false; // Ensure it's not null
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
