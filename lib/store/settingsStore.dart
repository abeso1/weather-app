import 'package:rxdart/rxdart.dart';

class SettingsStore {
  final BehaviorSubject<String?> _temperaturesUnit =
      BehaviorSubject.seeded("C");

  ValueStream<String?> get temperaturesUnit$ => _temperaturesUnit.stream;

  String? get temperaturesUnit => _temperaturesUnit.valueOrNull;

  setTemperaturesUnit(String? data) {
    _temperaturesUnit.add(data);
  }

  String getTemperatureString(double temperature,
      {String temperatureUnit = "C"}) {
    if (temperaturesUnit == temperatureUnit && temperatureUnit == "C") {
      return (temperature.toStringAsFixed(0) + "°C");
    }
    if (temperaturesUnit == temperatureUnit && temperatureUnit == "F") {
      return (temperature.toStringAsFixed(0) + " F");
    }
    if (temperaturesUnit == "F" && temperatureUnit == "C") {
      double temp = (temperature * 1.8) + 32;
      return (temp.toStringAsFixed(0) + " F");
    }
    double temp = (temperature - 32) * (5 / 9);
    return (temp.toStringAsFixed(0) + "°C");
  }
}

final SettingsStore settingsStore = SettingsStore();
