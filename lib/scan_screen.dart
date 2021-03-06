import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:scanner/Models/storeModel.dart';
import 'package:scanner/categoryShops.dart';
import 'package:scanner/utils/rawData.dart';
import 'package:scanner/utils/shared_preferences.dart';
import 'package:scanner/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  var _aspectTolerance = 0.00;
  var _selectedCamera = 0;
  var _autoEnableFlash = false;
  int _buttonSelected = 0;
  int button = 0;
  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  Widget searchBar() {
    return Row(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.symmetric(horizontal: 10),
          constraints: BoxConstraints(
            maxHeight: 50,
          ),
          decoration: BoxDecoration(color: searchBarColor, borderRadius: BR30),
          child: Center(
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: searchBarHintTextStyle),
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.location_searching,
            color: Colors.deepOrangeAccent,
          ),
          onPressed: () {},
        )
      ],
    );
  }

  Widget toggleButtons() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          constraints: BoxConstraints(
            maxHeight: 50,
          ),
          decoration: BoxDecoration(color: searchBarColor, borderRadius: BR30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _buttonSelected = 0;
                  setState(() {});
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BR30,
                    gradient: _buttonSelected == 0 ? linearGradient : null,
                    boxShadow:
                        _buttonSelected == 0 ? <BoxShadow>[shadow] : null,
                  ),
                  child: Center(
                      child: Text(
                    "Local",
                    style: _buttonSelected == 0
                        ? toggleSelectedTextStyle
                        : togelUnselectedTextStyle,
                  )),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _buttonSelected = 1;
                  setState(() {});
                },
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    boxShadow:
                        _buttonSelected == 1 ? <BoxShadow>[shadow] : null,
                    borderRadius: BR30,
                    gradient: _buttonSelected == 1 ? linearGradient : null,
                  ),
                  child: Center(
                      child: Text("Global",
                          style: _buttonSelected == 1
                              ? toggleSelectedTextStyle
                              : togelUnselectedTextStyle)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget FavNearby() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Favourites",
                style: button == 0
                    ? subTogalSelectedStyle
                    : subTogalUnselectedStyle,
              ),
            ),
            onTap: () {
              setState(() {
                button = 0;
              });
              //TODO:SHOW FAVS
            },
          ),
          Container(
              height: 22, width: 2, color: Color(0x707070).withOpacity(1)),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Nearby",
                style: button == 1
                    ? subTogalSelectedStyle
                    : subTogalUnselectedStyle,
              ),
            ),
            onTap: () {
              button = 1;
              setState(() {});
              //TODO:SHOW FAVS
            },
          ),
