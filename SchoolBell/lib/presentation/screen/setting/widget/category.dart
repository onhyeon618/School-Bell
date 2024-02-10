import 'package:flutter/material.dart';

class SettingCategory extends StatelessWidget {
  final String title;

  const SettingCategory({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      width: double.infinity,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
