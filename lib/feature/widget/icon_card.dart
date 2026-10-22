
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
        width: 120,
        child: Column(children: [
          Icon(IconMapper.icon(iconCode), size: 40, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),
          Text(title, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,)
        ],)
      
      ),
    );
  }
}