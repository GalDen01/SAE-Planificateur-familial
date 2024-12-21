import 'package:flutter/material.dart';

class FamilyButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;
  final Widget? targetPage; // Nouvelle page à naviguer

  const FamilyButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
    this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          elevation: 3,
        ),
        onPressed: () {
          if (targetPage != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetPage!),
            );
          } else if (onPressed != null) {
            onPressed!();
          }
        },
        child: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
