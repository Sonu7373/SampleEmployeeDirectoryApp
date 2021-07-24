import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Center(
            child: Text("Employee Directory",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0)),
          ),
        ),
      ),
    );
  }

  startTime() {
    print("****");
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigateToStartUp);
  }

  void navigateToStartUp() {
    Get.offNamed("/employee-list");
  }
}
