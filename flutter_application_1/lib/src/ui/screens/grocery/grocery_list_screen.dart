// lib/src/ui/screens/grocery/grocery_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/models/grocery_item.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';

class GroceryListScreen extends StatefulWidget {
  final int listId;
  final String listName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const GroceryListScreen({
    super.key,
    required this.listId,
    required this.listName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItemModel> _items = [];
  bool _showOnlyUnchecked = false; // Filtre
  double _totalBudget = 0.0;        // budget total

  String _errorMessage = '';        // Pour afficher un message d’erreur global si besoin

  final List<String> _units = ['ml', 'kg', 'g', 'l', 'mg', 'cl', 'pcs'];
  String _selectedUnit = ''; // Initialisation de l'unité sélectionnée

  @override
  void initState() {
    super.initState();
    _selectedUnit = _units.first; // Initialisation dans initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadItemsAndBudget();
    });
  }

  Future<void> loadItemsAndBudget() async {
    final provider = context.read<GroceryListProvider>();
    final items = await provider.loadItemsForList(widget.listId);
    final total = await provider.getTotalBudget(widget.listId);
    setState(() {
      _items = items;
      _totalBudget = total;
    });
  }

  List<GroceryItemModel> get filteredItems {
    if (_showOnlyUnchecked) {
      return _items.where((i) => !i.isChecked).toList();
    }
    return _items;
  }

