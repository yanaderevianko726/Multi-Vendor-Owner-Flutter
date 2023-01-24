import 'package:efood_multivendor_restaurant/data/model/response/product_model.dart';

class CartModel {
  double price;
  double discountedPrice;
  List<Variation> variation;
  double discountAmount;
  int quantity;
  List<AddOn> addOnIds;
  List<AddOns> addOns;
  bool isCampaign;
  Product product;

  CartModel({this.price, this.discountedPrice, this.variation, this.discountAmount, this.quantity,
    this.addOnIds, this.addOns, this.isCampaign, this.product});

  CartModel.fromJson(Map<String, dynamic> json) {
    price = json['price'].toDouble();
    discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      variation = [];
      json['variation'].forEach((v) {
        variation.add(new Variation.fromJson(v));
      });
    }
    discountAmount = json['discount_amount'].toDouble();
    quantity = json['quantity'];
    if (json['add_on_ids'] != null) {
      addOnIds = [];
      json['add_on_ids'].forEach((v) {
        addOnIds.add(new AddOn.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns.add(new AddOns.fromJson(v));
      });
    }
    isCampaign = json['is_campaign'];
    if (json['product'] != null) {
      product = Product.fromJson(json['product']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['discounted_price'] = this.discountedPrice;
    if (this.variation != null) {
      data['variation'] = this.variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this.discountAmount;
    data['quantity'] = this.quantity;
    if (this.addOnIds != null) {
      data['add_on_ids'] = this.addOnIds.map((v) => v.toJson()).toList();
    }
    if (this.addOns != null) {
      data['add_ons'] = this.addOns.map((v) => v.toJson()).toList();
    }
    data['is_campaign'] = this.isCampaign;
    data['product'] = this.product.toJson();
    return data;
  }
}

class AddOn {
  int id;
  int quantity;

  AddOn({this.id, this.quantity});

  AddOn.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    return data;
  }
}
