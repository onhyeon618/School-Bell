import 'package:flutter/material.dart';
import 'package:school_bell/enum/bell_mode.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';

class BellModePicker extends StatelessWidget {
  final BellMode value;
  final ValueChanged onSelected;

  const BellModePicker({super.key, required this.value, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BellModeRadio(mode: BellMode.onTime, selectedValue: value, onSelected: onSelected),
        BellModeRadio(mode: BellMode.byCustom, selectedValue: value, onSelected: onSelected),
      ],
    );
  }
}

class BellModeRadio extends StatelessWidget {
  final BellMode mode;
  final BellMode selectedValue;
  final ValueChanged onSelected;

  const BellModeRadio({super.key, required this.mode, required this.selectedValue, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onSelected(mode.index),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(mode.name, style: SchoolBellTheme.mainTextTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(mode.description, style: SchoolBellTheme.mainTextTheme.bodySmall),
              ],
            ),
            Radio(
              groupValue: selectedValue,
              value: mode,
              activeColor: SchoolBellColor.colorAccent,
              onChanged: (_) {
                onSelected(mode.index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
