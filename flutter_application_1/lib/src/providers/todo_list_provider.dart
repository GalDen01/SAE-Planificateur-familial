// lib/src/providers/todo_list_provider.dart

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/models/todo_list.dart';
import 'package:Planificateur_Familial/src/models/todo_task.dart';

class TodoListProvider extends ChangeNotifier {
  final List<TodoListModel> _lists = [];
  List<TodoListModel> get lists => _lists;

  final supabase = Supabase.instance.client;

  Future<void> loadListsForFamily(int familyId) async {
    try {
      final response = await supabase
          .from('todo_lists')
          .select('*')
          .eq('family_id', familyId)
          .order('created_at', ascending: true);

      
      _lists.clear();
      for (var item in response) {
        _lists.add(TodoListModel(
          id: item['id'] as int,
          familyId: item['family_id'] as int,
          name: item['name'] as String,
        ));
      
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
      final response = await supabase
          .from('todo_lists')
          .insert({
            'family_id': familyId,
            'name': name.trim(),
          })
          .select()
          .single();

      
      final newList = TodoListModel(
        id: response['id'] as int,
        familyId: response['family_id'] as int,
        name: response['name'] as String,
      );
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
          .from('todo_lists')
          .delete()
          .eq('id', listId);

      _lists.removeWhere((l) => l.id == listId);
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur deleteList: $e");
    }
  }

  // ========== GESTION DES TÂCHES ========== //

  Future<List<TodoTaskModel>> loadTasksForList(int listId) async {
    try {
      final response = await supabase
          .from('todo_tasks')
          .select('*')
          .eq('list_id', listId)
          .order('created_at', ascending: true);

      
      return response.map((item) => TodoTaskModel.fromJson(item)).toList();
      
    } catch (e) {
      debugPrint("Erreur loadTasksForList: $e");
    }
    return [];
  }

  Future<void> createTask(int listId, String content) async {
    if (content.trim().isEmpty) {
      throw Exception("La tâche ne peut pas être vide.");
    }
    try {
      await supabase.from('todo_tasks').insert({
        'list_id': listId,
        'content': content.trim(),
      });
    } catch (e) {
      debugPrint("Erreur createTask: $e");
      rethrow;
    }
  }

  Future<void> updateTaskChecked(int taskId, bool isChecked) async {
    try {
      await supabase
          .from('todo_tasks')
          .update({'is_checked': isChecked})
          .eq('id', taskId);
    } catch (e) {
      debugPrint("Erreur updateTaskChecked: $e");
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await supabase
          .from('todo_tasks')
          .delete()
          .eq('id', taskId);
    } catch (e) {
      debugPrint("Erreur deleteTask: $e");
    }
  }
}
