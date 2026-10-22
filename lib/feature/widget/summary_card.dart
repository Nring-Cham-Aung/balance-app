import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;
  const new({super.key, required this.text, required this.backgroundColor, required this.textColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: Text(text, style: TextTheme.of(context).headlineSmall?.copyWith(color: textColor))
        ),
      ),
    );
  }
}