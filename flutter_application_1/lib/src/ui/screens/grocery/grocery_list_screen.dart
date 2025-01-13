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
  bool _showOnlyUnchecked = false; // Filtre “non achetés”
  double _totalBudget = 0.0;
  String _errorMessage = '';       

  final List<String> _units = ['pcs', 'kg', 'g', 'l', 'mg', 'cl', 'ml'];
  String _selectedUnit = 'pcs'; // Par défaut lors d'un nouvel article
  bool _isPromo = false;     // Par défaut lors d'un nouvel article

  @override
  void initState() {
    super.initState();
    _selectedUnit = _units.first;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItemsAndBudget();
    });
  }

  /// Chargement principal
  Future<void> _loadItemsAndBudget() async {
    final provider = context.read<GroceryListProvider>();
    final items = await provider.loadItemsForList(widget.listId);
    final total = await provider.getTotalBudget(widget.listId);
    setState(() {
      _items = items;
      _totalBudget = total;
    });
  }

  /// Filtrage “non achetés”
  List<GroceryItemModel> get filteredItems {
    if (_showOnlyUnchecked) {
      return _items.where((i) => !i.isChecked).toList();
    }
    return _items;
  }

  // -----------------------------------------------------------------------
  // DIALOG: Création d'un nouvel article
  Future<void> _addItemDialog() async {
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: "1");
    final priceController = TextEditingController(text: "0.0");
    _isPromo = false; // reset
    String? localErrorMsg;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (dialogCtx, setStateDialog) {
          return AlertDialog(
            backgroundColor: widget.cardColor,
            title: Text("Nouvel article", style: TextStyle(color: widget.grayColor)),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  if (localErrorMsg?.isNotEmpty ?? false)
                    Text(
                      localErrorMsg!,
                      style: const TextStyle(color: AppColors.errorColor),
                    ),
                  const SizedBox(height: 8),

                  // Nom
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nom de l'article",
                      labelStyle: TextStyle(color: widget.grayColor),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Quantité + Unité
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
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedUnit.isEmpty ? null : _selectedUnit,
                        items: _units.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setStateDialog(() {
                            _selectedUnit = newValue ?? _units.first;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Prix
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Prix (facultatif)",
                      labelStyle: TextStyle(color: widget.grayColor),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Promotion ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "En promo ?",
                        style: TextStyle(color: widget.grayColor),
                      ),
                      Switch(
                        value: _isPromo,
                        onChanged: (val) {
                          setStateDialog(() {
                            _isPromo = val;
                          });
                        },
                        activeColor: AppColors.errorColor,
                      ),
                    ],
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
                    // On passe isPromo
                    await context.read<GroceryListProvider>().createItem(
                      widget.listId,
                      name,
                      qty,
                      price,
                      _selectedUnit,
                      isPromo: _isPromo,
                    );
                    Navigator.pop(dialogCtx);
                    await _loadItemsAndBudget();
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

  // -----------------------------------------------------------------------
  // ACTIONS sur un article
  Future<void> _toggleChecked(GroceryItemModel item) async {
    await context.read<GroceryListProvider>().updateItemChecked(item.id!, !item.isChecked);
    await _loadItemsAndBudget();
  }

  Future<void> _deleteItem(int itemId) async {
    await context.read<GroceryListProvider>().deleteItem(itemId);
    await _loadItemsAndBudget();
  }

  // DIALOG: Edition d’un article
  Future<void> _editItemDialog(GroceryItemModel item) async {
    final qtyController = TextEditingController(text: "${item.quantity}");
    final priceController = TextEditingController(text: "${item.price}");
    String selectedUnitEdit = item.unit;
    bool isPromoEdit = item.isPromo;
    String? localErrorMsg;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (dialogCtx, setStateDialog) {
          return AlertDialog(
            backgroundColor: widget.cardColor,
            title: Text("Modifier l'article", style: TextStyle(color: widget.grayColor)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (localErrorMsg?.isNotEmpty ?? false)
                    Text(
                      localErrorMsg!,
                      style: const TextStyle(color: AppColors.errorColor),
                    ),
                  const SizedBox(height: 8),

                  // Quantité
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Quantité",
                      labelStyle: TextStyle(color: widget.grayColor),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Prix
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Prix",
                      labelStyle: TextStyle(color: widget.grayColor),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Unité
                  DropdownButton<String>(
                    value: selectedUnitEdit.isEmpty ? _units.first : selectedUnitEdit,
                    items: _units.map((String unit) {
                      return DropdownMenuItem<String>(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setStateDialog(() {
                        selectedUnitEdit = newValue ?? _units.first;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Promo ?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "En promo ?",
                        style: TextStyle(color: widget.grayColor),
                      ),
                      Switch(
                        value: isPromoEdit,
                        onChanged: (val) {
                          setStateDialog(() {
                            isPromoEdit = val;
                          });
                        },
                        activeColor: AppColors.errorColor,
                      ),
                    ],
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
                  final newQty = int.tryParse(qtyController.text) ?? item.quantity;
                  final newPrice = double.tryParse(priceController.text) ?? item.price;

                  try {
                    await context.read<GroceryListProvider>().updateItem(
                      item.id!,
                      quantity: newQty,
                      price: newPrice,
                      unit: selectedUnitEdit,
                      isPromo: isPromoEdit,
                    );
                    Navigator.pop(dialogCtx);
                    await _loadItemsAndBudget();
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

  /// Confirme suppression de tous les articles
  Future<void> _confirmDeleteAllItems() async {
    final confirm = await showDialog<bool>(
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
              onPressed: () => Navigator.pop(ctx, false),
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
              ),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
              ),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      final provider = context.read<GroceryListProvider>();
      try {
        final items = await provider.loadItemsForList(widget.listId);
        for (var it in items) {
          await provider.deleteItem(it.id!);
        }
        await _loadItemsAndBudget();
      } catch (e) {
        // On ignore ou on log
      }
    }
  }

  // -----------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final items = filteredItems;

    return Scaffold(
      appBar: BackProfileBar(onBack: () => Navigator.pop(context)),
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

            // Filtre “non achetés”
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

            // Bouton Ajouter + Bouton “Supprimer tous”
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Stack(
                children: [
                  // Bouton “Ajouter”
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        onPressed: _addItemDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.cardColor,
                          foregroundColor: widget.grayColor,
                        ),
                        child: const Text("Ajouter"),
                      ),
                    ),
                  ),
                  // Bouton “Supprimer tous”
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
                          onPressed: _confirmDeleteAllItems,
                          splashRadius: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Erreur globale
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
                              onChanged: (_) => _toggleChecked(item),
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    decoration: item.isChecked
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: widget.grayColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Affiche un petit label si en promo
                                if (item.isPromo)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6.0,
                                      vertical: 2.0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.deletColor,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: const Text(
                                      "PROMO",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  "Quantité: ${item.quantity}",
                                  style: TextStyle(
                                    color: widget.grayColor,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                if (item.unit.isNotEmpty)
                                  Text(
                                    "(${item.unit})",
                                    style: TextStyle(
                                      color: widget.grayColor,
                                    ),
                                  ),
                                const SizedBox(width: 10),
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
                                // Edit
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: AppColors.blackColor,
                                  onPressed: () => _editItemDialog(item),
                                ),
                                // Delete
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: AppColors.deletColor,
                                  onPressed: () => _deleteItem(item.id!),
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
