import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/providers/auth_provider.dart';
import 'package:Planificateur_Familial/src/providers/user_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.cardColor,
    required this.grayColor,
    required this.brightCardColor,
  });

  final Color cardColor;
  final Color grayColor;
  final Color brightCardColor;

  Future<void> _showUserDataDialog(BuildContext context, int userId) async {
    try {
      final userProvider = context.read<UserProvider>();
      //recup toutes les infos sur l’utilisateur
      final data = await userProvider.fetchAllUserData(userId);

      //Convertit le résultat en texte lisible
      final dataString = _formatDataAsString(data);

      await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            backgroundColor: cardColor,
            title: Text(
              'Vos données',
              style: TextStyle(color: grayColor),
            ),
            content: SingleChildScrollView(
              child: Text(
                dataString,
                style: TextStyle(color: grayColor),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fermer"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Erreur lors de la récupération des données : $e"),
        ),
      );
    }
  }

  //convertit le résultat JSON en texte lisible.
  String _formatDataAsString(Map<String, dynamic> data) {
    final buffer = StringBuffer();

    // données de la table `users`
    final user = data['user'] ?? {};
    buffer.writeln("Table `users` :");
    buffer.writeln("id: ${user['id']}");
    buffer.writeln("email: ${user['email']}");
    buffer.writeln("first_name: ${user['first_name']}");
    buffer.writeln("photo_url: ${user['photo_url']}\n");

    //données de la table `family_members`
    final familyMembers = data['family_members'] as List<dynamic>? ?? [];
    buffer.writeln("Table `family_members` (user_id) :");
    for (var fm in familyMembers) {
      buffer.writeln(" - id: ${fm['id']}, family_id: ${fm['family_id']}");
    }
    buffer.writeln("");

    //données de la table `family_invitations`
    final invitations = data['family_invitations'] as List<dynamic>? ?? [];
    buffer.writeln("Table `family_invitations` (invited_user_id) :");
    for (var inv in invitations) {
      buffer.writeln(
          " - id: ${inv['id']}, family_id: ${inv['family_id']}, status: ${inv['status']}");
    }
    buffer.writeln("");

    return buffer.toString();
  }

  Future<void> _confirmAndDeleteUserData(
      BuildContext context, int userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: cardColor,
          title: Text(
            "Supprimer mes données ?",
            style: TextStyle(color: grayColor),
          ),
          content: Text(
            "Cette action est définitive et supprimera toutes vos informations de nos serveurs. Êtes-vous certain(e) ?",
            style: TextStyle(color: grayColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await context.read<UserProvider>().deleteAllUserData(userId);
        await context.read<AuthProvider>().signOut();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erreur lors de la suppression : $e"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.grayColor,
      appBar: AppBar(
        backgroundColor: grayColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Bouton Retour
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brightCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.blackColor,
              ),
            ),
            const Spacer(),
            // Bouton Déconnexion
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brightCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onPressed: () async {
                await authProvider.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                }
              },
              child: Text(
                "Déconnexion",
                style: TextStyle(
                  color: grayColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: user == null
              ? const Center(
                  child: Text(
                    "Aucun utilisateur connecté",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                )
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Profil utilisateur",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteColor,
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      child: ClipOval(
                        child: user.photoUrl != null &&
                                user.photoUrl!.isNotEmpty
                            ? Image.network(
                                user.photoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, error, stack) {
                                  return Container(
                                    color:
                                        AppColors.whiteColor,
                                    child: const Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 64,
                                        color: Colors.black,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color:
                                    AppColors.whiteColor,
                                child: const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 64,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Carte "Votre Prénom"
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          "Votre Prénom : ${user.displayName ?? 'Inconnu'}",
                          style: TextStyle(
                            color: grayColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    // Carte "Votre email"
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      margin: const EdgeInsets.only(bottom: 10.0),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          "Votre email : ${user.email}",
                          style: TextStyle(
                            color: grayColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    // Bouton "Voir mes données" en Container
                    GestureDetector(
                      onTap: () async {
                        final supabase = Supabase.instance.client;
                        final res = await supabase
                            .from('users')
                            .select('id')
                            .eq('email', user.email)
                            .maybeSingle();
                        if (res != null && res['id'] != null) {
                          final userId = res['id'] as int;
                          _showUserDataDialog(context, userId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Impossible de trouver votre ID dans la BDD.")),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        margin: const EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Voir mes données",
                            style: TextStyle(
                              color: grayColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bouton "Supprimer mes données"
                    GestureDetector(
                      onTap: () async {
                        final supabase = Supabase.instance.client;
                        final res = await supabase
                            .from('users')
                            .select('id')
                            .eq('email', user.email)
                            .maybeSingle();
                        if (res != null && res['id'] != null) {
                          final userId = res['id'] as int;
                          await _confirmAndDeleteUserData(context, userId);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Impossible de trouver votre ID dans la BDD.")),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: AppColors.deletColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: const Text(
                            "Supprimer mes données",
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
