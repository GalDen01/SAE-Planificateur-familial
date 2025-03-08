import 'package:flutter_test/flutter_test.dart';
import 'package:Planificateur_Familial/src/models/todo_list.dart';

void main() {
  group('TodoListModel', () {
    test('Doit créer une liste de tâches avec ID, familyID et nom', () {
      final todoList = TodoListModel(id: 5, familyId: 2, name: 'A faire');
      expect(todoList.id, 5);
      expect(todoList.familyId, 2);
      expect(todoList.name, 'A faire');
    });
  });
}
