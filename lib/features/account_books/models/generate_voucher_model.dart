class GeneratedVoucherModel {
  String? pdfUrl;
  String? message;

  GeneratedVoucherModel({this.pdfUrl, this.message});

  GeneratedVoucherModel.fromJson(Map<String, dynamic> json) {
    pdfUrl = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> date = new Map<String, dynamic>();
    date['data'] = this.pdfUrl;
    date['message'] = this.message;
    return date;
  }
}