import 'package:aadab/core/models/payment_instrument.dart';

class Payment {
  String? merchantId;
  String? merchantTransactionId;
  String? transactionId;
  int? amount;
  String? state;
  String? responseCode;
  String? code;
  String? message;
  PaymentInstrument? paymentInstrument;

  Payment(
      {this.merchantId,
      this.merchantTransactionId,
      this.transactionId,
      this.amount,
      this.state,
      this.responseCode,
      this.code,
      this.message,
      this.paymentInstrument});

  Payment.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    merchantTransactionId = json['merchantTransactionId'];
    transactionId = json['transactionId'];
    // Convert 'amount' to int safely
    amount = json['amount'] is String
        ? int.tryParse(json['amount'])
        : json['amount'];
    state = json['state'];
    responseCode = json['responseCode'];
    code = json['code'];
    message = json['message'];
    paymentInstrument = json['paymentInstrument'] != null
        ? PaymentInstrument.fromJson(json['paymentInstrument'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['merchantTransactionId'] = merchantTransactionId;
    data['transactionId'] = transactionId;
    data['amount'] = amount;
    data['state'] = state;
    data['responseCode'] = responseCode;
    data['code'] = code;
    data['message'] = message;
    if (paymentInstrument != null) {
      data['paymentInstrument'] = paymentInstrument!.toJson();
    }
    return data;
  }
}
