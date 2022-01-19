import 'package:flutter/material.dart';
import 'package:school_bell/schoolbell_colors.dart';
import 'package:school_bell/schoolbell_theme.dart';

class CustomDialogType {
  static const int startClass = 0;
  static const int endClass = 1;
  static const int setBellMode = 2;
  static const int setTimeLength = 3;
  static const int setBellType = 4;
}

class CustomDialog extends StatefulWidget {
  final int dialogType;
  final String positive;
  final String negative;
  final String? title;
  final String? content;

  const CustomDialog({
    Key? key,
    required this.dialogType,
    required this.positive,
    required this.negative,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  int returnValue = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.dialogType != 4 && widget.title != null)
            Text(
              widget.title!,
              style: SchoolBellTheme.mainTextTheme.headline2,
            ),
          if (widget.dialogType != 4 && widget.title != null)
            const SizedBox(height: 20),
          // dialogType에 따라 아래 위젯을 바꿔 끼우는 형태
          // 위젯 내용물은 아래에 있으며, 지금은 placeholder만 있어 추후 구현해야 함
          if (widget.dialogType == 0) classSizePicker(),
          if (widget.dialogType == 1 && widget.content != null)
            Text(
              widget.content!,
              style: SchoolBellTheme.mainTextTheme.subtitle1,
            ),
          if (widget.dialogType == 2) bellModePicker(),
          if (widget.dialogType == 3) timeLengthPicker(),
          if (widget.dialogType == 4) bellTypePicker(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context, -1),
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: SchoolBellColor.colorGray,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(4)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.negative,
                      style: SchoolBellTheme.mainTextTheme.button,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => Navigator.pop(context, returnValue),
                  child: Container(
                    height: 48,
                    decoration: const BoxDecoration(
                      color: SchoolBellColor.colorMain,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(4)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.positive,
                      style: SchoolBellTheme.mainTextTheme.button,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  classSizePicker() {
    returnValue = 1;
    return Text('Class Size Picker');
  }

  bellModePicker() {
    return Text('Bell Mode Picker');
  }

  timeLengthPicker() {
    return Text('Time Length Picker');
  }

  bellTypePicker() {
    return Text('Bell Type Picker');
  }
}
