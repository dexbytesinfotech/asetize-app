class PaymentsInitiateModel {
  PaymentsInitiateData? data;
  String? message;

  PaymentsInitiateModel({this.data, this.message});

  PaymentsInitiateModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentsInitiateData.fromJson(json['data']) : null;
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

class PaymentsInitiateData {
  int? paymentAttemptId;
  int? houseId;
  String? houseName;
  String? status;
  String? paymentAttemptStatusDisplay;
  String? amount;
  String? gatewayAmount;
  String? gstAmount;
  String? totalAmount;
  String? paymentGateway;
  String? gatewayTransactionId;
  String? responseMessage;
  String? attemptedAtDisplay;
  String? paidAtDisplay;
  String? createdAtDisplay;
  String? updatedAtDisplay;

  PaymentsInitiateData(
      {this.paymentAttemptId,
        this.houseId,
        this.houseName,
        this.status,
        this.paymentAttemptStatusDisplay,
        this.amount,
        this.gatewayAmount,
        this.gstAmount,
        this.totalAmount,
        this.paymentGateway,
        this.gatewayTransactionId,
        this.responseMessage,
        this.attemptedAtDisplay,
        this.paidAtDisplay,
        this.createdAtDisplay,
        this.updatedAtDisplay});

  PaymentsInitiateData.fromJson(Map<String, dynamic> json) {
    paymentAttemptId = json['payment_attempt_id'];
    houseId = json['house_id'];
    houseName = json['house_name'];
    status = json['status'];
    paymentAttemptStatusDisplay = json['payment_attempt_status_display'];
    amount = json['amount'];
    gatewayAmount = json['gateway_amount'];
    gstAmount = json['gst_amount'];
    totalAmount = json['total_amount'];
    paymentGateway = json['payment_gateway'];
    gatewayTransactionId = json['gateway_transaction_id'];
    responseMessage = json['response_message'];
    attemptedAtDisplay = json['attempted_at_display'];
    paidAtDisplay = json['paid_at_display'];
    createdAtDisplay = json['created_at_display'];
    updatedAtDisplay = json['updated_at_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_attempt_id'] = this.paymentAttemptId;
    data['house_id'] = this.houseId;
    data['house_name'] = this.houseName;
    data['status'] = this.status;
    data['payment_attempt_status_display'] = this.paymentAttemptStatusDisplay;
    data['amount'] = this.amount;
    data['gateway_amount'] = this.gatewayAmount;
    data['gst_amount'] = this.gstAmount;
    data['total_amount'] = this.totalAmount;
    data['payment_gateway'] = this.paymentGateway;
    data['gateway_transaction_id'] = this.gatewayTransactionId;
    data['response_message'] = this.responseMessage;
    data['attempted_at_display'] = this.attemptedAtDisplay;
    data['paid_at_display'] = this.paidAtDisplay;
    data['created_at_display'] = this.createdAtDisplay;
    data['updated_at_display'] = this.updatedAtDisplay;
    return data;
  }
}
