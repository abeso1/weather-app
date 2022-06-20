import 'package:flutter/material.dart';
import 'package:weather_app/store/settingsStore.dart';

class TemperatureUnitsToggle extends StatefulWidget {
  @override
  _TemperatureUnitsToggleState createState() => _TemperatureUnitsToggleState();
}

class _TemperatureUnitsToggleState extends State<TemperatureUnitsToggle> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 180,
        height: 20,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
                settingsStore.setTemperaturesUnit("C");
              },
              child: Container(
                width: 90,
                color: selectedIndex == 0 ? Colors.blue : Colors.grey,
                child: Center(
                  child: Text(
                    "Celsius",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
                settingsStore.setTemperaturesUnit("F");
              },
              child: Container(
                width: 90,
                color: selectedIndex == 1 ? Colors.blue : Colors.grey,
                child: Center(
                  child: Text(
                    "Fahrenheit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
