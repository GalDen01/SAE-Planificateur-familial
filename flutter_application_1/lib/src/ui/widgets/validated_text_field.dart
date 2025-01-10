import 'package:flutter/material.dart';

class ValidatedTextField extends StatefulWidget {
  final String hintText;
  final Color hintTextColor;
  final Color textColor;
  final TextEditingController controller;
  final String? Function(String) validator;

  const ValidatedTextField({
    super.key,
    required this.hintText,
    required this.hintTextColor,
    required this.textColor,
    required this.controller,
    required this.validator,
  });

  @override
  ValidatedTextFieldState createState() => ValidatedTextFieldState();
}

class ValidatedTextFieldState extends State<ValidatedTextField> {
  String? errorMessage;

  void validate() {
    setState(() {
      errorMessage = widget.validator(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: widget.hintTextColor),
        errorText: errorMessage, // Garde uniquement ceci
      ),
      style: TextStyle(color: widget.textColor),
      onChanged: (_) {
        if (errorMessage != null) {
          setState(() {
            errorMessage = null;  // Efface l'erreur en tapant
          });
        }
      },
    );
  }
}
