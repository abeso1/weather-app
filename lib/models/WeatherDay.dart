class WeatherDay {
  DateTime? dateTime;
  double? min;
  double? max;
  int? weatherId;
  String? weatherMain;
  String? weatherIcon;
  double? pressure;
  double? humidity;
  double? windSpeed;

  WeatherDay({
    this.dateTime,
    this.min,
    this.max,
    this.weatherId,
    this.weatherMain,
    this.weatherIcon,
    this.pressure,
    this.humidity,
    this.windSpeed,
  });

  WeatherDay.fromJson(Map<String, dynamic> json) {
    print(json);
    dateTime =
        DateTime.fromMillisecondsSinceEpoch(json["dt"] * 1000, isUtc: true);
    min = double.parse(json["temp"]["min"].toString());
    max = double.parse(json["temp"]["max"].toString());
    weatherId = json["weather"][0]["id"];
    weatherMain = json["weather"][0]["main"];
    weatherIcon = json["weather"][0]["icon"];
    pressure = double.parse(json["pressure"].toString());
    humidity = double.parse(json["humidity"].toString());
    windSpeed = double.parse(json["wind_speed"].toString());
  }
}
