import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';

class TimeLengthPicker extends StatelessWidget {
  final int initialValue;
  final int minTime;
  final int maxTime;
  final ValueChanged onChanged;

  const TimeLengthPicker({
    super.key,
    required this.initialValue,
    required this.minTime,
    required this.maxTime,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          value: initialValue,
          minValue: minTime,
          maxValue: maxTime,
          step: 1,
          itemHeight: 48,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          selectedTextStyle: SchoolBellTheme.mainTextTheme.titleMedium,
          haptics: true,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(),
              bottom: BorderSide(),
            ),
          ),
          onChanged: onChanged,
        ),
        const SizedBox(width: 16),
        Text(
          '분',
          style: SchoolBellTheme.mainTextTheme.bodyMedium,
        ),
      ],
    );
  }
}
