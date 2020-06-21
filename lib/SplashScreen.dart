import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner/scan_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (context) => ScanScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            Center(
              child: Container(
                child: Image(
                  image: AssetImage('assets/splash.jpg'),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.65,
              left: MediaQuery.of(context).size.width * 0.42,
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
