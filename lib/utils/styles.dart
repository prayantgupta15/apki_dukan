import 'package:flutter/material.dart';

//-----------------BORDER RADIUS-------------------------//
BorderRadius BR30 = BorderRadius.circular(30);

//----------------------SHADOWS--------------------------//
BoxShadow shadow = BoxShadow(
  offset: Offset(1, 3),
  color: togalButtonShadowColor,
  spreadRadius: 2,
  blurRadius: 8,
);

//--------------------COLORS-----------------------------//

//search bar
Color searchBarColor = Color(0xf707070);
Color searchBarHintTextColor = Color(0xfC7C7C70).withOpacity(1);

//togals
Color togalSelectedTextColor = Color(0xFFFFFF).withOpacity(1);
Color togalUnselectedTextColor = Color(0xC7C7C7).withOpacity(1);
Color togalButtonShadowColor = Color(0xFF6600).withOpacity(1);

//sub togals
Color subTogalSelectedTextColor = Color(0xFF6F00).withOpacity(1);
Color subTogalUnselectedTextColor = Color(0xC3C3C3).withOpacity(1);

//GRADIENTS
Color gradient1 = Color(0xFFB300).withOpacity(1);
Color gradient2 = Color(0xFF006F).withOpacity(1);
LinearGradient linearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [gradient1, gradient2]);

//SHOP CATEGORY COLOR
Color shopCategoryColor = Color(0xf838383).withOpacity(1);
Color seeAllColor = Color(0xfFF6F00).withOpacity(1);

//----------------------------------TEXT STYLES-------------------------------//

//SEARCH BAR
TextStyle searchBarHintTextStyle = TextStyle(
  fontSize: 12,
  color: searchBarHintTextColor,
);

//TOGALS
TextStyle toggleSelectedTextStyle = TextStyle(
    fontWeight: FontWeight.w500, color: togalSelectedTextColor, fontSize: 22);
TextStyle togelUnselectedTextStyle =
    TextStyle(color: togalUnselectedTextColor, fontSize: 22);

//SUB TOGALS
TextStyle subTogalSelectedStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: subTogalSelectedTextColor,
    fontSize: 12);
TextStyle subTogalUnselectedStyle =
    TextStyle(color: subTogalUnselectedTextColor, fontSize: 12);

//Shops
TextStyle categotyNameTextStyle = TextStyle(
  color: shopCategoryColor,
  fontSize: 12,
);
TextStyle shopNameTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 12,
);
TextStyle seeAllTextStyle = TextStyle(
  color: seeAllColor,
  fontSize: 12,
);
