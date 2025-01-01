// lib/src/models/grocery_list.dart

class GroceryListModel {
  final int? id;
  final int? familyId;
  final String name;

  GroceryListModel({
    this.id,
    this.familyId,
    required this.name,
  });

  factory GroceryListModel.fromJson(Map<String, dynamic> json) {
    return GroceryListModel(
      id: json['id'] as int?,
      familyId: json['family_id'] as int?,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'family_id': familyId,
      'name': name,
    };
  }
}
