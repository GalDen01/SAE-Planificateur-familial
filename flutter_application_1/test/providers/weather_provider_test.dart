import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Planificateur_Familial/src/providers/weather_provider.dart';

class MockGeolocator extends Mock {}
class MockHttpClient extends Mock {}

void main() {
  group('WeatherProvider', () {
    late WeatherProvider provider;

    setUp(() {
      provider = WeatherProvider();
    });

    test('Au démarrage, cityName = "Ville inconnue" et isLoading = false', () {
      expect(provider.cityName, 'Ville inconnue');
      expect(provider.isLoading, false);
    });

  });
}
