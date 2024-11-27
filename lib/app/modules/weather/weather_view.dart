import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../const.dart'; // Ensure this contains your OPENWEATHER_API_KEY

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;
  String _cityName = "Loading...";
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndCity();
  }

  Future<void> _getCurrentLocationAndCity() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _cityName = "Permission Denied";
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        setState(() {
          _cityName = placemarks.first.locality ?? "Unknown Location";
        });
        _fetchWeather(_cityName); // Fetch weather for the detected city
      }
    } catch (e) {
      setState(() {
        _cityName = "Error getting location";
      });
      _showSnackBar("Error: $e");
    }
  }

  Future<void> _fetchWeather(String cityName) async {
    try {
      final weather = await _wf.currentWeatherByCityName(cityName);
      setState(() {
        _weather = weather;
        _cityName =
            _weather?.areaName ?? cityName; // Update city name from response
      });
    } catch (e) {
      setState(() {
        _weather = null;
      });
      _showSnackBar("Error fetching weather for $cityName: $e");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            _searchBar(),
            Expanded(child: _buildUI()),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "Enter city name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) => _onSearch(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onSearch,
          ),
        ],
      ),
    );
  }

  void _onSearch() {
    final cityName = _cityController.text.trim();
    if (cityName.isNotEmpty) {
      _fetchWeather(cityName);
    } else {
      _showSnackBar("Please enter a city name");
    }
  }

  Widget _buildUI() {
    if (_weather == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _locationHeader(),
          const SizedBox(height: 10),
          _dateTimeInfo(),
          const SizedBox(height: 10),
          _weatherIcon(),
          const SizedBox(height: 10),
          _currentTemp(),
          const SizedBox(height: 10),
          _extraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _cityName,
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _dateTimeInfo() {
    if (_weather?.date == null) return const SizedBox.shrink();
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        Text(
          "${DateFormat("EEEE").format(now)}, ${DateFormat("d MMM y").format(now)}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      children: [
        Image.network(
          "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.error,
            size: 80,
          ),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _currentTemp() {
    return Text(
      "${_weather?.temperature?.celsius?.toStringAsFixed(1)}° C",
      style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
    );
  }

  Widget _extraInfo() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTile("Max Temp",
                      "${_weather?.tempMax?.celsius?.toStringAsFixed(1)}° C"),
                  _infoTile("Min Temp",
                      "${_weather?.tempMin?.celsius?.toStringAsFixed(1)}° C"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTile(
                      "Wind", "${_weather?.windSpeed?.toStringAsFixed(1)} m/s"),
                  _infoTile(
                      "Humidity", "${_weather?.humidity?.toStringAsFixed(0)}%"),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _infoTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
