// lib/src/ui/screens/family/manage_members_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';

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
  // Recherche
  bool isSearching = false; // affichage zone de recherche
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> suggestions = [];

  // Liste des membres déjà dans la famille
  List<Map<String, dynamic>> familyMembers = [];

  @override
  void initState() {
    super.initState();
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    final supabase = Supabase.instance.client;
    try {
      // On joint `users` pour récupérer first_name et email
      final result = await supabase
          .from('family_members')
          .select('user_id, users!inner(first_name, email)')
          .eq('family_id', widget.familyId);

      if (result is List) {
        setState(() {
          familyMembers = result.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint("Erreur loadFamilyMembers: $e");
    }
  }

  /// Recherche d'utilisateurs par first_name ou email
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => suggestions = []);
      return;
    }
    final supabase = Supabase.instance.client;
    try {
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
    } catch (e) {
      debugPrint("Erreur searchUsers: $e");
    }
  }

  Future<void> addMember(int userId) async {
    try {
      await context
          .read<FamilyProvider>()
          .addMemberToFamilyByUserId(widget.familyId, userId);

      // Membre ajouté => recharger la liste
      await loadFamilyMembers();

      // On ferme la zone de recherche (optionnel)
      setState(() {
        isSearching = false;
        suggestions.clear();
        searchController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre ajouté avec succès!')),
      );
    } catch (e) {
      // Par ex. "Cet utilisateur fait déjà partie de cette famille."
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberCount = familyMembers.length;

    return Scaffold(
      backgroundColor: widget.grayColor,
      appBar: AppBar(
        backgroundColor: widget.grayColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Bouton Retour
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.brightCardColor,
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Retour",
                style: TextStyle(
                  color: widget.grayColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Titre de la famille
                  Text(
                    "Nom de la Famille",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.brightCardColor,
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Nombre de membres
                  Text(
                    "$memberCount Membres",
                    style: TextStyle(
                      color: widget.brightCardColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image (arbre, etc.)
                  Image.asset(
                    'assets/images/family_tree.png', // <-- c'est toi qui gères l'image
                    height: 120,
                  ),
                  const SizedBox(height: 20),

                  // Liste des membres déjà présents
                  ...familyMembers.map((fm) {
                    final firstName = fm['users']['first_name'] ?? '';
                    final email = fm['users']['email'] ?? '';
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: widget.cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white70,
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                firstName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.grayColor,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.grayColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 30),

                  // Bouton pour afficher/masquer la zone de recherche
                  ElevatedButton(
                    onPressed: () {
                      setState(() => isSearching = !isSearching);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.brightCardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                    ),
                    child: Text(
                      isSearching ? "Fermer la recherche" : "Rechercher des utilisateurs",
                      style: TextStyle(
                        color: widget.grayColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (isSearching) ...[
                    const SizedBox(height: 20),
                    // Champ de recherche
                    Container(
                      decoration: BoxDecoration(
                        color: widget.cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: searchController,
                            onChanged: (val) => searchUsers(val.trim()),
                            style: TextStyle(color: widget.grayColor),
                            decoration: InputDecoration(
                              hintText: 'Tapez un prénom ou un email...',
                              hintStyle: TextStyle(color: widget.grayColor),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              filled: true,
                              fillColor: widget.cardColor,
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Suggestions
                          if (suggestions.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: widget.cardColor,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                children: suggestions.map((user) {
                                  final uId = user['id'] as int;
                                  final fName = user['first_name'] ?? '';
                                  final mail = user['email'] ?? '';
                                  return GestureDetector(
                                    onTap: () => addMember(uId),
                                    child: Container(
                                      margin:
                                          const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5D5CD), // rose
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            backgroundColor: Colors.white70,
                                            child: Icon(Icons.person),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fName,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: widget.grayColor,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                mail,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: widget.grayColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
