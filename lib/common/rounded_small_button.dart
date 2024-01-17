import 'package:empowher/theme/theme.dart';
import 'package:flutter/material.dart';

class RoundedSmallButton extends StatelessWidget {
  final Function() onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  const RoundedSmallButton({
    super.key,
    required this.onTap,
    required this.label,
    this.textColor = Pallete.black,
    this.backgroundColor = Pallete.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        color: MaterialStateProperty.all(Colors.amber),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
