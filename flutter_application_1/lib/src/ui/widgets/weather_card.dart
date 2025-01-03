import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/providers/weather_provider.dart';

class WeatherCard extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;

  const WeatherCard({
    super.key,
    required this.backgroundColor,
    required this.textColor,
  });

  /// Petit widget pour afficher une info en ligne, ex. le label “28°C” avec son icône
  Widget _buildInfoItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor, size: 32.0),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 24,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    final cityName = weatherProvider.cityName;             // Ville
    final temperature = weatherProvider.temperature;       // Température
    final description = weatherProvider.weatherDescription; // “Pluie”, “Ciel dégagé”, etc.
    final isLoading = weatherProvider.isLoading;           // true le temps de charger

    // On peut choisir des icônes Flutter en fonction de l’iconCode. 
    // Pour l’exemple, on affiche la même icône par défaut.
    final IconData weatherIcon = Icons.cloud; 
    final IconData temperatureIcon = Icons.thermostat;
    final IconData homeIcon = Icons.home;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoItem(homeIcon, cityName),
                const SizedBox(height: 16),
                _buildInfoItem(
                  temperatureIcon,
                  "${temperature.toStringAsFixed(1)}°C",
                ),
                const SizedBox(height: 16),
                _buildInfoItem(weatherIcon, description),
              ],
            ),
    );
  }
}
