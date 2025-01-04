import 'package:flutter_test/flutter_test.dart';
import 'package:Planificateur_Familial/src/models/family.dart';

void main() {
  group('Family Model', () {
    test('Doit instancier un Family avec un id et un nom', () {
      // Création d'une instance de Family
      final family = Family(id: 1, name: 'Famille Dupont');

      // Vérifications
      expect(family.id, 1);
      expect(family.name, 'Famille Dupont');
    });

    test('Doit instancier un Family sans id', () {
      // Création d'une instance de Family, sans id
      final family = Family(name: 'Famille Martin');
      // On s’attend à ce que l'id soit null
      expect(family.id, isNull);
      expect(family.name, 'Famille Martin');
    });
  });
}
