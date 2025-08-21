import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';

class TimeLengthPicker extends StatefulWidget {
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
  State<TimeLengthPicker> createState() => _TimeLengthPickerState();
}

class _TimeLengthPickerState extends State<TimeLengthPicker> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  bool showEditor = false;

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialValue.toString();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        setState(() {
          showEditor = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ///// 다이얼로그 크기 유지용 빈 위젯
                const SizedBox(height: 144, width: 100),

                ///// NumberPicker: 스크롤하여 시간 선택
                Visibility(
                  visible: !showEditor,
                  child: NumberPicker(
                    value: widget.initialValue,
                    minValue: widget.minTime,
                    maxValue: widget.maxTime,
                    itemHeight: 48,
                    textStyle: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.grey),
                    selectedTextStyle: SchoolBellTheme.mainTextTheme.titleMedium,
                    haptics: true,
                    decoration: const BoxDecoration(border: Border(top: BorderSide(), bottom: BorderSide())),
                    onChanged: (value) {
                      widget.onChanged.call(value);
                      controller.text = value.toString();
                    },
                  ),
                ),

                ///// TextField: 원하는 시간을 직접 입력
                Visibility(
                  visible: showEditor,
                  child: Container(
                    alignment: Alignment.center,
                    height: 48,
                    width: 100,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        RangeFormatter(max: widget.maxTime, min: widget.minTime),
                      ],
                      decoration: null,
                      keyboardType: TextInputType.number,
                      style: SchoolBellTheme.mainTextTheme.titleMedium?.copyWith(height: 1.0),
                      textAlign: TextAlign.center,
                      showCursor: false,
                      onTapOutside: (_) {
                        widget.onChanged.call(int.parse(controller.text));
                        setState(() {
                          showEditor = false;
                        });
                      },
                      onSubmitted: (value) {
                        widget.onChanged.call(int.parse(value));
                        setState(() {
                          showEditor = false;
                        });
                      },
                    ),
                  ),
                ),

                ///// 스택 최상단 투명 박스: 탭하여 TextField 노출여부 결정, 탭 외의 제스처는 하위로 전달(무시)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      showEditor = true;
                    });
                    focusNode.requestFocus();
                    controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
                  },
                  child: const SizedBox(height: 48, width: 100),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Text('분', style: SchoolBellTheme.mainTextTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class RangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  RangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') return newValue;

    final input = int.parse(newValue.text);
    if (input < min) {
      return newValue.copyWith(text: min.toString());
    } else if (input > max) {
      return oldValue;
    } else {
      return newValue;
    }
  }
}
