class CheckBarcodeModel {
  CheckBarcodeData? data;
  String? message;

  CheckBarcodeModel({this.data, this.message});

  CheckBarcodeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? CheckBarcodeData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class CheckBarcodeData {
  bool? exists;
  String? barcode;
  BarcodeDetails? data;

  CheckBarcodeData({this.exists, this.barcode, this.data});

  CheckBarcodeData.fromJson(Map<String, dynamic> json) {
    exists = json['exists'];
    barcode = json['barcode'];
    data = json['data'] != null ? BarcodeDetails.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['exists'] = this.exists;
    data['barcode'] = this.barcode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class BarcodeDetails {
  int? id;
  String? label;
  dynamic productId;
  bool? isAssigned;
  String? batch;
  String? createdAt;
  String? updatedAt;

  BarcodeDetails({
    this.id,
    this.label,
    this.productId,
    this.isAssigned,
    this.batch,
    this.createdAt,
    this.updatedAt,
  });

  BarcodeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    productId = json['product_id'];
    isAssigned = json['is_assigned'];
    batch = json['batch'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['label'] = this.label;
    data['product_id'] = this.productId;
    data['is_assigned'] = this.isAssigned;
    data['batch'] = this.batch;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
