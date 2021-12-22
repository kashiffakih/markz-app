import 'package:sales_app/core/models/sku.dart';

class SkuAvailability {
  int? id;
  int? skuId;
  String? name;
  bool? isAvailable;
  int? offerId;
  Offer? offer;

  SkuAvailability(
      {this.id,
      this.skuId,
      this.name,
      this.isAvailable,
      this.offerId,
      this.offer});

  SkuAvailability.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skuId = json['sku_id'];
    name = json['name'];
    isAvailable = json['is_available'];
    offerId = json['offer_id'];
    offer = json['offer'] != null ? new Offer.fromJson(json['offer']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sku_id'] = this.skuId;
    data['name'] = this.name;
    data['is_available'] = this.isAvailable;
    data['offer_id'] = this.offerId;
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
    return data;
  }
}
