import 'package:flutter/material.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final String attribute;
  final bool isDisabled;
  final Function onTap;

  const SettingItem({
    Key? key,
    required this.title,
    required this.attribute,
    required this.onTap,
    this.isDisabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => onTap(),
      child: Container(
          color: isDisabled ? SchoolBellColor.colorInvalid : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: isDisabled
                    ? Theme.of(context).textTheme.titleLarge
                    : Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                attribute,
                style: isDisabled
                    ? Theme.of(context).textTheme.bodyMedium
                    : Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          )),
    );
  }
}
