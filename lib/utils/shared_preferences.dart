import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Store {
  Store({
    @required this.storeName,
    @required this.storeUrl,
  });

  String storeName;
  String storeUrl;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        storeName: json["storeName"] == null ? null : json["storeName"],
        storeUrl: json["storeURL"] == null ? null : json["storeURL"],
      );

  Map<String, dynamic> toJson() => {
        "storeName": storeName == null ? null : storeName,
        "storeURL": storeUrl == null ? null : storeUrl,
      };
}

List<Store> allStoresList = List<Store>();

Future<List<Store>> getStores() async {
  print("getting store");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String str = prefs.getString('stores');
  allStoresList =
      List<Store>.from(json.decode(str).map((x) => Store.fromJson(x)));
  return allStoresList;
}

Future<bool> saveStoreDetails(String storeName, String storeURL) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  allStoresList.add(Store(storeName: storeName, storeUrl: storeURL));
  print("adding into storelist");
  print(allStoresList.length.toString());
  String str =
      json.encode(List<dynamic>.from(allStoresList.map((x) => x.toJson())));
  prefs.setString('stores', str);
  print(prefs.getString('stores'));
  return true;
}

checkIfExist(String url) {
  for (int i = 0; i < allStoresList.length; i++) {
    if (allStoresList[i].storeUrl == url) return true;
  }
  return false;
}
