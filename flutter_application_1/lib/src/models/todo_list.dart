// lib/src/models/todo_list.dart
class TodoListModel {
  final int? id;      // <-- nouvel attribut
  final int? familyId; // <-- on sait à quelle famille appartient la liste
  final String name;

  TodoListModel({
    this.id,
    this.familyId,
    required this.name,
  });
}
