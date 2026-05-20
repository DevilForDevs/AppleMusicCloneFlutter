import 'package:flutter/material.dart';

class BigButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const BigButton({
    super.key,
    this.icon = Icons.play_arrow,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: const Color(0x1F767680),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFFFF2D55),
            ),

            const SizedBox(width: 8),

            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFFF2D55),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}