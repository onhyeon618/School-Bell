import 'package:flutter/material.dart';

class SettingCategory extends StatelessWidget {
  final String title;

  const SettingCategory({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 4, left: 20, right: 20),
      width: double.infinity,
      child: Text(title, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
