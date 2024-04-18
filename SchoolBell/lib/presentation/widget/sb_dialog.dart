import 'package:flutter/material.dart';
import 'package:school_bell/enum/bell_mode.dart';
import 'package:school_bell/enum/dialog_type.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/presentation/widget/dialog/dialog_widgets.dart';

class SBDialog extends StatefulWidget {
  final DialogType type;
  final int initialValue;
  final String? title;
  final Widget? content;
  final String positive;
  final String negative;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final EdgeInsets padding;

  // setTimeLength 타입에서만 사용
  final int? minValue;
  final int? maxValue;

  const SBDialog({
    super.key,
    required this.type,
    required this.initialValue,
    this.title,
    this.content,
    required this.positive,
    required this.negative,
    this.onPositive,
    this.onNegative,
    EdgeInsets? padding,
    this.minValue,
    this.maxValue,
  }) : padding = padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 24);

  static Future<T?> showText<T>({
    required BuildContext context,
    String? title,
    String? content,
    String? positive,
    String? negative,
    VoidCallback? onPositive,
    VoidCallback? onNegative,
    EdgeInsets? padding,
  }) {
    return showBasic(
      context: context,
      title: title,
      content: content != null
          ? Text(
              content,
              style: SchoolBellTheme.mainTextTheme.titleMedium!.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            )
          : null,
      positive: positive,
      negative: negative,
      onPositive: onPositive,
      onNegative: onNegative,
      padding: padding,
    );
  }

  static Future<T?> showBasic<T>({
    required BuildContext context,
    String? title,
    Widget? content,
    String? positive,
    String? negative,
    VoidCallback? onPositive,
    VoidCallback? onNegative,
    EdgeInsets? padding,
  }) {
    assert(title != null || content != null, 'title과 content를 모두 비울 수 없습니다.');

    return _show(
      context: context,
      type: DialogType.basic,
      initialValue: 0,
      title: title,
      content: content,
      positive: positive ?? DialogType.basic.positive,
      negative: negative ?? DialogType.basic.negative,
      onPositive: onPositive,
      onNegative: onNegative,
      padding: padding,
    );
  }

  static Future<T?> showTyped<T>({
    required BuildContext context,
    required DialogType type,
    required int initialValue,
    String? title,
    EdgeInsets? padding,
    int? minValue,
    int? maxValue,
  }) {
    if (type == DialogType.setTimeLength) {
      assert(minValue != null && maxValue != null, 'minValue와 maxValue 값이 없습니다.');
    }

    return _show(
      context: context,
      type: type,
      initialValue: initialValue,
      title: title,
      positive: type.positive,
      negative: type.negative,
      padding: padding,
      minValue: minValue,
      maxValue: maxValue,
    );
  }

  static Future<T?> _show<T>({
    required BuildContext context,
    required DialogType type,
    required int initialValue,
    String? title,
    Widget? content,
    required String positive,
    required String negative,
    VoidCallback? onPositive,
    VoidCallback? onNegative,
    EdgeInsets? padding,
    int? minValue,
    int? maxValue,
  }) {
    return showDialog(
      context: context,
      builder: (context) => SBDialog(
        type: type,
        initialValue: initialValue,
        title: title,
        content: content,
        positive: positive,
        negative: negative,
        onPositive: onPositive,
        onNegative: onNegative,
        padding: padding,
        minValue: minValue,
        maxValue: maxValue,
      ),
    );
  }

  @override
  State<SBDialog> createState() => _SBDialogState();
}

class _SBDialogState extends State<SBDialog> {
  Widget? dialogContent;

  Object _selectedValue = 0;

  @override
  void initState() {
    super.initState();

    _selectedValue = widget.initialValue;

    switch (widget.type) {
      case DialogType.basic:
        dialogContent = widget.content;
      case DialogType.setClassSize:
        dialogContent = _buildClassSizePicker();
      case DialogType.setBellMode:
        dialogContent = _buildBellModePicker();
      case DialogType.setTimeLength:
        dialogContent = _buildTimeLengthPicker();
      case DialogType.setBellSound:
        dialogContent = _buildBellSoundPicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 내용
            Flexible(
              child: SingleChildScrollView(
                padding: widget.padding,
                child: Column(
                  children: [
                    if (widget.title != null) ...[
                      Text(
                        widget.title!,
                        style: SchoolBellTheme.mainTextTheme.displayMedium,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (dialogContent != null) dialogContent!,
                  ],
                ),
              ),
            ),

            /// 버튼
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (widget.onNegative != null) {
                        widget.onNegative!.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      height: 48,
                      color: SchoolBellColor.colorGray,
                      alignment: Alignment.center,
                      child: Text(
                        widget.negative,
                        style: SchoolBellTheme.mainTextTheme.labelLarge,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (widget.onPositive != null) {
                        widget.onPositive!.call();
                      } else {
                        Navigator.of(context).pop(_selectedValue);
                      }
                    },
                    child: Container(
                      height: 48,
                      color: SchoolBellColor.colorMain,
                      alignment: Alignment.center,
                      child: Text(
                        widget.positive,
                        style: SchoolBellTheme.mainTextTheme.labelLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassSizePicker() {
    final int classSize = _selectedValue as int;
    return ClassSizePicker(
      value: classSize,
      onPlus: () {
        if (classSize == 9) return;
        setState(() {
          _selectedValue = classSize + 1;
        });
      },
      onMinus: () {
        if (classSize == 1) return;
        setState(() {
          _selectedValue = classSize - 1;
        });
      },
    );
  }

  Widget _buildBellModePicker() {
    return BellModePicker(
      value: BellMode.values[_selectedValue as int],
      onSelected: (value) {
        if (value == _selectedValue) return;
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }

  Widget _buildTimeLengthPicker() {
    return TimeLengthPicker(
      initialValue: _selectedValue as int,
      minTime: widget.minValue!,
      maxTime: widget.maxValue!,
      onChanged: (value) {
        if (value == _selectedValue) return;
        setState(() {
          _selectedValue = value;
        });
      },
    );
  }

  Widget _buildBellSoundPicker() {
    final int initial = _selectedValue is int ? _selectedValue as int : 8;
    return BellSoundPicker(
      initialValue: initial,
      onSelected: (value) {
        _selectedValue = value;
      },
    );
  }
}
