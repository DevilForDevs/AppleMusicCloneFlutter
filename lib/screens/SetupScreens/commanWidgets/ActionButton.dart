import 'package:flutter/material.dart';
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.title,
    this.onPress
  });

  final String? title;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFE63D43),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          "Start Listening",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontFamily: "SFPro",
          ),
        ),
      ),
    );
  }
}
