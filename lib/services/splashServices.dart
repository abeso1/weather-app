import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/views/mainView/mainView.dart';

class SplashServices {
  static splashInitialization(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MainView()));
    });
  }
}
