import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/weather_model.dart';

class WeatherProvider {
   static const String apiKey = '0efc02baff968d202c4448b62c40204d';  // Replace with your OpenWeatherMap API key';  // Replace with your actual API key
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const double latitude = 35.6895; // Replace with actual latitude
  static const double longitude = 139.6917; // Replace with actual longitude

  Future<WeatherModel> getCurrentWeather(String city) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/weather?q=$city&units=metric&appid=$apiKey'));
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<List<DailyForecast>> getForecast(String city) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/forecast/daily?q=$city&units=metric&cnt=7&appid=$apiKey'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['list'] as List)
            .map((item) => DailyForecast.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }
} 