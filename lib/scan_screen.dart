import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:scanner/utils/shared_preferences.dart';
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

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);
  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

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
                    title: Text(
                      "Add Shop",
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                    content: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
//                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "No need to Scan QR again",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: nameController,
                            cursorColor: Colors.deepOrange,
                            decoration: InputDecoration(
                              labelText: "Shop Name",
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: new BorderSide(
                                    color: Colors.deepOrange,
                                  )),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: new BorderSide(
                                    color: Colors.deepOrange,
                                  )),
                              labelStyle: TextStyle(
                                  color: Colors.deepOrange,
                                  fontWeight: FontWeight.bold),
                              hintText: "Twenty7",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: new BorderSide(
                                    color: Colors.deepOrange,
                                  )),
                            ),
                            validator: (String str) {
                              if (str.isEmpty) return "Enter Name";
                            },
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            saveStoreDetails(nameController.text, url);
                            Navigator.pop(context);
                            setState(() {});
                          }
                        },
                      ),
                      FlatButton(
                        child: Text("Cancel",
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold)),
                        onPressed: () {
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

  int _buttonSelected = 0;

  TextStyle selectedStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16);
  TextStyle unselectedStyle = TextStyle(
      fontWeight: FontWeight.w500, color: Colors.black45, fontSize: 14);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
//              height: MediaQuery.of(context).size.height,
                child: Center(
              child: Image(
                image: AssetImage('assets/watermar.png'),
              ),
            )),
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                SizedBox(
                  height: 80,
                ),
                Center(
                  child: Container(
//                  width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xf707070),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
//                    mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            _buttonSelected = 0;
                            setState(() {});
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: _buttonSelected == 0
                                    ? LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                            Colors.redAccent,
                                            Colors.orange
                                          ])
                                    : null,
                                boxShadow: _buttonSelected == 0
                                    ? <BoxShadow>[
                                        BoxShadow(
                                            offset: Offset(0, 0),
                                            color: Colors.deepOrange,
                                            spreadRadius: 2,
                                            blurRadius: 8)
                                      ]
                                    : null),
                            child: Center(
                                child: Text(
                              "Local",
                              style: _buttonSelected == 0
                                  ? selectedStyle
                                  : unselectedStyle,
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _buttonSelected = 1;
                            setState(() {});
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            height: 50,
                            decoration: BoxDecoration(
                              boxShadow: _buttonSelected == 1
                                  ? <BoxShadow>[
                                      BoxShadow(
                                          offset: Offset(-1, 1),
                                          color: Colors.deepOrange,
                                          spreadRadius: 2,
                                          blurRadius: 8)
                                    ]
                                  : null,
                              borderRadius: BorderRadius.circular(30),
                              gradient: _buttonSelected == 1
                                  ? LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [Colors.redAccent, Colors.orange])
                                  : null,
                            ),
                            child: Center(
                                child: Text("Global",
                                    style: _buttonSelected == 1
                                        ? selectedStyle
                                        : unselectedStyle)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: FutureBuilder(
                    future: getStores(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.length > 0) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.deepOrange.withOpacity(0.2),
                                child: ListTile(
                                  leading: Icon(
                                    Icons.shopping_cart,
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    snapshot.data[index].storeName,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  onTap: () async {
                                    String url = snapshot.data[index].storeUrl;
                                    await launch(
                                      url,
                                      forceSafariVC: false,
                                      forceWebView: true,
                                      enableJavaScript: true,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              Text(
                                "No Shops Saved",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
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
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                )
              ],
            ),
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
}
