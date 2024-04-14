import 'package:flutter/material.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String? attribute;
  final VoidCallback? onTap;
  final bool isDisabled;

  const SettingItem({
    super.key,
    required this.title,
    this.attribute,
    this.onTap,
    this.isDisabled = false,
  });

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
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              // TODO: 스타일 제거 또는 정리 & 적용 방식 변경
              style: isDisabled ? Theme.of(context).textTheme.titleLarge : Theme.of(context).textTheme.headlineSmall,
            ),
            if (attribute != null)
              Text(
                attribute!,
                style: isDisabled ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
}
