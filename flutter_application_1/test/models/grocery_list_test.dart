import 'package:flutter_test/flutter_test.dart';
import 'package:Planificateur_Familial/src/models/grocery_list.dart';

void main() {
  group('GroceryListModel', () {
    test('Doit se construire correctement à partir d\'un JSON', () {
      final json = {
        'id': 2,
        'family_id': 1,
        'name': 'Courses du week-end'
      };
      final list = GroceryListModel.fromJson(json);

      expect(list.id, 2);
      expect(list.familyId, 1);
      expect(list.name, 'Courses du week-end');
    });

    test('Doit renvoyer un Map<String, dynamic> correct en toJson()', () {
      final glist = GroceryListModel(id: 3, familyId: 1, name: 'Apéritif');
      final map = glist.toJson();
      expect(map['id'], 3);
      expect(map['family_id'], 1);
      expect(map['name'], 'Apéritif');
    });
  });
}
