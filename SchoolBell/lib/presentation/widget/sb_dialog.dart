import 'package:flutter/material.dart';
import 'package:school_bell/enum/bell_mode.dart';
import 'package:school_bell/enum/dialog_type.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/presentation/widget/dialog/dialog_widgets.dart';

typedef DialogCallback = Function(BuildContext context);

class SBDialog extends StatefulWidget {
  final DialogType type;
  final Object initialValue;
  final String? title;
  final Widget? content;
  final String positive;
  final String? negative;
  final DialogCallback? onPositive;
  final DialogCallback? onNegative;
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
    this.negative,
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
    DialogCallback? onPositive,
    DialogCallback? onNegative,
    EdgeInsets? padding,
  }) {
    return showBasic(
      context: context,
      title: title,
      content: content != null
          ? Text(
              content,
              style: SchoolBellTheme.mainTextTheme.bodyMedium!.copyWith(height: 1.5),
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
    DialogCallback? onPositive,
    DialogCallback? onNegative,
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

  static Future<T?> showConfirm<T>({
    required BuildContext context,
    String? title,
    String? content,
    String? positive,
    DialogCallback? onPositive,
    EdgeInsets? padding,
  }) {
    assert(title != null || content != null, 'title과 content를 모두 비울 수 없습니다.');

    return _show(
      context: context,
      type: DialogType.basic,
      initialValue: 0,
      title: title,
      content: content != null
          ? Text(
              content,
              style: SchoolBellTheme.mainTextTheme.bodyMedium!.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            )
          : null,
      positive: positive ?? DialogType.basic.positive,
      onPositive: onPositive,
      padding: padding,
    );
  }

  static Future<T?> showTyped<T>({
    required BuildContext context,
    required DialogType type,
    required Object initialValue,
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
    required Object initialValue,
    String? title,
    Widget? content,
    required String positive,
    String? negative,
    DialogCallback? onPositive,
    DialogCallback? onNegative,
    EdgeInsets? padding,
    int? minValue,
    int? maxValue,
  }) {
    return showDialog(
      context: context,
      builder: (dialogContext) => SBDialog(
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
  }

  @override
  Widget build(BuildContext context) {
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
                        style: SchoolBellTheme.mainTextTheme.titleMedium,
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
                if (widget.negative != null)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (widget.onNegative != null) {
                          widget.onNegative!.call(context);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: Container(
                        height: 48,
                        color: SchoolBellColor.colorGray,
                        alignment: Alignment.center,
                        child: Text(
                          widget.negative!,
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
                        widget.onPositive!.call(context);
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
    return ClassSizePicker(
      value: _selectedValue as int,
      onPlus: () {
        if (_selectedValue == 9) return;
        setState(() {
          _selectedValue = (_selectedValue as int) + 1;
        });
      },
      onMinus: () {
        if (_selectedValue == 1) return;
        setState(() {
          _selectedValue = (_selectedValue as int) - 1;
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
    final int initial = _selectedValue as int;
    return BellSoundPicker(
      initialValue: initial,
      onSelected: (value) {
        _selectedValue = value;
      },
    );
  }
}
