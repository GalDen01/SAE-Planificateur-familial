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

  // Rechercher dans la table 'users' par first_name ou email
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => suggestions = []);
      return;
    }
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('users')
        .select('*')
        .or('first_name.ilike.%$query%,email.ilike.%$query%')
        .limit(10);

    if (response is List) {
      setState(() {
        suggestions = response.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> addMember(int userId) async {
    await context.read<FamilyProvider>().addMemberToFamilyByUserId(widget.familyId, userId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Membre ajouté')),
    );
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
            // Champ de recherche
            TextField(
              controller: searchController,
              onChanged: (val) => searchUsers(val.trim()),
              decoration: const InputDecoration(
                labelText: "Rechercher un utilisateur",
                hintText: "Prénom ou Email",
              ),
            ),
            const SizedBox(height: 16),

            // Liste des suggestions
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final user = suggestions[index];
                  final userId = user['id'] as int;
                  final userEmail = user['email'] as String;
                  final firstName = (user['first_name'] as String?) ?? '';
                  return ListTile(
                    title: Text('$firstName ($userEmail)'),
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
