import 'package:flutter/material.dart';

class HeaderMenu extends StatelessWidget {
  final String title;
  final Color textColor;
  final double fontSize;

  const HeaderMenu({
    super.key, 
    required this.title, 
    required this.textColor,
    this.fontSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
