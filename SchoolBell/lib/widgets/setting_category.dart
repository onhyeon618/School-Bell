import 'package:flutter/material.dart';

class SettingCategory extends StatelessWidget {
  final String title;

  const SettingCategory({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      width: double.infinity,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline4,
      )
    );
  }
}
