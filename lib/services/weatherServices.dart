import 'package:weather_app/interceptors/httpInterceptor.dart';
import 'package:weather_app/models/WeatherDay.dart';
import 'package:weather_app/store/weatherStore.dart';

class WeatherServices {
  static Future<void> getWeatherInfoForCity(String city) async {
    final response1 = await http.get(
        "http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=303cecad711f8ffd443d30316be9b2d1");
    print(response1.data);

    List dec = response1.data;

    Map decoded = dec.first;

    final response2 = await http.get(
        '/data/3.0/onecall?lat=${decoded["lat"]}&lon=${decoded["lon"]}&exclude=hourly,minutely&units=metric&appid=303cecad711f8ffd443d30316be9b2d1');

    print(response2.data);
    Map decodedWeather = response2.data;
    print(decodedWeather["daily"]);

    weatherStore.setCurrentTemperature(decodedWeather["current"]["temp"]);

    List decod = decodedWeather["daily"];

    weatherStore
        .setWeatherForAWeek(decod.map((e) => WeatherDay.fromJson(e)).toList());
  }
}
