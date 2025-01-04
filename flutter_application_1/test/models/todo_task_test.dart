import 'package:flutter_test/flutter_test.dart';
import 'package:Planificateur_Familial/src/models/todo_task.dart';

void main() {
  group('TodoTaskModel', () {
    test('Doit se construire correctement à partir d\'un JSON', () {
      final json = {
        'id': 11,
        'list_id': 5,
        'content': 'Acheter du pain',
        'is_checked': true
      };
      final task = TodoTaskModel.fromJson(json);

      expect(task.id, 11);
      expect(task.listId, 5);
      expect(task.content, 'Acheter du pain');
      expect(task.isChecked, true);
    });

    test('Doit renvoyer un Map<String, dynamic> correct en toJson()', () {
      final task = TodoTaskModel(
        id: 1,
        listId: 5,
        content: 'Aller à la Poste',
        isChecked: false,
      );
      final map = task.toJson();
      expect(map['id'], 1);
      expect(map['list_id'], 5);
      expect(map['content'], 'Aller à la Poste');
      expect(map['is_checked'], false);
    });
  });
}
