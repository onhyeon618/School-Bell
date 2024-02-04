import 'package:flutter/material.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';

class RadioBellMode<int> extends StatelessWidget {
  final int value;
  final int groupValue;
  final String radioName;
  final String radioCaption;
  final ValueChanged<int> onChanged;

  const RadioBellMode({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.radioName,
    required this.radioCaption,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 12, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  radioName,
                  style: SchoolBellTheme.mainTextTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  radioCaption,
                  style: const TextStyle(fontSize: 16.0, color: Colors.black),
                )
              ],
            ),
            Radio<int>(
              groupValue: groupValue,
              value: value,
              activeColor: SchoolBellColor.colorAccent,
              onChanged: (int? newValue) {
                onChanged(newValue!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
