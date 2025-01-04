import 'package:flutter_test/flutter_test.dart';
import 'package:Planificateur_Familial/src/models/grocery_item.dart';

void main() {
  group('GroceryItemModel', () {
    test('Doit se construire correctement à partir d\'un JSON', () {
      final json = {
        'id': 10,
        'list_id': 5,
        'name': 'Pommes',
        'is_checked': false,
        'quantity': 3,
        'price': 2.5
      };

      final item = GroceryItemModel.fromJson(json);
      expect(item.id, 10);
      expect(item.listId, 5);
      expect(item.name, 'Pommes');
      expect(item.isChecked, false);
      expect(item.quantity, 3);
      expect(item.price, 2.5);
    });

    test('Doit renvoyer un Map<String,dynamic> correct en toJson()', () {
      final item = GroceryItemModel(
        id: 10,
        listId: 5,
        name: 'Pommes',
        isChecked: true,
        quantity: 3,
        price: 2.5,
      );
      final json = item.toJson();
      expect(json['id'], 10);
      expect(json['list_id'], 5);
      expect(json['name'], 'Pommes');
      expect(json['is_checked'], true);
      expect(json['quantity'], 3);
      expect(json['price'], 2.5);
    });
  });
}
