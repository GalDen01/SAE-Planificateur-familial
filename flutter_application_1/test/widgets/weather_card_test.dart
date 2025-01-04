import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Planificateur_Familial/src/ui/widgets/weather_card.dart';
import 'package:Planificateur_Familial/src/providers/weather_provider.dart';
import 'package:provider/provider.dart';
import 'package:mocktail/mocktail.dart';


class MockWeatherProvider extends Mock implements WeatherProvider {}
void main() {
  group('WeatherCard Widget', () {
    late MockWeatherProvider mockWeatherProvider;

    setUp(() {
      mockWeatherProvider = MockWeatherProvider();
    });

    testWidgets('Affiche un loader quand isLoading = true', (tester) async {
      // Arrange : Configurer le mock pour retourner isLoading = true
      when(() => mockWeatherProvider.isLoading).thenReturn(true);

      // Act : Pump le widget avec le mock provider
      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherProvider>.value(
          value: mockWeatherProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: WeatherCard(
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Assert : Vérifier la présence d'un CircularProgressIndicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Vérifier qu'aucun texte n'est affiché
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('Affiche les informations météo quand isLoading = false', (tester) async {
      // Arrange : Configurer le mock pour retourner des données météo spécifiques
      when(() => mockWeatherProvider.isLoading).thenReturn(false);
      when(() => mockWeatherProvider.cityName).thenReturn('Paris');
      when(() => mockWeatherProvider.temperature).thenReturn(21.5);
      when(() => mockWeatherProvider.weatherDescription).thenReturn('Ciel dégagé');

      // Act : Pump le widget avec le mock provider
      await tester.pumpWidget(
        ChangeNotifierProvider<WeatherProvider>.value(
          value: mockWeatherProvider,
          child: const MaterialApp(
            home: Scaffold(
              body: WeatherCard(
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              ),
            ),
          ),
        ),
      );

      // Assert : Vérifier la présence des textes spécifiques
      expect(find.text('Paris'), findsOneWidget);
      expect(find.text('21.5°C'), findsOneWidget);
      expect(find.text('Ciel dégagé'), findsOneWidget);
      // Vérifier qu'aucun CircularProgressIndicator n'est affiché
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
