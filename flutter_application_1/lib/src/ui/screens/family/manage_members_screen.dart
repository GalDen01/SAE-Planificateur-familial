// lib/src/ui/screens/family/manage_members_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';

class ManageMembersScreen extends StatefulWidget {
  final int familyId;
  final String familyName;         // Pour l'afficher en haut
  final int membersCount;          // Pour l'afficher en haut
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const ManageMembersScreen({
    super.key,
    required this.familyId,
    required this.familyName,
    required this.membersCount,
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

  // On stocke la liste des membres existants (pour l'affichage).
  List<Map<String, dynamic>> members = [];

  @override
  void initState() {
    super.initState();
    loadFamilyMembers();
  }

  // Charger la liste des membres de la famille
  Future<void> loadFamilyMembers() async {
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('family_members')
        .select('user_id, users!inner(first_name, email, photo_url)')
        .eq('family_id', widget.familyId);

    if (response is List) {
      setState(() {
        // response[i] ex: {"user_id": 12, "users": {"first_name": "Jean", "email": "..."}}
        members = response.cast<Map<String, dynamic>>();
      });
    }
  }

  // Rechercher des utilisateurs par nom/email
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() => suggestions = []);
      return;
    }
    final supabase = Supabase.instance.client;
    final response = await supabase
        .from('users')
        .select('id, first_name, email, photo_url')
        .or('first_name.ilike.%$query%,email.ilike.%$query%')
        .limit(10);

    if (response is List) {
      setState(() {
        suggestions = response.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> addMember(int userId) async {
    final success = await context.read<FamilyProvider>().addMemberToFamilyByUserId(
      widget.familyId,
      userId,
    );
    if (!success) {
      // Membre déjà présent, ou erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre déjà présent ou erreur')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Membre ajouté avec succès')),
      );
      // Recharger la liste des membres
      await loadFamilyMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.grayColor,
      appBar: AppBar(
        backgroundColor: widget.grayColor,
        automaticallyImplyLeading: false, // on gère “Retour” manuellement si besoin
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // BOUTON RETOUR
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.brightCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              // Titre : Nom de la famille
              Text(
                widget.familyName,
                style: TextStyle(
                  fontSize: 24,
                  color: widget.brightCardColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // Nb de membres
              Text(
                "${widget.membersCount} Membres",
                style: TextStyle(
                  fontSize: 16,
                  color: widget.brightCardColor,
                ),
              ),
              const SizedBox(height: 20),


              Image.asset(
                "assets/images/family_tree.png",
                height: 120,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 30),

              // Barre de recherche
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: widget.cardColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      onChanged: (val) => searchUsers(val.trim()),
                      style: TextStyle(color: widget.grayColor),
                      decoration: InputDecoration(
                        labelText: 'Rechercher des utilisateurs',
                        labelStyle: TextStyle(color: widget.grayColor),
                        filled: true,
                        fillColor: widget.cardColor,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Liste de suggestions
                    Column(
                      children: suggestions.map((user) {
                        final userId = user['id'] as int;
                        final firstName = user['first_name'] ?? '';
                        final email = user['email'] ?? '';
                        final photoUrl = user['photo_url'] as String?; 
                        
                        return GestureDetector(
                          onTap: () => addMember(userId),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: widget.brightCardColor,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              children: [
                                // Photo
                                CircleAvatar(
                                  backgroundColor: widget.grayColor,
                                  backgroundImage: photoUrl != null 
                                    ? NetworkImage(photoUrl)
                                    : null,
                                ),
                                const SizedBox(width: 10),
                                // Texte
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
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Liste des membres déjà présents
              // ex: "Jean Depont", "jean.claude@gmail.com"
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final mem in members) ...{
                    // "mem" : { "user_id":..., "users": {"first_name":..., "email":..., "photo_url":...} }
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: widget.cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: widget.grayColor,
                            backgroundImage: mem['users']['photo_url'] != null
                              ? NetworkImage(mem['users']['photo_url'])
                              : null,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mem['users']['first_name'] ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: widget.grayColor,
                                ),
                              ),
                              Text(
                                mem['users']['email'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: widget.grayColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  }
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
