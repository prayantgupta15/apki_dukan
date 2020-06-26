// To parse this JSON data, do
//
//     final storeModel = storeModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/services.dart';

List<StoreModel> storeModelFromJson(String str) =>
    List<StoreModel>.from(json.decode(str).map((x) => StoreModel.fromJson(x)));

String storeModelToJson(List<StoreModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreModel {
  StoreModel({
    this.categoryName,
    this.stores,
  });

  String categoryName;
  List<Store> stores;

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        categoryName:
            json["category_name"] == null ? null : json["category_name"],
        stores: json["stores"] == null
            ? null
            : List<Store>.from(json["stores"].map((x) => Store.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "category_name": categoryName == null ? null : categoryName,
        "stores": stores == null
            ? null
            : List<dynamic>.from(stores.map((x) => x.toJson())),
      };
}

class Store {
  Store({
    this.storeName,
    this.delivery,
    this.open,
  });

  String storeName;
  String delivery;
  String open;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeName: json["store_name"] == null ? null : json["store_name"],
        delivery: json["delivery"] == null ? null : json["delivery"],
        open: json["open"] == null ? null : json["open"],
      );

  Map<String, dynamic> toJson() => {
        "store_name": storeName == null ? null : storeName,
        "delivery": delivery == null ? null : delivery,
        "open": open == null ? null : open,
      };
}

Future<List<StoreModel>> getFuture() async {
  String str = await rootBundle.loadString('lib/stores.json');
  return storeModelFromJson(str);
}
