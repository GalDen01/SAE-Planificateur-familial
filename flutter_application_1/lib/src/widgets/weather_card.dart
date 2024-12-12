import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final Color backgroundColor;
  final String cityName;
  final String temperature;
  final String weatherLabel;
  final IconData weatherIcon;
  final IconData temperatureIcon;
  final IconData homeIcon;
  final Color textColor;

  const WeatherCard({
    super.key,
    required this.backgroundColor,
    required this.cityName,
    required this.temperature,
    required this.weatherLabel,
    required this.weatherIcon,
    required this.temperatureIcon,
    required this.homeIcon,
    required this.textColor,
  });

  Widget _buildInfoItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor,size: 32.0),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 24, 
            color: textColor, 
            fontWeight: FontWeight.bold
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoItem(homeIcon, cityName),
          const SizedBox(height: 16),
          _buildInfoItem(temperatureIcon, temperature),
          const SizedBox(height: 16),
          _buildInfoItem(weatherIcon, weatherLabel),
        ],
      ),
    );
  }
}
