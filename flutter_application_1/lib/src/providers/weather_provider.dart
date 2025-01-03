import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

/// Exemple d'API : OpenWeatherMap.
/// Il faudra mettre votre propre clé API ci-dessous.
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

  /// Parfois on voudra aussi récupérer un iconCode pour afficher
  /// un joli icône (ex: "01d", "02d"...) via un mapping local
  String _iconCode = '';
  String get iconCode => _iconCode;

  /// Autorisation de localisation
  Future<void> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions refusées définitivement, on peut alerter l'utilisateur
      return;
    }

    // Sinon => on a la permission
  }

  /// Récupérer la position courante et faire un appel API
  Future<void> fetchWeather() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1) Vérifier/récupérer la permission
      await checkLocationPermission();

      // 2) Obtenir la position de l'utilisateur
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3) Appeler l'API OpenWeatherMap (ex : https://api.openweathermap.org/data/2.5/weather)
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather'
        '?lat=${position.latitude}'
        '&lon=${position.longitude}'
        '&units=metric' // pour avoir la température en °C
        '&lang=fr'     // langue FR
        '&appid=$_openWeatherApiKey',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // On extrait quelques informations utiles
        _cityName = data['name'] ?? 'Ville inconnue';
        _temperature = (data['main']['temp'] as num?)?.toDouble() ?? 0.0;
        _weatherDescription = data['weather'][0]['description'] ?? '';
        _iconCode = data['weather'][0]['icon'] ?? '';

        _isLoading = false;
        notifyListeners();
      } else {
        // Gérer l'erreur d'API
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      // Gérer les exceptions (connexion, permission refusée, etc.)
      if (kDebugMode) {
        print("Erreur fetchWeather: $e");
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
