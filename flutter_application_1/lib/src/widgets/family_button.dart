import 'package:flutter/material.dart';

class FamilyButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;
  final bool fullWidth;

  const FamilyButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: textColor, 
          fontSize: 16, 
          fontWeight: FontWeight.bold
        ),
      ),
    );

    if (fullWidth) {
      return SizedBox(width: double.infinity, child: button);
    } else {
      return button;
    }
  }
}
