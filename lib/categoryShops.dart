import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner/utils/styles.dart';

Widget categoryNameRow(var storeModel) {
  return Container(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(storeModel.categoryName, style: categotyNameTextStyle),
        Text("See All", style: seeAllTextStyle),
      ],
    ),
  );
}

Widget ShopsGrid(var storesList) {
  return Scrollbar(
    child: GridView.count(
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 18,
      children: List.generate(storesList.length, (storeIndex) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.deepOrange,
            image: DecorationImage(
              image: AssetImage('assets/watermark.png'),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      storesList[storeIndex].open.toString() == "true"
                          ? Image.asset('assets/icon1.png')
                          : Container(),
                      storesList[storeIndex].delivery.toString() == "true"
                          ? Image.asset('assets/icon2.png')
                          : Container(),
                    ],
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      constraints: BoxConstraints(
                        minHeight: 30,
                        maxHeight: 50,
                      ),
                      width: 200,
                      decoration: BoxDecoration(
                          gradient: linearGradient,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20))),
                      child: Text(storesList[storeIndex].storeName,
                          style: shopNameTextStyle))),
            ],
          ),
        );
      }),
    ),
  );
}

Widget categoryShops(var storeModel) {
//  return Text(storeModel.stores.runtimeType.toString());
  return Column(
    children: <Widget>[
      categoryNameRow(storeModel),
      ShopsGrid(storeModel.stores),
      SizedBox(height: 20),
    ],
  );
}
