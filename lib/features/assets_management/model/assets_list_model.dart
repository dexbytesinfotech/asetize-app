class AssetListModel {
  List<AssetListData>? data; // For list API
  AssetListData? detailData; // For detail API
  String? message;
  Pagination? pagination;


  AssetListModel({this.data, this.message, this.detailData});

  AssetListModel.fromJson(Map<String, dynamic> json) {
    // Handle case: when 'data' is a list (Asset List API)
    if (json['data'] is List) {
      data = <AssetListData>[];
      json['data'].forEach((v) {
        data!.add(AssetListData.fromJson(v));
      });
    }
    // Handle case: when 'data' is a single object (Asset Detail AP  I)
    else if (json['data'] is Map<String, dynamic>) {
      detailData = AssetListData.fromJson(json['data']);
    }

    message = json['message'];
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    } else if (detailData != null) {
      data['data'] = detailData!.toJson();
    }
    data['message'] = message;
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class AssetListData {
  int? id;
  String? title;
  String? description;
  String? smallDescription;
  String? itemCode;
  String? modelNumber;
  String? manufacture;
  double? purchaseCost; // 🔹 Now always double
  String? purchaseCostDisplay;
  String? licenseKey;
  String? registrationDateDisplay;
  String? expiredDateDisplay;
  String? warrantyDateDisplay;
  String? registrationDate;
  String? expiredDate;
  String? warrantyDate;
  int? expirationMonths;
  int? warrantyMonths;
  String? status;
  Category? category;
  Vendor? vendor;
  Assign? assign;
  List<String>? invoiceFile;
  String? createdAt;
  String? updatedAt;
  String? location;
  Barcode? barcode;
  bool? isBarcode;



  AssetListData({
    this.id,
    this.title,
    this.description,
    this.smallDescription,
    this.itemCode,
    this.modelNumber,
    this.manufacture,
    this.purchaseCost,
    this.purchaseCostDisplay,
    this.licenseKey,
    this.registrationDateDisplay,
    this.expiredDateDisplay,
    this.warrantyDateDisplay,
    this.registrationDate,
    this.expiredDate,
    this.warrantyDate,
    this.expirationMonths,
    this.warrantyMonths,
    this.status,
    this.category,
    this.vendor,
    this.assign,
    this.invoiceFile,
    this.createdAt,
    this.updatedAt,
    this.location,
    this.barcode,
    this.isBarcode
  });

  AssetListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    smallDescription = json['small_description'];
    itemCode = json['item_code'];
    modelNumber = json['model_number'];
    manufacture = json['manufacture'];

    // 🔹 Safe handling for purchase_cost (can be int, double, or string)
    if (json['purchase_cost'] != null) {
      final value = json['purchase_cost'];
      if (value is int) {
        purchaseCost = value.toDouble();
      } else if (value is double) {
        purchaseCost = value;
      } else if (value is String) {
        purchaseCost = double.tryParse(value);
      }
    }

    purchaseCostDisplay = json['purchase_cost_display'];
    licenseKey = json['license_key'];
    registrationDateDisplay = json['registration_date_display'];
    expiredDateDisplay = json['expired_date_display'];
    warrantyDateDisplay = json['warranty_date_display'];
    registrationDate = json['registration_date'];
    expiredDate = json['expired_date'];
    warrantyDate = json['warranty_date'];

    // 🔹 Safe handling for integer fields (can be string too)
    expirationMonths = _parseInt(json['expiration_months']);
    warrantyMonths = _parseInt(json['warranty_months']);

    status = json['status'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    vendor = json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    assign = json['assign'] != null &&
        json['assign'] is Map<String, dynamic> &&
        json['assign'].isNotEmpty
        ? Assign.fromJson(json['assign'])
        : null;

    invoiceFile = json['invoice_file'] != null
        ? List<String>.from(json['invoice_file'])
        : [];

    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    location = json['location'];
    barcode =
    json['barcode'] != null ? new Barcode.fromJson(json['barcode']) : null;
    isBarcode = json['is_barcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['small_description'] = smallDescription;
    data['item_code'] = itemCode;
    data['model_number'] = modelNumber;
    data['manufacture'] = manufacture;
    data['purchase_cost'] = purchaseCost;
    data['purchase_cost_display'] = purchaseCostDisplay;
    data['license_key'] = licenseKey;
    data['registration_date_display'] = registrationDateDisplay;
    data['expired_date_display'] = expiredDateDisplay;
    data['warranty_date_display'] = warrantyDateDisplay;
    data['registration_date'] = registrationDate;
    data['expired_date'] = expiredDate;
    data['warranty_date'] = warrantyDate;
    data['expiration_months'] = expirationMonths;
    data['warranty_months'] = warrantyMonths;
    data['status'] = status;
    if (category != null) data['category'] = category!.toJson();
    if (vendor != null) data['vendor'] = vendor!.toJson();
    if (assign != null) data['assign'] = assign!.toJson();
    if (invoiceFile != null) data['invoice_file'] = invoiceFile;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['location'] = location;
    if (this.barcode != null) {
      data['barcode'] = this.barcode!.toJson();
    }
    data['is_barcode'] = this.isBarcode;

    return data;
  }

  // 🔹 Helper: safely parse int from dynamic (handles int/string/double/null)
  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}

class Vendor {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? content;
  int? status;

  Vendor({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.content,
    this.status,
  });

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    content = json['content'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'content': content,
    'status': status,
  };
}

class Assign {
  int? userId;
  String? name;
  String? profilePhoto;
  String? status;
  String? assignedDateDisplay;
  String? returnDateDisplay;

  Assign(
      {this.userId,
        this.name,
        this.profilePhoto,
        this.status,
        this.assignedDateDisplay,
        this.returnDateDisplay});

  Assign.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    profilePhoto = json['profile_photo'];
    status = json['status'];
    assignedDateDisplay = json['assigned_date_display'];
    returnDateDisplay = json['return_date_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['profile_photo'] = this.profilePhoto;
    data['status'] = this.status;
    data['assigned_date_display'] = this.assignedDateDisplay;
    data['return_date_display'] = this.returnDateDisplay;
    return data;
  }
}


class Barcode {
  int? id;
  String? barcode;
  String? label;
  String? createdAt;
  String? updatedAt;

  Barcode({this.id, this.barcode, this.label, this.createdAt, this.updatedAt});

  Barcode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    barcode = json['barcode'];
    label = json['label'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['barcode'] = this.barcode;
    data['label'] = this.label;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
