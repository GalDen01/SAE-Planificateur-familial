import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:Planificateur_Familial/src/config/constants.dart';

class CguDialog extends StatelessWidget {
  const CguDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(
        loc.cguDialogTitle,
        style: const TextStyle(color: AppColors.grayColor),
      ),
      backgroundColor: AppColors.cardColor,
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: SingleChildScrollView(
          child: Text(
            loc.cguDialogContent,
            style: const TextStyle(
              color: AppColors.grayColor,
              fontSize: 14,
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.grayColor,
            backgroundColor: AppColors.cardColor,
          ),
          child: const Text("Fermer"),
        ),
      ],
    );
  }
}
