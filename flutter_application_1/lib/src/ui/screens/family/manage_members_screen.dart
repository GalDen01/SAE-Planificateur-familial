// lib/src/ui/screens/family/manage_members_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> suggestions = [];

  @override
  void initState() {
    super.initState();
    // TODO: Charger la liste de membres existants de la famille, si tu veux
  }

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => suggestions = []);
      return;
    }
    final supabase = Supabase.instance.client;
    final res = await supabase
      .from('users')
      .select('*')
      .or('first_name.ilike.%$query%,email.ilike.%$query%')
      .limit(10);

    if (res is List) {
      setState(() {
        suggestions = res.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> addMember(int userId) async {
    // On ajoute userId à la famille
    await context.read<FamilyProvider>().addMemberToFamilyByUserId(widget.familyId, userId);
    // Optionnel : show a snackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Membre ajouté')),
    );
    // On peut aussi rafraîchir la liste des membres
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
            // Input de recherche
            TextField(
              controller: searchController,
              onChanged: (value) {
                searchUsers(value.trim());
              },
              decoration: const InputDecoration(
                labelText: "Rechercher un utilisateur",
                hintText: "Saisir le prénom ou l'email",
              ),
            ),
            const SizedBox(height: 16),

            // Affichage des suggestions
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final user = suggestions[index];
                  final userId = user['id'] as int;
                  final userEmail = user['email'] as String;
                  final firstName = user['first_name'] as String? ?? '';
                  return ListTile(
                    title: Text("$firstName ($userEmail)"),
                    onTap: () {
                      addMember(userId);
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
