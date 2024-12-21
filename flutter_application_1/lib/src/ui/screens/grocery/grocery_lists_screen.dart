import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/grocery_list_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/list_add_button.dart';
import 'package:Planificateur_Familial/src/ui/screens/profile/profile_screen.dart';
import 'package:Planificateur_Familial/src/ui/screens/grocery/grocery_list_screen.dart';

class GroceryListsScreen extends StatelessWidget {
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const GroceryListsScreen({
    super.key,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<ListProvider>().lists;

    return Scaffold(
      backgroundColor: grayColor,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Retour",
                          style: TextStyle(
                            color: grayColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  Text(
                    "Listes de courses de $familyName",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: cardColor,
                    ),
                  ),
                  const SizedBox(height: 20),

                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: cardColor,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/famille.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  ...lists.map((list) => Column(
                        children: [
                          FamilyButton(
                            label: list.name,
                            backgroundColor: cardColor,
                            textColor: grayColor,
                            targetPage: GroceryListScreen(
                              listName: list.name,
                              cardColor: cardColor,
                              grayColor: grayColor,
                              brightCardColor: brightCardColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      )),

                  ListAddButton(
                    cardColor: cardColor,
                    grayColor: grayColor,
                  ),
                ],
              ),
            ),

            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: FloatingActionButton(
                  backgroundColor: cardColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          cardColor: cardColor,
                          grayColor: grayColor,
                          brightCardColor: brightCardColor,
                        ),
                      ),
                    );
                  },
                  child: const Icon(Icons.account_circle, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
