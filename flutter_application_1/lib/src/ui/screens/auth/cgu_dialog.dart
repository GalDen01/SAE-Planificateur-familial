import 'package:flutter/material.dart';
import 'package:Planificateur_Familial/src/config/constants.dart';

class CguDialog extends StatelessWidget {
  const CguDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Conditions Générales d'Utilisation",
        style: const TextStyle(color: AppColors.grayColor),
      ),
      backgroundColor: AppColors.cardColor,
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: SingleChildScrollView(
          child: Text(
            _cguText,
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


  static const String _cguText = """
Conditions Générales d'Utilisation de FamLink©

1. Objet
Les présentes Conditions Générales d'Utilisation (CGU) ont pour objet de définir les modalités et conditions dans lesquelles les utilisateurs peuvent accéder et utiliser l'application FamLink© (ci-après "l'Application").

2. Mentions légales
Éditeur de l'Application : Clean Code Crew™, groupe académique, au capital de 0.08 €, dont le siège social est situé Campus Maurois, 12 All. André Maurois, 87065 Limoges.
Directeur de la publication : Gaëtan Charpentier.
Hébergeur : Supabase, https://supabase.com/.
Actionnaire majoritaires : Trillard Stanislas 33%
                           Clean Code Crew™ 67%

3. Acceptation des CGU
L'utilisation de l'Application implique l'acceptation pleine et entière des présentes CGU. En cas de désaccord avec ces conditions, l'utilisateur est prié de ne pas utiliser l'Application.

4. Accès à l'Application
L'Application est accessible gratuitement aux utilisateurs disposant d'un accès à internet. Tous les coûts relatifs à l'accès au service, que ce soient les frais matériels, logiciels ou d'accès à internet, sont exclusivement à la charge de l'utilisateur.

5. Services proposés  
L'Application offre des outils de planification familiale, tels que la gestion de calendriers, la création de listes de tâches, le partage d'événements et la communication entre membres de la famille.

6. Responsabilités
Responsabilité de l'éditeur : L'éditeur s'engage à mettre en œuvre des moyens pour assurer le bon fonctionnement de l'Application. Toutefois, il ne saurait être tenu responsable des interruptions, pannes, modifications ou dysfonctionnements de l'Application, quels qu'en soient la cause.
Responsabilité de l'utilisateur : L'utilisateur s'engage à utiliser l'Application conformément à sa destination et à ne pas tenter de porter atteinte à son bon fonctionnement. Il est responsable de la confidentialité de ses identifiants de connexion et de l'utilisation qui en est faite.

7. Propriété intellectuelle
Tous les éléments de l'Application, y compris les textes, graphismes, sons, logiciels, sont la propriété exclusive de l'éditeur, sauf mention contraire. Toute reproduction, représentation, modification, publication, adaptation de tout ou partie des éléments de l'Application, quel que soit le moyen ou le procédé utilisé, est interdite, sauf autorisation écrite préalable de l'éditeur.

8. Données personnelles
L'Application peut collecter des données personnelles concernant les utilisateurs. Ces données sont nécessaires au bon fonctionnement des services proposés. L'utilisateur dispose d'un droit d'accès, de rectification et de suppression des données le concernant, conformément à la réglementation en vigueur. Pour exercer ces droits, l'utilisateur peut contacter l'éditeur à l'adresse suivante : famlink.assist@gmail.com.

9. Liens hypertextes
L'Application peut contenir des liens hypertextes vers d'autres sites. L'éditeur n'exerce aucun contrôle sur ces sites et décline toute responsabilité quant à leur contenu ou aux services qu'ils proposent.

10. Modification des CGU
L'éditeur se réserve le droit de modifier à tout moment les présentes CGU. Les modifications entrent en vigueur dès leur mise en ligne. Il est donc recommandé aux utilisateurs de consulter régulièrement les CGU afin de prendre connaissance de leurs éventuelles modifications.

11. Droit applicable et juridiction compétente
Les présentes CGU sont soumises au droit français. En cas de litige relatif à l'interprétation ou à l'exécution des présentes CGU, les parties s'engagent à rechercher une solution amiable. À défaut, le litige sera porté devant les tribunaux compétents de Limoges.

12. Contact
Pour toute question relative aux présentes CGU ou à l'utilisation de l'Application, l'utilisateur peut contacter l'éditeur à l'adresse suivante : famlink.assist@gmail.com.

En utilisant l'Application, l'utilisateur reconnaît avoir pris connaissance des présentes CGU et les accepter.
""";
}
