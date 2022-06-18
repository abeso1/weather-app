import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        var isLandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;
        return Center(
          child: isLandscape ? buildLandscape() : buildPortrait(),
        );
      }),
    );
  }

  Column buildPortrait() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.thunderstorm_outlined, size: 100),
        SizedBox(
          height: 40,
        ),
        _buildWeatherText()
      ],
    );
  }

  Row buildLandscape() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.thunderstorm_outlined, size: 100),
        SizedBox(
          width: 40,
        ),
        _buildWeatherText()
      ],
    );
  }

  Text _buildWeatherText() {
    return Text(
      "Weather App",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
