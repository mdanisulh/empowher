import 'package:empowher/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyIcon extends StatelessWidget {
  final String pathname;
  final String text;
  final VoidCallback onTap;

  const MyIcon({
    super.key,
    required this.pathname,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            pathname,
            colorFilter: const ColorFilter.mode(Pallete.black, BlendMode.srcIn),
            height: 25,
            width: 25,
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
