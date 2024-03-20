import 'package:flutter/material.dart';

class SnackBarContent extends StatelessWidget {
  final Widget icon;
  final String message;

  const SnackBarContent({
    required this.icon,
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8.0), // Add spacing between icon and text
        Text(message, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