  /// Bouton pour créer un nouvel article
  Future<void> addItemDialog() async {
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: "1");
    final priceController = TextEditingController(text: "0.0");
    String? localErrorMsg; // pour afficher une erreur dans le dialog

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (dialogCtx, setStateDialog) {
          // On utilise StatefulBuilder pour pouvoir setState dans le dialog
          return AlertDialog(
            backgroundColor: widget.cardColor,
            title: Text("Nouvel article", style: TextStyle(color: widget.grayColor)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  // Correction ici : on teste si la chaîne est non-nulle et non vide
                  if (localErrorMsg?.isNotEmpty ?? false)
                    Text(
                      localErrorMsg ?? '',
                      style: const TextStyle(color: AppColors.errorColor),
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nom de l'article",
                      labelStyle: TextStyle(color: widget.grayColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: qtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Quantité",
                            labelStyle: TextStyle(color: widget.grayColor),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedUnit.isEmpty ? null : _selectedUnit,
                        items: _units.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUnit = newValue ?? _units.first;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Prix (facultatif)",
                      labelStyle: TextStyle(color: widget.grayColor),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                style: TextButton.styleFrom(
                  foregroundColor: widget.grayColor,
                  backgroundColor: widget.cardColor,
                ),
                child: Text('Annuler', style: TextStyle(color: widget.grayColor)),
              ),
              TextButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  final qty = int.tryParse(qtyController.text) ?? 1;
                  final price = double.tryParse(priceController.text) ?? 0.0;

                  if (name.isEmpty) {
                    setStateDialog(() {
                      localErrorMsg = "Le nom de l'article ne peut pas être vide.";
                    });
                    return;
                  }

                  try {
                    await context
                        .read<GroceryListProvider>()
                        .createItem(widget.listId, name, qty, price, _selectedUnit);

                    Navigator.pop(dialogCtx);
                    await loadItemsAndBudget();
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString();
                    });
                    Navigator.pop(dialogCtx);
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: widget.grayColor,
                  backgroundColor: widget.cardColor,
                ),
                child: Text('Ajouter', style: TextStyle(color: widget.grayColor)),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> toggleChecked(GroceryItemModel item) async {
    await context
        .read<GroceryListProvider>()
        .updateItemChecked(item.id!, !item.isChecked);
    await loadItemsAndBudget();
  }

  Future<void> deleteItem(int itemId) async {
    await context.read<GroceryListProvider>().deleteItem(itemId);
    await loadItemsAndBudget();
  }

  Future<void> editItemDialog(GroceryItemModel item) async {
    final qtyController = TextEditingController(text: "${item.quantity}");
    final priceController = TextEditingController(text: "${item.price}");
    String? localErrorMsg;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (dialogCtx, setStateDialog) {
          return AlertDialog(
            backgroundColor: widget.cardColor,
            title: Text("Modifier l'article", style: TextStyle(color: widget.grayColor)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (localErrorMsg?.isNotEmpty ?? false)
                  Text(
                    localErrorMsg ?? '',
                    style: const TextStyle(color: AppColors.errorColor),
                  ),
                const SizedBox(height: 8),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Quantité",
                    labelStyle: TextStyle(color: widget.grayColor),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Prix",
                    labelStyle: TextStyle(color: widget.grayColor),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogCtx),
                style: TextButton.styleFrom(
                  foregroundColor: widget.grayColor,
                  backgroundColor: widget.cardColor,
                ),
                child: Text('Annuler', style: TextStyle(color: widget.grayColor)),
              ),
              TextButton(
                onPressed: () async {
                  final newQty = int.tryParse(qtyController.text) ?? item.quantity;
                  final newPrice = double.tryParse(priceController.text) ?? item.price;

                  try {
                    await context.read<GroceryListProvider>().updateItem(
                      item.id!,
                      quantity: newQty,
                      price: newPrice,
                    );
                    Navigator.pop(dialogCtx);
                    await loadItemsAndBudget();
                  } catch (e) {
                    setState(() {
                      _errorMessage = e.toString();
                    });
                    Navigator.pop(dialogCtx);
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: widget.grayColor,
                  backgroundColor: widget.cardColor,
                ),
                child: Text('Enregistrer', style: TextStyle(color: widget.grayColor)),
              ),
            ],
          );
        });
      },
    );
  }

  /// Supprime tous les articles de la liste
  void confirmDeleteAllItems() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            'Supprimer tous les articles ?',
            style: TextStyle(color: widget.grayColor),
          ),
          backgroundColor: widget.cardColor,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
              ),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // On supprime localement tous les articles
                final provider = context.read<GroceryListProvider>();
                try {
                  // Charger tous les items
                  final items = await provider.loadItemsForList(widget.listId);
                  // Supprimer un par un (ou on peut faire un .delete() global côté supabase)
                  for (var item in items) {
                    await provider.deleteItem(item.id!);
                  }
                  await loadItemsAndBudget();
                  Navigator.pop(ctx);
                } catch (e) {
                  Navigator.pop(ctx);
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: widget.grayColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Titre
            Text(
              widget.listName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: widget.brightCardColor,
              ),
            ),
            const SizedBox(height: 10),

            // Filtre
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Budget total
                Text(
                  "Budget total : ${_totalBudget.toStringAsFixed(2)} €",
                  style: TextStyle(
                    color: widget.brightCardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Afficher non achetés",
                      style: TextStyle(color: widget.brightCardColor),
                    ),
                    Switch(
                      value: _showOnlyUnchecked,
                      onChanged: (val) {
                        setState(() {
                          _showOnlyUnchecked = val;
                        });
                      },
                      activeColor: widget.cardColor,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 50,                // Hauteur fixe, adapter selon vos besoins
              width: double.infinity,    // Largeur max
              child: Stack(
                children: [
                  // Bouton "Ajouter" centré horizontalement et verticalement
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 30, // Hauteur du bouton, vous pouvez ajuster
                      child: ElevatedButton(
                        onPressed: addItemDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.cardColor,
                          foregroundColor: widget.grayColor,
                        ),
                        child: const Text("Ajouter"),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: widget.cardColor,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.delete_forever_outlined,
                            color: AppColors.errorColor,
                          ),
                          onPressed: () => confirmDeleteAllItems(),
                          splashRadius: 15,
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            // Message d'erreur global (s'il y en a un)
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: AppColors.errorColor),
              ),

            // Liste des articles
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        "Aucun article",
                        style: TextStyle(color: widget.brightCardColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, index) {
                        final item = items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: item.isChecked
                                ? AppColors.lightGray
                                : widget.cardColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              value: item.isChecked,
                              onChanged: (_) => toggleChecked(item),
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 16,
                                decoration: item.isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: widget.grayColor,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "Qté: ${item.quantity}",
                                  style: TextStyle(
                                    color: widget.grayColor,
                                  ),
                                ),
                                SizedBox(width: 10),
                                DropdownButton<String>(
                                  value: item.unit.isEmpty ? null : item.unit,
                                  hint: Text('Unité'),
                                  items: _units.map((String unit) {
                                    return DropdownMenuItem<String>(
                                      value: unit,
                                      child: Text(unit),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      item.unit = newValue ?? '';
                                    });
                                  },
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "| Prix: ${item.price.toStringAsFixed(2)} €",
                                  style: TextStyle(
                                    color: widget.grayColor,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: AppColors.blackColor,
                                  onPressed: () => editItemDialog(item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: AppColors.deletColor,
                                  onPressed: () => deleteItem(item.id!),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}