// lib/src/models/grocery_item.dart

class GroceryItemModel {
  final int? id;
  final int listId;
  final String name;
  final bool isChecked;
  final int quantity;    // <-- nouveau
  final double price;    // <-- nouveau

  GroceryItemModel({
    this.id,
    required this.listId,
    required this.name,
    required this.isChecked,
    required this.quantity,
    required this.price,
  });

  factory GroceryItemModel.fromJson(Map<String, dynamic> json) {
    return GroceryItemModel(
      id: json['id'] as int?,
      listId: json['list_id'] as int,
      name: json['name'] as String,
      isChecked: json['is_checked'] as bool,
      quantity: (json['quantity'] as int?) ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'list_id': listId,
      'name': name,
      'is_checked': isChecked,
      'quantity': quantity,
      'price': price,
    };
  }
}