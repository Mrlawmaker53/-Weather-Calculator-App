class WeatherModel {
  final String cityName;
  final double currentTemp;
  final String condition;
  final double humidity;
  final double windSpeed;
  final List<DailyForecast> forecast;

  WeatherModel({
    required this.cityName,
    required this.currentTemp,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.forecast,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'],
      currentTemp: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toDouble(),
      windSpeed: json['wind']['speed'].toDouble(),
      forecast: [],  // Will be populated from separate forecast API call
    );
  }
}

class DailyForecast {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final String condition;

  DailyForecast({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      tempMax: json['temp']['max'].toDouble(),
      tempMin: json['temp']['min'].toDouble(),
      condition: json['weather'][0]['main'],
    );
  }
} 