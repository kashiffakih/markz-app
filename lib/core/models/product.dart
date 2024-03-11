import 'package:sales_app/core/models/review.dart';

class Product {
  int? id;
  int? companyId;
  int? userId;
  int? categoryId;
  int? inventoryId;
  String? name;
  String? smallDescription;
  String? description;
  String? location;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? imagepath1;
  String? imagepath2;
  String? imagepath3;
  String? imagepath4;
  int? subCategoryId;
  int? position;
  int? sub2CategoryId;
  int? sub3CategoryId;
  String? vegNonveg;
  String? inventory;
  Category? category;
  SubCategory? subCategory;
  List<ProductPrices>? productPrices;
  List<ProductPack>? productPacks;
  List<Tags>? tags;
  Company? company;
  List<Review>? reviews;

  Product(
      {this.id,
      this.companyId,
      this.userId,
      this.categoryId,
      this.inventoryId,
      this.name,
      this.smallDescription,
      this.description,
      this.location,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.imagepath1,
      this.imagepath2,
      this.imagepath3,
      this.imagepath4,
      this.subCategoryId,
      this.position,
      this.sub2CategoryId,
      this.sub3CategoryId,
      this.vegNonveg,
      this.inventory,
      this.category,
      this.subCategory,
      this.productPrices,
      this.productPacks,
      this.tags,
      this.company,
      this.reviews});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    inventoryId = json['inventory_id'];
    name = json['name'];
    smallDescription = json['small_description'];
    description = json['description'];
    location = json['location'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagepath1 = json['imagepath1'];
    imagepath2 = json['imagepath2'];
    imagepath3 = json['imagepath3'];
    imagepath4 = json['imagepath4'];
    subCategoryId = json['sub_category_id'];
    position = json['position'];
    sub2CategoryId = json['sub_2_category_id'];
    sub3CategoryId = json['sub_3_category_id'];
    vegNonveg = json['veg_nonveg'];
    inventory = json['inventory'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    subCategory = json['sub_category'] != null
        ? new SubCategory.fromJson(json['sub_category'])
        : null;
    if (json['product_prices'] != null) {
      productPrices = <ProductPrices>[];
      json['product_prices'].forEach((v) {
        productPrices!.add(new ProductPrices.fromJson(v));
      });
    }
    if (json['product_packs'] != null) {
      productPacks = <ProductPack>[];
      json['product_packs'].forEach((v) {
        productPacks!.add(new ProductPack.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(new Tags.fromJson(v));
      });
    }
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews!.add(new Review.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['company_id'] = this.companyId;
    data['user_id'] = this.userId;
    data['category_id'] = this.categoryId;
    data['inventory_id'] = this.inventoryId;
    data['name'] = this.name;
    data['small_description'] = this.smallDescription;
    data['description'] = this.description;
    data['location'] = this.location;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imagepath1'] = this.imagepath1;
    data['imagepath2'] = this.imagepath2;
    data['imagepath3'] = this.imagepath3;
    data['imagepath4'] = this.imagepath4;
    data['sub_category_id'] = this.subCategoryId;
    data['position'] = this.position;
    data['sub_2_category_id'] = this.sub2CategoryId;
    data['sub_3_category_id'] = this.sub3CategoryId;
    data['veg_nonveg'] = this.vegNonveg;
    data['inventory'] = this.inventory;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.subCategory != null) {
      data['sub_category'] = this.subCategory!.toJson();
    }
    if (this.productPrices != null) {
      data['product_prices'] =
          this.productPrices!.map((v) => v.toJson()).toList();
    }
    if (this.productPacks != null) {
      data['product_packs'] =
          this.productPacks!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? imagepath;

  Category(
      {this.id, this.name, this.createdAt, this.updatedAt, this.imagepath});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagepath = json['imagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imagepath'] = this.imagepath;
    return data;
  }
}

class SubCategory {
  int? id;
  int? categoryId;
  String? name;
  String? imagepath;
  String? createdAt;
  String? updatedAt;

  SubCategory(
      {this.id,
      this.categoryId,
      this.name,
      this.imagepath,
      this.createdAt,
      this.updatedAt});

  SubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    imagepath = json['imagepath'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['imagepath'] = this.imagepath;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class ProductPrices {
  int? id;
  int? productId;
  int? price;
  int? unitId;
  int? isDefault;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? offerPrice;
  String? offerTill;
  int? productPackId;
  int? cashbackPrice;
  int? distributorPrice;
  int? distributorOfferPrice;
  String? unit;
  ProductPack? productPack;

  ProductPrices(
      {this.id,
      this.productId,
      this.price,
      this.unitId,
      this.isDefault,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.offerPrice,
      this.offerTill,
      this.productPackId,
      this.cashbackPrice,
      this.distributorPrice,
      this.distributorOfferPrice,
      this.unit,
      this.productPack});

  ProductPrices.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    price = json['price'];
    unitId = json['unit_id'];
    isDefault = json['is_default'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    offerPrice = json['offer_price'];
    offerTill = json['offer_till'];
    productPackId = json['product_pack_id'];
    cashbackPrice = json['cashback_price'];
    distributorPrice = json['distributor_price'];
    distributorOfferPrice = json['distributor_offer_price'];
    unit = json['unit'];
    productPack = json['product_pack'] != null
        ? new ProductPack.fromJson(json['product_pack'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['price'] = this.price;
    data['unit_id'] = this.unitId;
    data['is_default'] = this.isDefault;
    data['date'] = this.date;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['offer_price'] = this.offerPrice;
    data['offer_till'] = this.offerTill;
    data['product_pack_id'] = this.productPackId;
    data['cashback_price'] = this.cashbackPrice;
    data['distributor_price'] = this.distributorPrice;
    data['distributor_offer_price'] = this.distributorOfferPrice;
    data['unit'] = this.unit;
    if (this.productPack != null) {
      data['product_pack'] = this.productPack!.toJson();
    }
    return data;
  }
}

class ProductPack {
  int? id;
  int? productId;
  int? value;
  int? unitId;
  String? createdAt;
  String? updatedAt;
  Unit? unit;

  ProductPack(
      {this.id,
      this.productId,
      this.value,
      this.unitId,
      this.createdAt,
      this.updatedAt,
      this.unit});

  ProductPack.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    value = json['value'];
    unitId = json['unit_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    unit = json['unit'] != null ? new Unit.fromJson(json['unit']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['value'] = this.value;
    data['unit_id'] = this.unitId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.unit != null) {
      data['unit'] = this.unit!.toJson();
    }
    return data;
  }
}

class Unit {
  int? id;
  String? name;
  int? divideBy;
  String? createdAt;
  String? updatedAt;

  Unit({this.id, this.name, this.divideBy, this.createdAt, this.updatedAt});

  Unit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    divideBy = json['divide_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['divide_by'] = this.divideBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Tags {
  int? id;
  String? name;
  String? createdAt;
  String? updatedAt;
  String? imagepath;

  Tags({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.imagepath,
  });

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imagepath = json['imagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['imagepath'] = this.imagepath;

    return data;
  }
}

class Company {
  int? id;
  String? name;
  String? email;
  int? phone;
  String? address;
  Null? logoPath;
  Null? contactPerson;
  String? createdAt;
  String? updatedAt;
  Null? timeZone;
  int? isCashbackApplicable;
  int? isDineInAndDelivery;
  int? isReferralAmountUsability;
  String? ownerName;
  Null? add1;
  Null? add2;
  Null? add3;
  String? state;
  Null? city;
  String? pincode;
  String? deliveryCharges;
  String? comissionType;
  String? comissionValue;
  String? rejectPenalty;
  String? position;
  int? isEnabled;
  int? isApproved;
  Null? categoryId;
  int? cityId;
  Null? accNo;
  Null? accName;
  Null? bank;
  Null? branch;
  Null? ifscCode;
  Null? accType;
  String? deliveryDuration;
  String? shortAddress;
  String? openTimeHr;
  String? openTimeMin;
  String? openTimeAmPm;
  int? taxPercent;
  int? packagingCharges;
  int? freeDeliveryApplicable;
  int? freeDeliveryMinAmount;
  int? dineInMinAmount;
  String? shortCategory;
  int? isAvailable;
  String? imagepath;

  Company(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.logoPath,
      this.contactPerson,
      this.createdAt,
      this.updatedAt,
      this.timeZone,
      this.isCashbackApplicable,
      this.isDineInAndDelivery,
      this.isReferralAmountUsability,
      this.ownerName,
      this.add1,
      this.add2,
      this.add3,
      this.state,
      this.city,
      this.pincode,
      this.deliveryCharges,
      this.comissionType,
      this.comissionValue,
      this.rejectPenalty,
      this.position,
      this.isEnabled,
      this.isApproved,
      this.categoryId,
      this.cityId,
      this.accNo,
      this.accName,
      this.bank,
      this.branch,
      this.ifscCode,
      this.accType,
      this.deliveryDuration,
      this.shortAddress,
      this.openTimeHr,
      this.openTimeMin,
      this.openTimeAmPm,
      this.taxPercent,
      this.packagingCharges,
      this.freeDeliveryApplicable,
      this.freeDeliveryMinAmount,
      this.dineInMinAmount,
      this.shortCategory,
      this.isAvailable,
      this.imagepath});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    logoPath = json['logo_path'];
    contactPerson = json['contact_person'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    timeZone = json['time_zone'];
    isCashbackApplicable = json['is_cashback_applicable'];
    isDineInAndDelivery = json['is_dine_in_and_delivery'];
    isReferralAmountUsability = json['is_referral_amount_usability'];
    ownerName = json['owner_name'];
    add1 = json['add_1'];
    add2 = json['add_2'];
    add3 = json['add_3'];
    state = json['state'];
    city = json['city'];
    pincode = json['pincode'];
    deliveryCharges = json['delivery_charges'];
    comissionType = json['comission_type'];
    comissionValue = json['comission_value'];
    rejectPenalty = json['reject_penalty'];
    position = json['position'];
    isEnabled = json['is_enabled'];
    isApproved = json['is_approved'];
    categoryId = json['category_id'];
    cityId = json['city_id'];
    accNo = json['acc_no'];
    accName = json['acc_name'];
    bank = json['bank'];
    branch = json['branch'];
    ifscCode = json['ifsc_code'];
    accType = json['acc_type'];
    deliveryDuration = json['delivery_duration'];
    shortAddress = json['short_address'];
    openTimeHr = json['open_time_hr'];
    openTimeMin = json['open_time_min'];
    openTimeAmPm = json['open_time_am_pm'];
    taxPercent = json['tax_percent'];
    packagingCharges = json['packaging_charges'];
    freeDeliveryApplicable = json['free_delivery_applicable'];
    freeDeliveryMinAmount = json['free_delivery_min_amount'];
    dineInMinAmount = json['dine_in_min_amount'];
    shortCategory = json['short_category'];
    isAvailable = json['is_available'];
    imagepath = json['imagepath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['logo_path'] = this.logoPath;
    data['contact_person'] = this.contactPerson;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['time_zone'] = this.timeZone;
    data['is_cashback_applicable'] = this.isCashbackApplicable;
    data['is_dine_in_and_delivery'] = this.isDineInAndDelivery;
    data['is_referral_amount_usability'] = this.isReferralAmountUsability;
    data['owner_name'] = this.ownerName;
    data['add_1'] = this.add1;
    data['add_2'] = this.add2;
    data['add_3'] = this.add3;
    data['state'] = this.state;
    data['city'] = this.city;
    data['pincode'] = this.pincode;
    data['delivery_charges'] = this.deliveryCharges;
    data['comission_type'] = this.comissionType;
    data['comission_value'] = this.comissionValue;
    data['reject_penalty'] = this.rejectPenalty;
    data['position'] = this.position;
    data['is_enabled'] = this.isEnabled;
    data['is_approved'] = this.isApproved;
    data['category_id'] = this.categoryId;
    data['city_id'] = this.cityId;
    data['acc_no'] = this.accNo;
    data['acc_name'] = this.accName;
    data['bank'] = this.bank;
    data['branch'] = this.branch;
    data['ifsc_code'] = this.ifscCode;
    data['acc_type'] = this.accType;
    data['delivery_duration'] = this.deliveryDuration;
    data['short_address'] = this.shortAddress;
    data['open_time_hr'] = this.openTimeHr;
    data['open_time_min'] = this.openTimeMin;
    data['open_time_am_pm'] = this.openTimeAmPm;
    data['tax_percent'] = this.taxPercent;
    data['packaging_charges'] = this.packagingCharges;
    data['free_delivery_applicable'] = this.freeDeliveryApplicable;
    data['free_delivery_min_amount'] = this.freeDeliveryMinAmount;
    data['dine_in_min_amount'] = this.dineInMinAmount;
    data['short_category'] = this.shortCategory;
    data['is_available'] = this.isAvailable;
    data['imagepath'] = this.imagepath;
    return data;
  }
}
