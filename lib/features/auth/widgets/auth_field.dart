import 'package:empowher/theme/theme.dart';
import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String label;
  final bool obscureText;
  final TextInputType textInputType;
  const AuthField({
    super.key,
    required this.textEditingController,
    required this.label,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      obscureText: obscureText,
      keyboardType: textInputType,
      style: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 20, color: Colors.white),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Colors.amber,
            width: 4,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Pallete.grey,
            width: 2,
          ),
        ),
        focusColor: Pallete.blue,
        contentPadding: const EdgeInsets.all(25),
      ),
    );
  }
}
