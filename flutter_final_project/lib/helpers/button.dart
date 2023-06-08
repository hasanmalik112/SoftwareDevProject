import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final String title;
  final Color bColor;
  final Function()? onTap;

  const SocialSignInButton(
      {super.key,
      required this.title,
      required this.bColor,
      required this.onTap});

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: bColor),
            color: bColor,
          ),
          child: Text(title),
        ));
  }
}
