// lib/src/ui/screens/family/invitations_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';
import 'package:Planificateur_Familial/src/providers/family_provider.dart';
import 'package:Planificateur_Familial/src/ui/widgets/back_profile_bar.dart';

class InvitationsScreen extends StatefulWidget {
  final int userId;

  const InvitationsScreen({super.key, required this.userId});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  List<Map<String, dynamic>> _invitations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadInvitations();
  }

  Future<void> loadInvitations() async {
    final provider = context.read<FamilyProvider>();
    final data = await provider.getInvitationsForUser(widget.userId);
    setState(() {
      _invitations = data;
      _loading = false;
    });
  }

  Future<void> acceptInvitation(int invitationId) async {
    try {
      await context.read<FamilyProvider>().acceptFamilyInvitation(invitationId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invitation acceptée !')),
      );
      // Recharger la liste pour que l'invitation disparaisse
      await loadInvitations();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // On utilise notre BackProfileBar en guise d'AppBar
      appBar: BackProfileBar(
        onBack: () => Navigator.pop(context),
      ),
      backgroundColor: AppColors.grayColor,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _invitations.isEmpty
              ? const Center(
                  child: Text(
                    "Aucune invitation en attente",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                )
              : ListView.builder(
                  itemCount: _invitations.length,
                  itemBuilder: (ctx, index) {
                    final inv = _invitations[index];
                    final invitationId = inv['id'] as int;
                    final familyName = inv['families']['name'] as String;

                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Famille : $familyName",
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => acceptInvitation(invitationId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brightCardColor,
                              foregroundColor: AppColors.grayColor,
                            ),
                            child: const Text("Accepter"),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
