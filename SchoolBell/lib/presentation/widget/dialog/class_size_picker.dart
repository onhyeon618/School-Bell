import 'package:flutter/material.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';

class ClassSizePicker extends StatelessWidget {
  final int value;
  final VoidCallback onPlus;
  final VoidCallback onMinus;

  const ClassSizePicker({
    super.key,
    required this.value,
    required this.onPlus,
    required this.onMinus,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onMinus,
          child: const Icon(
            Icons.remove,
            color: Colors.black,
          ),
        ),
        Container(
          width: 48.0,
          height: MediaQuery.textScalerOf(context).scale(32.0),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: SchoolBellColor.colorSub,
          ),
          child: Text(
            '$value',
            style: SchoolBellTheme.mainTextTheme.titleMedium,
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onPlus,
          child: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
