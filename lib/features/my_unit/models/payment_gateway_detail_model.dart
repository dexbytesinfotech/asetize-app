class OnPaymentGatewayDetailModel {
  PaymentGatewayDetailData? data;
  String? message;

  OnPaymentGatewayDetailModel({this.data, this.message});

  OnPaymentGatewayDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentGatewayDetailData.fromJson(json['data']) : null;
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

class PaymentGatewayDetailData {
  String? key;
  String? platformFeeLabelName;
  String? gstLabelName;
  double? platformFeePercentage;
  double? gstPercentage;
  String? name;
  String? description;
  bool? upi;
  bool? card;
  bool? netBanking;
  bool? wallet;
  bool? emi;
  bool? payLater;

  PaymentGatewayDetailData(
      {this.key,
        this.platformFeeLabelName,
        this.gstLabelName,
        this.platformFeePercentage,
        this.gstPercentage,
        this.name,
        this.description,
        this.upi,
        this.card,
        this.netBanking,
        this.wallet,
        this.emi,
        this.payLater});

  PaymentGatewayDetailData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    platformFeeLabelName = json['platform_fee_label_name'];
    gstLabelName = json['gst_label_name'];
    platformFeePercentage = json['platform_fee_percentage'];
    gstPercentage = json['gst_percentage'];
    name = json['name'];
    description = json['description'];
    upi = json['upi'];
    card = json['card'];
    netBanking = json['netbanking'];
    wallet = json['wallet'];
    emi = json['emi'];
    payLater = json['paylater'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['platform_fee_label_name'] = this.platformFeeLabelName;
    data['gst_label_name'] = this.gstLabelName;
    data['platform_fee_percentage'] = this.platformFeePercentage;
    data['gst_percentage'] = this.gstPercentage;
    data['name'] = this.name;
    data['description'] = this.description;
    data['upi'] = this.upi;
    data['card'] = this.card;
    data['netbanking'] = this.netBanking;
    data['wallet'] = this.wallet;
    data['emi'] = this.emi;
    data['paylater'] = this.payLater;
    return data;
  }
}
