// lib/src/providers/grocery_list_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/grocery_list.dart';
import 'package:Planificateur_Familial/src/models/grocery_item.dart';

class GroceryListProvider extends ChangeNotifier {
  final List<GroceryListModel> _lists = [];
  List<GroceryListModel> get lists => _lists;

  final supabase = Supabase.instance.client;

  /// Charge toutes les grocery_lists d'une famille
  Future<void> loadListsForFamily(int familyId) async {
    try {
      final response = await supabase
          .from('grocery_lists')
          .select('*')
          .eq('family_id', familyId)
          .order('created_at', ascending: true);

      if (response is List) {
        _lists.clear();
        for (var item in response) {
          _lists.add(GroceryListModel.fromJson(item));
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur loadListsForFamily: $e");
    }
  }

  /// Crée une liste pour une famille
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

      if (data != null) {
        final newList = GroceryListModel.fromJson(data);
        _lists.add(newList);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Erreur createList: $e");
      rethrow;
    }
  }

  /// Supprime une liste
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

  // ========== GESTION DES ARTICLES ========== //

  /// Charge les articles d'une grocery_list
  Future<List<GroceryItemModel>> loadItemsForList(int listId) async {
    try {
      final response = await supabase
          .from('grocery_items')
          .select('*')
          .eq('list_id', listId)
          .order('created_at', ascending: true);

      if (response is List) {
        return response.map((item) => GroceryItemModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint("Erreur loadItemsForList: $e");
    }
    return [];
  }

  /// Crée un nouvel article
  Future<void> createItem(int listId, String name, int quantity, double price) async {
    if (name.trim().isEmpty) {
      throw Exception("Le nom de l'article ne peut pas être vide.");
    }
    try {
      await supabase.from('grocery_items').insert({
        'list_id': listId,
        'name': name.trim(),
        'quantity': quantity,
        'price': price,
      });
    } catch (e) {
      debugPrint("Erreur createItem: $e");
      rethrow;
    }
  }

  /// Met à jour l'état is_checked d'un article
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

  /// Met à jour la quantité ou le prix, etc.
  Future<void> updateItem(int itemId, {int? quantity, double? price}) async {
    // Permet de faire un "update" partiel
    final Map<String, dynamic> updates = {};
    if (quantity != null) updates['quantity'] = quantity;
    if (price != null) updates['price'] = price;

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

  /// Supprime un article
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

  /// Calcule le budget total d'une liste
  /// sum(quantity * price)
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
