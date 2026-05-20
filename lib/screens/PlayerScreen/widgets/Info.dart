import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String title;
  final String des;
  final VoidCallback? onMorePressed;

  const Info({
    super.key,
    required this.title,
    required this.des,
    this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          /// Title + Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "SFPro",
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),

                ),

                const SizedBox(height: 4),

                Text(
                  des,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromRGBO(60, 60, 67, 0.6),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// More Button
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const CircleBorder(),
              ),
              onPressed: onMorePressed,
              icon: const Icon(
                Icons.more_horiz,
                size: 20,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}