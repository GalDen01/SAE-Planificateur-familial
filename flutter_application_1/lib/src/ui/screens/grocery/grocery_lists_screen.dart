import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/models/grocery_list.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/screens/grocery/grocery_list_screen.dart';
import 'package:Planificateur_Familial/src/ui/widgets/validated_text_field.dart'; // ✅ Import du widget

class GroceryListsScreen extends StatefulWidget {
  final int familyId;
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const GroceryListsScreen({
    super.key,
    required this.familyId,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  State<GroceryListsScreen> createState() => _GroceryListsScreenState();
}

class _GroceryListsScreenState extends State<GroceryListsScreen> {
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    context.read<GroceryListProvider>().loadListsForFamily(widget.familyId);
  }

  Future<void> _createGroceryListDialog() async {
    final controller = TextEditingController();
    final validatedFieldKey = GlobalKey<ValidatedTextFieldState>();

    final res = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: widget.cardColor,
          title: Text('Créer une liste', style: TextStyle(color: widget.grayColor)),
          content: ValidatedTextField(
            key: validatedFieldKey,
            controller: controller,
            hintText: 'Nom de la liste',
            hintTextColor: widget.grayColor,
            textColor: widget.grayColor,
            validator: (value) {
              if (value.trim().isEmpty) {
                return "Veuillez entrer un nom de liste.";
              }
              return null;
            },
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
              onPressed: () {
                validatedFieldKey.currentState!.validate();
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(ctx, name);
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
  if (res == null || res.isEmpty) {
    return;
  }

  try {
    await context.read<GroceryListProvider>().createList(widget.familyId, res);
    setState(() {});
  } catch (e) {
    setState(() {
      _errorMessage = e.toString();
    });
  }
}

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroceryListProvider>();
    final lists = provider.lists;

    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: widget.grayColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Listes de courses de ${widget.familyName}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 40.0,
                  backgroundColor: widget.cardColor,
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Image.asset(
                      'assets/images/panier.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _createGroceryListDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.cardColor,
                    foregroundColor: widget.grayColor,
                  ),
                  child: const Text("Créer une liste"),
                ),
                const SizedBox(height: 10),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: AppColors.errorColor),
                  ),
                const SizedBox(height: 20),
                ...lists.map((GroceryListModel glist) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: widget.cardColor,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        glist.name,
                        style: TextStyle(
                          color: widget.grayColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GroceryListScreen(
                              listId: glist.id!,
                              listName: glist.name,
                              cardColor: widget.cardColor,
                              grayColor: widget.grayColor,
                              brightCardColor: widget.brightCardColor,
                            ),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: AppColors.deletColor,
                        onPressed: () async {
                          await provider.deleteList(glist.id!);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