//        Divider(d),
        ],
      ),
    );
  }

  Widget getSavedShops() {
    return FutureBuilder(
      future: getStores(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return savedShopsGrid(snapshot);
          } else {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                ),
                Text(
                  "No Shops Saved",
                  style: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ],
            );
          }
        } else {
          return Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Text(
                "No Shops Saved",
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
              ),
            ],
          );
        }
      },
    );
  }

  Widget savedShopsGrid(AsyncSnapshot snapshot) {
    return Scrollbar(
      child: GridView.count(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
        crossAxisSpacing: 10,
        children: List.generate(snapshot.data.length, (index) {
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            child: GestureDetector(
              onTap: () async {
                String url = snapshot.data[index].storeUrl;
                await launch(
                  url,
                  forceSafariVC: false,
                  forceWebView: true,
                  enableJavaScript: true,
                );
              },
              child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/watermark.png'),
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.redAccent, Colors.orange]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          constraints: BoxConstraints(
                            minHeight: 30,
                          ),
                          width: MediaQuery.of(context).size.width * 1,
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(20))),
                          child: Text(
                            snapshot.data[index].storeName,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          )))),
            ),
            color: Colors.transparent,
          );
        }),
      ),
    );
  }

  Future scan() async {
    try {
      var options = ScanOptions(
        strings: {
          "cancel": "cancel",
        },
        restrictFormat: selectedFormats,
        useCamera: _selectedCamera,
        autoEnableFlash: _autoEnableFlash,
        android: AndroidOptions(
          aspectTolerance: _aspectTolerance,
          useAutoFocus: true,
        ),
      );

      var result = await BarcodeScanner.scan(options: options);

      String url = result.rawContent ?? "";
      if (url != "") {
        print(url);

        //url in http: format
        if (url.startsWith("http")) {
          //URl launchable
          if (await canLaunch(url)) {
            print("foundf");
            Fluttertoast.showToast(
              msg: "Found Store for this QR Code.",
              toastLength: Toast.LENGTH_LONG,
            );
            if (!checkIfExist(url)) {
              GlobalKey<FormState> _formKey = GlobalKey<FormState>();
              TextEditingController nameController = TextEditingController();
              showDialog(
                  context: context,
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 30,
                          child: Image(
                            image: AssetImage('assets/watermark.png'),
                          ),
                          backgroundColor: Colors.transparent,
                        ),
                        Text(
                          "Add Shop",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ],
                    ),
                    content: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Text(
                            "No need to Scan QR again",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            enableSuggestions: true,
                            controller: nameController,
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                              labelText: "Enter Shop Name",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: new BorderSide(
                                      color: Colors.deepOrange, width: 2)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: new BorderSide(
                                      color: Colors.deepOrange, width: 2)),
                              labelStyle: TextStyle(
                                  color: Colors.deepOrange,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                              hintText: "Ex.Twenty7",
                              helperStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: new BorderSide(
                                      color: Colors.deepOrange, width: 2)),
                            ),
                            validator: (String str) {
                              if (str.isEmpty)
                                return "Enter Name";
                              else {
                                if (checkName(
                                    nameController.text.toLowerCase()))
                                  return "Already saved shop for this name";
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.deepOrange,
                        elevation: 8,
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            HapticFeedback.vibrate();
                            saveStoreDetails(nameController.text, url);
                            Navigator.pop(context);
                            setState(() {});
                          }
                        },
                      ),
                      RaisedButton(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.deepOrange,
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
                          HapticFeedback.vibrate();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
            }
            await launch(
              url,
              forceSafariVC: false,
              forceWebView: true,
              enableJavaScript: true,
//          headers: <String, String>{'my_header_key': 'my_header_value'},
            );
          }
          //URL not launchable
          else {
            print("not foundf");
            Fluttertoast.showToast(
              msg: "Not Found any Store for this QR Code.",
              toastLength: Toast.LENGTH_LONG,
            );
            throw 'Could not launch $url';
          }
        }

        //url not in http format
        else {
          print("Not a WEbsite URL");
          Fluttertoast.showToast(
            msg: "Not a URL",
            toastLength: Toast.LENGTH_LONG,
          );
          throw 'Could not launch $url';
        }
      }
      setState(() {});
    } on PlatformException catch (e) {
      var result = ScanResult(
        type: ResultType.Error,
        format: BarcodeFormat.unknown,
      );

      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          result.rawContent = 'The user did not grant the camera permission!';
        });
      } else {
        result.rawContent = 'Unknown error: $e';
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
//              height: MediaQuery.of(context).size.height,
                child: Center(
              child: Image(
                image: AssetImage('assets/watermark.png'),
              ),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView(
//                physics: ScrollPhysics(),
                children: <Widget>[
                  SizedBox(height: 30),
                  searchBar(),
                  SizedBox(height: 20),
                  toggleButtons(),
                  SizedBox(height: 20),
                  FavNearby(),
                  SizedBox(height: 20),
//                  getSavedShops(),
                  getShops(),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          onPressed: () {
            HapticFeedback.vibrate();
            scan();
          },
          child: Icon(MdiIcons.qrcodeScan),
          elevation: 10,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget getShops() {
    return FutureBuilder(
      future: getFuture(),
      builder: (context, snapshot) {
        //SNAPSHOT IS List<storeMode>
        if (snapshot.hasData) {
          if (snapshot.data.length == 0)
            return Center(child: Text("Nothing to show"));
          else {
            return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return categoryShops(snapshot.data[index]); // ONe StoreModel
                });
          }
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
}
