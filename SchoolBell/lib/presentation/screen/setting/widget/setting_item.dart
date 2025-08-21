import 'package:flutter/material.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String? attribute;
  final VoidCallback? onTap;
  final bool isDisabled;

  const SettingItem({super.key, required this.title, this.attribute, this.onTap, this.isDisabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (isDisabled) return;
        onTap?.call();
      },
      child: Container(
        color: isDisabled ? SchoolBellColor.colorInvalid : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: isDisabled ? SchoolBellColor.colorGray : Colors.black),
            ),
            if (attribute != null)
              Text(
                attribute!,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: isDisabled ? SchoolBellColor.colorGray : Colors.black),
              ),
          ],
        ),
      ),
    );
  }
}
