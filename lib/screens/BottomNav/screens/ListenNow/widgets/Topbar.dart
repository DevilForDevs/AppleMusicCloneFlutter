import 'package:flutter/material.dart';
class Topbar extends StatelessWidget {
  const Topbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Text("Listen Now", style: TextStyle(fontFamily:"SFPro",fontSize: 34, fontWeight: FontWeight.w700,letterSpacing: 0.37)),
          Spacer(),
          Image.asset("assets/images/misc/person.png", width: 30, height: 30,)
        ]
      ),
    );
  }
}
