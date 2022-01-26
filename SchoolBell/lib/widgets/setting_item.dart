import 'package:flutter/material.dart';
import 'package:school_bell/schoolbell_colors.dart';

class SettingItem extends StatefulWidget {
  final String title;
  final String attribute;
  final bool? stateOnTime;
  final Function onTap;

  const SettingItem({
    Key? key,
    required this.title,
    required this.attribute,
    required this.onTap,
    this.stateOnTime,
  }) : super(key: key);

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: Container(
          color: (widget.stateOnTime != null && widget.stateOnTime!)
              ? SchoolBellColor.colorInvalid
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: (widget.stateOnTime != null && widget.stateOnTime!)
                    ? Theme.of(context).textTheme.headline6
                    : Theme.of(context).textTheme.headline5,
              ),
              Text(
                widget.attribute,
                style: (widget.stateOnTime != null && widget.stateOnTime!)
                    ? Theme.of(context).textTheme.bodyText2
                    : Theme.of(context).textTheme.bodyText1,
              ),
            ],
          )),
    );
  }
}
