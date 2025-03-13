import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/grocery_list.dart';
import 'package:Planificateur_Familial/src/models/grocery_item.dart';

class GroceryListProvider extends ChangeNotifier {
  final List<GroceryListModel> _lists = [];
  List<GroceryListModel> get lists => _lists;

  final supabase = Supabase.instance.client;


  Future<void> loadListsForFamily(int familyId) async {
    try {
      final response = await supabase
          .from('grocery_lists')
          .select('*')
          .eq('family_id', familyId)
          .order('created_at', ascending: true);


      _lists.clear();
      for (var item in response) {
        _lists.add(GroceryListModel.fromJson(item));
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur loadListsForFamily: $e");
    }
  }

  Future<void> createList(int familyId, String name) async {
    if (name.trim().isEmpty) {
      throw Exception("Le nom de la liste ne peut pas être vide.");
    }
    try {
      final data = await supabase
          .from('grocery_lists')
          .insert({
            'family_id': familyId,
            'name': name.trim(),
          })
          .select()
          .single();


      final newList = GroceryListModel.fromJson(data);
      _lists.add(newList);
      notifyListeners();

    } catch (e) {
      debugPrint("Erreur createList: $e");
      rethrow;
    }
  }


  Future<void> deleteList(int listId) async {
    try {
      await supabase
          .from('grocery_lists')
          .delete()
          .eq('id', listId);

      _lists.removeWhere((l) => l.id == listId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur deleteList: $e");
    }
  }

  // ================== GESTION DES ARTICLES ================== //

  Future<List<GroceryItemModel>> loadItemsForList(int listId) async {
    try {
      final response = await supabase
          .from('grocery_items')
          .select('*')
          .eq('list_id', listId)
          .order('created_at', ascending: true);


      return response.map((item) => GroceryItemModel.fromJson(item)).toList();

    } catch (e) {
      debugPrint("Erreur loadItemsForList: $e");
    }
    return [];
  }

  Future<void> createItem(
    int listId,
    String name,
    int quantity,
    double price, {
    bool isPromo = false,
  }) async {
    if (name.trim().isEmpty) {
      throw Exception("Le nom de l'article ne peut pas être vide.");
    }
    try {
      await supabase.from('grocery_items').insert({
        'list_id': listId,
        'name': name.trim(),
        'quantity': quantity,
        'price': price,
        'is_on_promotion': isPromo,
      });
    } catch (e) {
      debugPrint("Erreur createItem: $e");
      rethrow;
    }
  }

  Future<void> updateItemChecked(int itemId, bool isChecked) async {
    try {
      await supabase
          .from('grocery_items')
          .update({'is_checked': isChecked})
          .eq('id', itemId);
    } catch (e) {
      debugPrint("Erreur updateItemChecked: $e");
    }
  }

  Future<void> updateItem(
    int itemId, {
    int? quantity,
    double? price,
    bool? isPromo,
  }) async {
    final Map<String, dynamic> updates = {};
    if (quantity != null) updates['quantity'] = quantity;
    if (price != null) updates['price'] = price;
    if (isPromo != null) updates['is_on_promotion'] = isPromo;

    if (updates.isEmpty) return;

    try {
      await supabase
          .from('grocery_items')
          .update(updates)
          .eq('id', itemId);
    } catch (e) {
      debugPrint("Erreur updateItem: $e");
    }
  }


  Future<void> deleteItem(int itemId) async {
    try {
      await supabase
          .from('grocery_items')
          .delete()
          .eq('id', itemId);
    } catch (e) {
      debugPrint("Erreur deleteItem: $e");
    }
  }


  Future<double> getTotalBudget(int listId) async {
    double total = 0.0;
    try {
      final items = await loadItemsForList(listId);
      for (var i in items) {
        total += (i.quantity * i.price);
      }
    } catch (e) {
      debugPrint("Erreur getTotalBudget: $e");
    }
    return total;
  }
}
