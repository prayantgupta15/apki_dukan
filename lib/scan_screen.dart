import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
//          "flash_on": _flashOnController.text,
//          "flash_off": _flashOffController.text,
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

  String text = "local";
  int _buttonSelected = 0;

  TextStyle selectedStyle =
      TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16);
  TextStyle unselectedStyle = TextStyle(
      fontWeight: FontWeight.w500, color: Colors.black45, fontSize: 14);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        text = "local";
                        _buttonSelected = 0;
                        setState(() {});
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: _buttonSelected == 0
                              ? LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.redAccent, Colors.orange])
                              : null,
                        ),
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
                        text = "global";
                        _buttonSelected = 1;
                        setState(() {});
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
//                          boxShadow: <BoxShadow>[
//                           BoxShadow(
//                             color: Color.b
//                           )
//                          ],
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
            Center(child: Text(text)),
          ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () {
            HapticFeedback.vibrate();
            scan();
          },
          label: Text("Scan QR"),
          icon: Icon(
            Icons.settings_overscan,
          ),
          elevation: 10,
//        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      ),
    );
  }
}
