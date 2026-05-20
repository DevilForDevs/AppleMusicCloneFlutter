import 'package:flutter/material.dart';

class Topbar extends StatelessWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onClosePressed;

  const Topbar({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
    this.onClosePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBackButton)
          GestureDetector(
            onTap: onBackPressed,
            child: Row(
              children: const [
                Icon(
                  Icons.chevron_left,
                  size: 24,
                  color: Color(0xFFE63D43),
                ),

                Text(
                  "Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE63D43),
                    fontFamily: "SFPro",
                  ),
                ),
              ],
            ),
          ),

        const Spacer(),

        GestureDetector(
          onTap: onClosePressed,
          child: Image.asset(
            'assets/images/icons/close.png',
            width: 30,
            height: 30,
          ),
        ),
      ],
    );
  }
}