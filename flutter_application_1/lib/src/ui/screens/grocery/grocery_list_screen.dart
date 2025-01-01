// lib/src/ui/screens/grocery/grocery_list_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/models/grocery_item.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';

class GroceryListScreen extends StatefulWidget {
  final int listId; // l'id de la liste en BDD
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
  final GroceryListProvider _provider = 
      // on pourra l'obtenir dans initState
      // (on le fera dans didChangeDependencies ou initState)
      GroceryListProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // On le récupère via context
    final p = context.read<GroceryListProvider>();
    if (p != _provider) {
      // ce test est un peu superflu, on peut juste le faire sans test :
      loadItemsAndBudget();
    }
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

  Future<void> addItemDialog() async {
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: "1");
    final priceController = TextEditingController(text: "0.0");

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: widget.cardColor,
          title: Text("Nouvel article", style: TextStyle(color: widget.grayColor)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Nom de l'article",
                    labelStyle: TextStyle(color: widget.grayColor),
                  ),
                ),
                const SizedBox(height: 10),
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
                    labelText: "Prix (facultatif)",
                    labelStyle: TextStyle(color: widget.grayColor),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
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
                if (name.isNotEmpty) {
                  await context
                      .read<GroceryListProvider>()
                      .createItem(widget.listId, name, qty, price);
                  Navigator.pop(ctx);
                  await loadItemsAndBudget();
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
    // Pour mettre à jour quantity/price
    final qtyController = TextEditingController(text: "${item.quantity}");
    final priceController = TextEditingController(text: "${item.price}");

    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: widget.cardColor,
          title: Text("Modifier l'article", style: TextStyle(color: widget.grayColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              onPressed: () => Navigator.pop(ctx),
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
                await context.read<GroceryListProvider>().updateItem(
                  item.id!,
                  quantity: newQty,
                  price: newPrice,
                );
                Navigator.pop(ctx);
                await loadItemsAndBudget();
              },
              style: TextButton.styleFrom(
                foregroundColor: widget.grayColor,
                backgroundColor: widget.cardColor,
              ),
              child: Text('Enregistrer', style: TextStyle(color: widget.grayColor)),
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

            // Bouton pour ajouter un article
            ElevatedButton(
              onPressed: addItemDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.cardColor,
                foregroundColor: widget.grayColor,
              ),
              child: const Text("Ajouter un article"),
            ),
            const SizedBox(height: 10),

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
                            color:
                                item.isChecked ? AppColors.lightGray : widget.cardColor,
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
                            subtitle: Text(
                              "Qté: ${item.quantity} | Prix: ${item.price.toStringAsFixed(2)} €",
                              style: TextStyle(
                                color: widget.grayColor,
                              ),
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
