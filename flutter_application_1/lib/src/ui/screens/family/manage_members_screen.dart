import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';

class ManageMembersScreen extends StatefulWidget {
  final int familyId;
  final String familyName;
  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  const ManageMembersScreen({
    super.key,
    required this.familyId,
    required this.familyName,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> suggestions = [];
  List<Map<String, dynamic>> familyMembers = [];

  @override
  void initState() {
    super.initState();
    loadFamilyMembers();
  }

  Future<void> loadFamilyMembers() async {
    final supabase = Supabase.instance.client;
    try {
      final result = await supabase
          .from('family_members')
          .select('user_id, users!inner(first_name, email, photo_url)')
          .eq('family_id', widget.familyId);


      setState(() {
        familyMembers = result.cast<Map<String, dynamic>>();
      });

    } catch (e) {
      debugPrint("Erreur loadFamilyMembers: $e");
    }
  }

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


      setState(() {
        suggestions = response.cast<Map<String, dynamic>>();
      });

    } catch (e) {
      debugPrint("Erreur searchUsers: $e");
    }
  }

    Future<void> addMember(int userId) async {
    try {

      await context.read<FamilyProvider>().inviteMemberToFamily(widget.familyId, userId);


      await loadFamilyMembers();
      setState(() {
        isSearching = false;
        suggestions.clear();
        searchController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invitation envoyée avec succès!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final memberCount = familyMembers.length;

    return Scaffold(
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: widget.grayColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Titre
                  Text(
                    widget.familyName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 5),

                  Text(
                    "$memberCount Membres",
                    style: const TextStyle(
                      color: AppColors.brightCardColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Image
                  Image.asset(
                    'assets/images/family_tree.png',
                    height: 160,
                  ),
                  const SizedBox(height: 20),

                  // Liste des membres
                  ...familyMembers.map((fm) {
                    final userData = fm['users'] ?? {};
                    final firstName = userData['first_name'] ?? '';
                    final email = userData['email'] ?? '';
                    final photoUrl = userData['photo_url'];

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: widget.cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          if (photoUrl != null && photoUrl.isNotEmpty)
                            CircleAvatar(
                              backgroundColor: AppColors.whiteColor.withOpacity(0.7),
                              backgroundImage: NetworkImage(photoUrl),
                            )
                          else
                            CircleAvatar(
                              backgroundColor: AppColors.whiteColor.withOpacity(0.7),
                              child: const Icon(Icons.person),
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

                  ElevatedButton(
                    onPressed: () {
                      setState(() => isSearching = !isSearching);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brightCardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                    ),
                    child: Text(
                      isSearching
                          ? "Fermer la recherche"
                          : "Rechercher des utilisateurs",
                      style: TextStyle(
                        color: widget.grayColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  if (isSearching) ...[
                    const SizedBox(height: 20),
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
                                  final userPhoto = user['photo_url'] ?? '';

                                  return GestureDetector(
                                    onTap: () => addMember(uId),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 5),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: widget.cardColor,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      child: Row(
                                        children: [
                                          if (userPhoto.isNotEmpty)
                                            CircleAvatar(
                                              backgroundColor: AppColors.whiteColor
                                                  .withOpacity(0.7),
                                              backgroundImage: NetworkImage(userPhoto),
                                            )
                                          else
                                            CircleAvatar(
                                              backgroundColor: AppColors.whiteColor
                                                  .withOpacity(0.7),
                                              child: const Icon(Icons.person),
                                            ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                fName,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: widget.grayColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
