import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String _openWeatherApiKey = '44ae218709fea1624e50de0828f3b821';

class WeatherProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _cityName = 'Ville inconnue';
  String get cityName => _cityName;

  double _temperature = 0.0;
  double get temperature => _temperature;

  String _weatherDescription = '';
  String get weatherDescription => _weatherDescription;

  String _iconCode = '';
  String get iconCode => _iconCode;

  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
  }

  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      await checkLocationPermission();
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=${position.latitude}'
        '&lon=${position.longitude}'
        '&units=metric'
        '&lang=fr'
        '&appid=$_openWeatherApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cityName = data['name'] ?? 'Ville inconnue';
        _temperature = (data['main']['temp'] as num?)?.toDouble() ?? 0.0;
        _weatherDescription = data['weather'][0]['description'] ?? '';
        _iconCode = data['weather'][0]['icon'] ?? '';
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur fetchWeather: $e");
      }
    }

    _isLoading = false;
    notifyListeners();
  }
}
