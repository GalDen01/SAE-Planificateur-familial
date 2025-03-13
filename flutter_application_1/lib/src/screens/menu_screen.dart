import 'package:flutter/material.dart';
import '../widgets/weather_card.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF616161),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Menu principal',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const WeatherCard(),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB0BEC5),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            ),
            onPressed: () {},
            child: const Text('Famille #3'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB0BEC5),
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            ),
            onPressed: () {},
            child: const Text('Famille #4'),
          ),
        ],
      ),
    );
  }
}
