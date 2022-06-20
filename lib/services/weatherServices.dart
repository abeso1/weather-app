import 'package:weather_app/interceptors/httpInterceptor.dart';
import 'package:weather_app/models/WeatherDay.dart';
import 'package:weather_app/store/weatherStore.dart';

class WeatherServices {
  static Future<void> getWeatherInfoForCity(String city) async {
    try {
      weatherStore.setWeatherForAWeek(null);
      weatherStore.setFetchingError(null);

      final response1 = await http.get(
          "http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=303cecad711f8ffd443d30316be9b2d1");

      List dec = response1.data;
      print(dec);
      if (dec.isEmpty) {
        weatherStore.setFetchingError("The city you entered does not exist!");
        return;
      }

      Map decoded = dec.first;

      final response2 = await http.get(
          '/data/3.0/onecall?lat=${decoded["lat"]}&lon=${decoded["lon"]}&exclude=hourly,minutely&units=metric&appid=303cecad711f8ffd443d30316be9b2d1');

      Map decodedWeather = response2.data;
      List decod = decodedWeather["daily"];

      if (decodedWeather["current"]["temp"] == null) {
        weatherStore
            .setFetchingError("There is no current data for entered city!");
        return;
      }

      if (decod.isEmpty) {
        weatherStore
            .setFetchingError("There is no daily data for entered city!");
        return;
      }

      weatherStore.setCurrentTemperature(decodedWeather["current"]["temp"]);

      weatherStore.setWeatherForAWeek(
          decod.map((e) => WeatherDay.fromJson(e)).toList());
    } catch (e) {
      print(e);
      weatherStore.setFetchingError("Unexpected error has happened");
    }
  }
}
