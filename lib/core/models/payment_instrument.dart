class PaymentInstrument {
  String? type;
  int? utr;
  dynamic cardNetwork; // Changed to `dynamic` to handle `null` and other types
  String? accountType;

  PaymentInstrument({this.type, this.utr, this.cardNetwork, this.accountType});

  PaymentInstrument.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    utr = json['utr'] is String ? int.tryParse(json['utr']) : json['utr'];
    cardNetwork = json['cardNetwork'];
    accountType = json['accountType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['utr'] = utr;
    data['cardNetwork'] = cardNetwork;
    data['accountType'] = accountType;
    return data;
  }
}
