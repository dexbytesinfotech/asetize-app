class PaymentMethodModel {
  PaymentMethodData? data;
  String? message;

  PaymentMethodModel({this.data, this.message});
  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new PaymentMethodData.fromJson(json['data']) : null;
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

class PaymentMethodData {
  String? cASHPAYMENT;
  String? cHEQUEPAYMENTS;
  String? bANKTRANSFER;
  String? dIGITALWALLETS;
  String? cREDITCARD;
  String? dEBITCARD;

  PaymentMethodData(
      {this.cASHPAYMENT,
        this.cHEQUEPAYMENTS,
        this.bANKTRANSFER,
        this.dIGITALWALLETS,
        this.cREDITCARD,
        this.dEBITCARD});

  PaymentMethodData.fromJson(Map<String, dynamic> json) {
    cASHPAYMENT = json['CASH_PAYMENT'];
    cHEQUEPAYMENTS = json['CHEQUE_PAYMENTS'];
    bANKTRANSFER = json['BANK_TRANSFER'];
    dIGITALWALLETS = json['DIGITAL_WALLETS'];
    cREDITCARD = json['CREDIT_CARD'];
    dEBITCARD = json['DEBIT_CARD'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CASH_PAYMENT'] = this.cASHPAYMENT;
    data['CHEQUE_PAYMENTS'] = this.cHEQUEPAYMENTS;
    data['BANK_TRANSFER'] = this.bANKTRANSFER;
    data['DIGITAL_WALLETS'] = this.dIGITALWALLETS;
    data['CREDIT_CARD'] = this.cREDITCARD;
    data['DEBIT_CARD'] = this.dEBITCARD;
    return data;
  }
}
