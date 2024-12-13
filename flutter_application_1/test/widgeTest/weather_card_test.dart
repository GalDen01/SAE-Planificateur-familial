import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/src/widgets/weather_card.dart';

void main() {
  testWidgets('WeatherCard displays correct information', (WidgetTester tester) async {
    // Define the test data
    const backgroundColor = Colors.blue;
    const cityName = 'Test City';
    const temperature = '25°C';
    const weatherLabel = 'Sunny';
    const weatherIcon = Icons.wb_sunny;
    const temperatureIcon = Icons.thermostat;
    const homeIcon = Icons.home;
    const textColor = Colors.white;

    // Build the WeatherCard widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeatherCard(
            backgroundColor: backgroundColor,
            cityName: cityName,
            temperature: temperature,
            weatherLabel: weatherLabel,
            weatherIcon: weatherIcon,
            temperatureIcon: temperatureIcon,
            homeIcon: homeIcon,
            textColor: textColor,
          ),
        ),
      ),
    );

    // Verify the WeatherCard displays the correct information
    expect(find.text(cityName), findsOneWidget);
    expect(find.text(temperature), findsOneWidget);
    expect(find.text(weatherLabel), findsOneWidget);
    expect(find.byIcon(homeIcon), findsOneWidget);
    expect(find.byIcon(temperatureIcon), findsOneWidget);
    expect(find.byIcon(weatherIcon), findsOneWidget);
  });
}