import 'dart:convert';
import 'package:http/http.dart' as http;


class WeatherService {
  final String apiKey = "API KEY HERE"; // Replace with your OpenWeatherMap API key

  Future<Map<String, dynamic>> getCurrentWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'), // Use 'metric' for Celsius
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Map<String, dynamic>> getAirPollution(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$apiKey'),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load air pollution data');
    }
  }
}