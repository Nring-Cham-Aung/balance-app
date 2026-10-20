
import 'package:balance/bin/icon_mapper.dart';
import 'package:flutter/material.dart';

class IconCard extends StatelessWidget {
  final String iconCode;
  final String title;
  final VoidCallback onTap;
  const new({super.key, required this.iconCode, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(12)
        ),
        width: 90,
        child: Column(children: [
          Icon(IconMapper.icon(iconCode)),
          Text(title)
        ],)
      
      ),
    );
  }
}