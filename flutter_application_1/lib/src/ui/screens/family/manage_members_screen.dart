import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
// et un éventuel 'users_provider' si tu gères la liste des utilisateurs ?

class ManageMembersScreen extends StatefulWidget {
  final int familyId;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const ManageMembersScreen({
    super.key,
    required this.familyId,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  // liste des membres actuels ?
  List<String> familyMembers = []; // emails
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Charger la liste des membres pour `widget.familyId`
    // ex: context.read<FamilyProvider>().loadMembersOfFamily(widget.familyId)...
  }

  void addMember(String userEmail) async {
    // Appelle une méthode dans FamilyProvider pour insérer (family_id, userEmail) dans family_members
    await context.read<FamilyProvider>().addMemberToFamily(widget.familyId, userEmail);
    // puis recharge la liste
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.grayColor,
      appBar: AppBar(
        backgroundColor: widget.grayColor,
        title: Text(
          "Gérer les membres",
          style: TextStyle(color: widget.brightCardColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Liste des membres existants...
            // TextField pour "rechercher" par email/nom...
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Rechercher un utilisateur",
              ),
              onSubmitted: (value) {
                // Optionnel: effectuer un "search" sur un provider de "users"
              },
            ),

            ElevatedButton(
              onPressed: () {
                final emailToAdd = searchController.text.trim();
                if (emailToAdd.isNotEmpty) {
                  addMember(emailToAdd);
                  searchController.clear();
                }
              },
              child: const Text("Ajouter à la famille"),
            ),

            // ...
          ],
        ),
      ),
    );
  }
}
