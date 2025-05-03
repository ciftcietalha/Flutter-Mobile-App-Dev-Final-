import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart'; // Import the WeatherService

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Weather'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Current Weather'),
              Tab(text: 'Air Pollution'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CurrentWeatherTab(),
            AirPollutionTab(),
          ],
        ),
      ),
    );
  }
}

class CurrentWeatherTab extends StatefulWidget {
  const CurrentWeatherTab({super.key});

  @override
  _CurrentWeatherTabState createState() => _CurrentWeatherTabState();
}

class _CurrentWeatherTabState extends State<CurrentWeatherTab> {
  WeatherService weatherService = WeatherService();
  Map<String, dynamic>? currentWeather;
  bool isLoading = true;
  String temperatureUnit = 'Celsius';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    try {
      currentWeather = await weatherService.getCurrentWeather(position.latitude, position.longitude);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? CircularProgressIndicator()
            : Column(
          children: [
            Text('Temperature: ${currentWeather!['main']['temp']}°$temperatureUnit'),
            // Add more weather details here
            PopupMenuButton<String>(
              onSelected: (String value) {
                setState(() {
                  temperatureUnit = value;
                });
              },
              itemBuilder: (BuildContext context) {
                return {'Celsius', 'Fahrenheit'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ],
    );
  }
}

class AirPollutionTab extends StatefulWidget {
  const AirPollutionTab({super.key});

  @override
  _AirPollutionTabState createState() => _AirPollutionTabState();
}

class _AirPollutionTabState extends State<AirPollutionTab> {
  WeatherService weatherService = WeatherService();
  Map<String, dynamic>? airPollutionData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAirPollutionData();
  }

  Future<void> _fetchAirPollutionData() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    try {
      airPollutionData = await weatherService.getAirPollution(position.latitude, position.longitude);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      // Handle error
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isLoading
            ? CircularProgressIndicator()
            : Text('Air Quality Index: ${airPollutionData!['list'][0]['main']['aqi']}'),
      ],
    );
  }
}