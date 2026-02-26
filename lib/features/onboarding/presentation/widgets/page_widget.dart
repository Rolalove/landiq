import 'package:flutter/material.dart';

class PageWidget extends StatelessWidget {
  final String image;
  final String text;

  const PageWidget({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        // optional dark overlay for better text visibility
        // color: Colors.withOpacity(0.4),
        color: Color(0xff062B35).withOpacity(0.7),
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Text(
          text,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
