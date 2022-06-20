import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/WeatherDay.dart';
import 'package:weather_app/services/weatherServices.dart';
import 'package:weather_app/store/weatherStore.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String? searchText = "London";
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    WeatherServices.getWeatherInfoForCity(searchText!).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          await WeatherServices.getWeatherInfoForCity(searchText!);
          setState(() {
            isLoading = false;
          });
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildSearchContainer(),
              if (!isLoading) _buildWeatherList(isLandscape),
              if (isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSearchContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      height: 90,
      child: Row(
        children: [
          _buildCityTextField(),
          SizedBox(
            width: 10,
          ),
          _buildSearchButton()
        ],
      ),
    );
  }

  _buildWeatherList(isLandscape) {
    return StreamBuilder(
        stream: weatherStore.selectedDay$,
        builder: (context, AsyncSnapshot<DateTime?> selectedDaySnapshot) {
          DateTime? selectedDay = selectedDaySnapshot.data;
          return StreamBuilder(
            stream: weatherStore.weatherForAWeek$,
            builder: (context, AsyncSnapshot<List<WeatherDay>?> snapshot) {
              List<WeatherDay>? weathers = snapshot.data ?? [];
              if (weathers.isEmpty && weatherStore.fetchingError != null)
                return Container(
                  height: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(weatherStore.fetchingError!),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text("Reload"),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          WeatherServices.getWeatherInfoForCity(searchText!)
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                      ),
                    ],
                  ),
                );
              return Column(
                children: [
                  Container(
                    height: 200,
                    child: ListView.separated(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return _listItem(weathers, index, selectedDay);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 13,
                          );
                        },
                        itemCount: weathers.length),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: selectedDay == null
                        ? Text("Select a day from the list!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ))
                        : _buildWeatherDetails(isLandscape),
                  ),
                ],
              );
            },
          );
        });
  }

  InkWell _listItem(
      List<WeatherDay> weathers, int index, DateTime? selectedDay) {
    return InkWell(
      onTap: () {
        weatherStore.setSelectedDay(weathers[index].dateTime!);
      },
      child: Container(
        height: 180,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: selectedDay == null ||
                  !selectedDay.isAtSameMomentAs(weathers[index].dateTime!)
              ? null
              : Border.all(
                  width: 1,
                  color: Colors.blue,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              DateFormat(DateFormat.ABBR_WEEKDAY)
                  .format(weathers[index].dateTime!),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Image.network(
              "http://openweathermap.org/img/wn/${weathers[index].weatherIcon}@2x.png",
              height: 70,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              weathers[index].min!.toStringAsFixed(0) +
                  "°C / " +
                  weathers[index].max!.toStringAsFixed(0) +
                  "°C",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buildWeatherDetails(isLandscape) {
    final WeatherDay weatherDay = weatherStore.weatherForAWeek!
        .where((element) => weatherStore.selectedDay! == element.dateTime!)
        .first;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            "http://openweathermap.org/img/wn/${weatherDay.weatherIcon}@2x.png",
            height: 100,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weatherDay.weatherMain!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                DateFormat(DateFormat.WEEKDAY).format(weatherDay.dateTime!) +
                    ", " +
                    DateFormat("dd.MM.yyyy.").format(weatherDay.dateTime!),
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
          if (isLandscape) _details(weatherDay)
        ],
      ),
      if (!isLandscape) _details(weatherDay),
      Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 20,
        ),
        child: Text(
            "Current temperature: " +
                weatherStore.currentTemperature!.toStringAsFixed(1) +
                "°C",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
      ),
    ]);
  }

  Padding _details(WeatherDay weatherDay) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Humidity: " + weatherDay.humidity!.toStringAsFixed(0) + "%",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 3),
          Text(
            "Pressure: " + weatherDay.pressure!.toStringAsFixed(0) + "hPa",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 3),
          Text(
            "Wind: " + weatherDay.windSpeed!.toStringAsFixed(1) + "m/s",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildCityTextField() {
    return Expanded(
      flex: 3,
      child: TextFormField(
        initialValue: searchText,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: "City",
        ),
        textCapitalization: TextCapitalization.words,
        onChanged: (val) {
          setState(() {
            searchText = val;
          });
        },
      ),
    );
  }

  Expanded _buildSearchButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: searchText == null || searchText!.isEmpty
            ? null
            : () async {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {
                  isLoading = true;
                });
                weatherStore.setSelectedDay(null);
                await WeatherServices.getWeatherInfoForCity(searchText!);
                setState(() {
                  isLoading = false;
                });
              },
        child: Text("Search"),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text("Weather App", style: TextStyle(color: Colors.black)),
      backgroundColor: Colors.white,
    );
  }
}
