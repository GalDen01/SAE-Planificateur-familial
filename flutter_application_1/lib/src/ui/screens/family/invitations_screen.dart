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
      await loadInvitations(); // recharger
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> declineInvitation(int invitationId) async {
    try {
      await context.read<FamilyProvider>().declineFamilyInvitation(invitationId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invitation refusée.')),
      );
      await loadInvitations(); // recharger
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _invitations.length,
                  itemBuilder: (ctx, index) {
                    final inv = _invitations[index];
                    final invitationId = inv['id'] as int;
                    final familyName = inv['families']['name'] as String;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppColors.cardColor,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Invitation à rejoindre la famille :",
                            style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            familyName,
                            style: const TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Bouton Refuser
                              ElevatedButton(
                                onPressed: () => declineInvitation(invitationId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.deletColor,
                                  foregroundColor: AppColors.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 12.0,
                                  ),
                                ),
                                child: const Text("Refuser"),
                              ),
                              const SizedBox(width: 10),
                              // Bouton Accepter
                              ElevatedButton(
                                onPressed: () => acceptInvitation(invitationId),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.acceptColor,
                                  foregroundColor: AppColors.whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                    vertical: 12.0,
                                  ),
                                ),
                                child: const Text("Accepter"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
