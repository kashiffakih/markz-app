class InvoiceDetail {
  List<Invoices>? invoices;

  InvoiceDetail({this.invoices});

  InvoiceDetail.fromJson(Map<String, dynamic> json) {
    if (json['invoices'] != null) {
      invoices = [];
      json['invoices'].forEach((v) {
        invoices!.add(new Invoices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.invoices != null) {
      data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Invoices {
  int? id;
  String? invoiceNo;
  String? outletName;
  String? invoiceDate;
  int? value;
  int? status;

  Invoices({this.invoiceNo, this.invoiceDate, this.value});

  Invoices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoiceNo = json['invoice_no'];
    outletName = json['outlet_name'];
    invoiceDate = json['invoice_date'];
    value = json['value'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['invoice_no'] = this.invoiceNo;
    data['outlet_name'] = this.outletName;
    data['invoice_date'] = this.invoiceDate;
    data['value'] = this.value;
    data['status'] = this.status;
    return data;
  }
}
