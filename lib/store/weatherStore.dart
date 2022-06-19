import 'package:rxdart/rxdart.dart';
import 'package:weather_app/models/WeatherDay.dart';

class WeatherStore {
  final BehaviorSubject<List<WeatherDay>?> _weatherForAWeek =
      BehaviorSubject.seeded(null);
  final BehaviorSubject<DateTime?> _selectedDay = BehaviorSubject.seeded(null);
  final BehaviorSubject<double?> _currentTemperature =
      BehaviorSubject.seeded(null);

  ValueStream<List<WeatherDay>?> get weatherForAWeek$ =>
      _weatherForAWeek.stream;
  ValueStream<DateTime?> get selectedDay$ => _selectedDay.stream;
  ValueStream<double?> get currentTemperature$ => _currentTemperature.stream;

  List<WeatherDay>? get weatherForAWeek => _weatherForAWeek.valueOrNull;
  DateTime? get selectedDay => _selectedDay.valueOrNull;
  double? get currentTemperature => _currentTemperature.valueOrNull;

  setWeatherForAWeek(List<WeatherDay> data) {
    _weatherForAWeek.add(data);
  }

  setSelectedDay(DateTime? time) {
    _selectedDay.add(time);
  }

  setCurrentTemperature(double? temperature) {
    _currentTemperature.add(temperature);
  }
}

final WeatherStore weatherStore = WeatherStore();
