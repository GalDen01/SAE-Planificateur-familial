import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/todo_list_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/family_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/buttons/todo_list_add_button.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/screens/todo/todo_list_screen.dart';

class TodoListsScreen extends StatelessWidget {
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const TodoListsScreen({
    super.key,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<TodoListProvider>().lists;

    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: grayColor,
      body: SingleChildScrollView(
        // Idem, on place un Center
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              // Important pour centrer horizontalement
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Text(
                  "To-do listes de $familyName",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
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

                // Pour chaque liste
                ...lists.map((list) => Column(
                      children: [
                        FamilyButton(
                          label: list.name,
                          backgroundColor: cardColor,
                          textColor: grayColor,
                          targetPage: ToDoListScreen(
                            listName: list.name,
                            cardColor: cardColor,
                            grayColor: grayColor,
                            brightCardColor: brightCardColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    )),

                TodoListAddButton(
                  cardColor: cardColor,
                  grayColor: grayColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
