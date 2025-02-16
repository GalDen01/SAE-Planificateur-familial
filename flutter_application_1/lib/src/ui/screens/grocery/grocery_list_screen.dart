import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/models/grocery_item.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Planificateur_Familial/src/providers/ocr_provider.dart';

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
  bool _showOnlyUnchecked = false;
  double _totalBudget = 0.0;
  String _errorMessage = '';

  bool _isPromo = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadItemsAndBudget();
    });
  }

  Future<void> _loadItemsAndBudget() async {
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

  // ======================== CREATION D’UN ARTICLE ========================
  Future<void> _addItemDialog() async {
    final nameController = TextEditingController();
    final qtyController = TextEditingController(text: "1");
    final priceController = TextEditingController(text: "0.0");
    _isPromo = false;
    String? localErrorMsg;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (dialogCtx, setStateDialog) {
          return AlertDialog(
            backgroundColor: widget.cardColor,
            title: Text(
              "Nouvel article",
              style: TextStyle(color: widget.grayColor),
            ),
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
                      labelText: "Prix (facultatif)",
                      labelStyle: TextStyle(color: widget.grayColor),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Promotion
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
                    await context.read<GroceryListProvider>().createItem(
                          widget.listId,
                          name,
                          qty,
                          price,
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

  // ======================== ACTIONS SUR UN ARTICLE ========================
  Future<void> _toggleChecked(GroceryItemModel item) async {
    await context.read<GroceryListProvider>().updateItemChecked(item.id!, !item.isChecked);
    await _loadItemsAndBudget();
  }

  Future<void> _deleteItem(int itemId) async {
    await context.read<GroceryListProvider>().deleteItem(itemId);
    await _loadItemsAndBudget();
  }

  // ======================== EDITION D’UN ARTICLE ========================
  Future<void> _editItemDialog(GroceryItemModel item) async {
    final qtyController = TextEditingController(text: "${item.quantity}");
    final priceController = TextEditingController(text: "${item.price}");
    bool isPromoEdit = item.isPromo;

    await showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (dialogCtx, setStateDialog) {
          return AlertDialog(
            backgroundColor: widget.cardColor,
            title: Text(
              "Modifier l'article",
              style: TextStyle(color: widget.grayColor),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
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

                  // Promotion ?
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

  // ======================== SUPPRIMER TOUS LES ARTICLES ========================
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
        //on ignore
      }
    }
  }

  // ======================== PRENDRE UNE PHOTO ET SCANNER LE PRIX ========================

  
  Future<void> _scanPriceFromCamera() async {
    try {
      //on ouvre la caméra
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        //l’utilisateur a annulé la prise de photo
        return;
      }

      final file = File(pickedFile.path);

      final ocrProvider = context.read<OcrProvider>();
      final recognizedText = await ocrProvider.recognizeTextFromImage(file);

      //on cherche le prix dans le text par exemple, on cherche un motif comme "xx.xx" ou "xx,xx".
      final regExpPrice = RegExp(r'(\d+[\.,]\d{1,2})');
      final matches = regExpPrice.allMatches(recognizedText);

      String resultMessage;
      if (matches.isNotEmpty) {
        // on prend le premire qu'on trouve
        final firstMatch = matches.first.group(0);
        resultMessage = "Prix détecté : $firstMatch\n\nTexte brut :\n$recognizedText";
      } else {
        resultMessage = "Aucun prix détecté.\n\nTexte brut :\n$recognizedText";
      }

      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: widget.cardColor,
            content: SingleChildScrollView(
              child: Text(
                resultMessage,
                style: TextStyle(
                  color: widget.grayColor,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      //on affiche un message d’erreur
      if (!mounted) return;
      await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: widget.cardColor,
            title: Text(
              'Erreur OCR',
              style: TextStyle(color: widget.grayColor),
            ),
            content: Text(
              e.toString(),
              style: TextStyle(color: widget.grayColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // ======================== BUILD ========================
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

            // Filtre
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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

            // Boutons “Ajouter” et “Supprimer tous”
            SizedBox(
              height: 50,
              width: double.infinity,
              child: Stack(
                children: [
                  // Bouton “Ajouter”
                  Align(
                    alignment: Alignment.centerLeft,
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

                  // Bouton "Prendre une photo et scanner le prix"
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 30,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.photo_camera),
                        onPressed: _scanPriceFromCamera,
                        label: const Text("Scanner un prix"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: widget.cardColor,
                          foregroundColor: widget.grayColor,
                        ),
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

            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: AppColors.errorColor),
              ),

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
                                  style: TextStyle(color: widget.grayColor),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "| Prix: ${item.price.toStringAsFixed(2)} €",
                                  style: TextStyle(color: widget.grayColor),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: AppColors.blackColor,
                                  onPressed: () => _editItemDialog(item),
                                ),
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
