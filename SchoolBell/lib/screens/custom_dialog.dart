import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:editable_number_picker/editable_number_picker.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/models/models.dart';
import 'package:school_bell/widgets/radio_bell_mode.dart';
import '../schoolbell_colors.dart';
import '../schoolbell_theme.dart';

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
  final bool? forClass;

  const CustomDialog({
    Key? key,
    required this.dialogType,
    required this.positive,
    required this.negative,
    this.title,
    this.content,
    this.forClass,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  late BellSoundPlayer _player;

  int _returnValue = 0;
  String? _tempCustomBell;
  String? _extra;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SettingManager settingManager =
        Provider.of<SettingManager>(context, listen: false);

    switch (widget.dialogType) {
      case CustomDialogType.startClass:
        _returnValue = 1;
        break;
      case CustomDialogType.setBellMode:
        _returnValue = settingManager.bellMode;
        break;
      case CustomDialogType.setTimeLength:
        _returnValue = widget.forClass!
            ? settingManager.classLength
            : settingManager.restLength;
        break;
      case CustomDialogType.setBellType:
        _returnValue = widget.forClass!
            ? settingManager.classBell
            : settingManager.restBell;
        _tempCustomBell = widget.forClass!
            ? settingManager.customClassBell
            : settingManager.customRestBell;
        _player = BellSoundPlayer();
        break;
    }
  }

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (widget.dialogType != CustomDialogType.setBellType)
                  const SizedBox(height: 28),
                if (widget.dialogType != CustomDialogType.setBellType &&
                    widget.title != null)
                  Text(
                    widget.title!,
                    style: SchoolBellTheme.mainTextTheme.headline2,
                  ),
                if (widget.dialogType != CustomDialogType.setBellType &&
                    widget.title != null)
                  const SizedBox(height: 20),
                if (widget.dialogType == CustomDialogType.startClass)
                  classSizePicker(),
                if (widget.dialogType == CustomDialogType.endClass &&
                    widget.content != null)
                  Text(
                    widget.content!,
                    style: SchoolBellTheme.mainTextTheme.subtitle1,
                  ),
                if (widget.dialogType == CustomDialogType.setBellMode)
                  bellModePicker(),
                if (widget.dialogType == CustomDialogType.setTimeLength)
                  timeLengthPicker(),
                if (widget.dialogType == CustomDialogType.setBellType)
                  bellTypePicker(),
                if (widget.dialogType != CustomDialogType.setBellType)
                  const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (widget.dialogType == CustomDialogType.setBellType) {
                    _player.stopSampleSound();
                  }
                  Navigator.pop(context, {"returnValue": -1, "extra": _extra});
                },
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
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (widget.dialogType == CustomDialogType.setBellType) {
                    _player.stopSampleSound();
                  }
                  Navigator.pop(
                      context, {"returnValue": _returnValue, "extra": _extra});
                },
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
    );
  }

  Widget classSizePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => setState(() {
            if (_returnValue > 1) _returnValue--;
          }),
          icon: const Icon(
            Icons.remove,
            color: Colors.black,
          ),
        ),
        Container(
          width: 48.0,
          height: 32.0,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            color: SchoolBellColor.colorSub,
          ),
          child: Text(
            '$_returnValue',
            style: SchoolBellTheme.mainTextTheme.subtitle1,
          ),
        ),
        IconButton(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => setState(() {
            if (_returnValue < 9) _returnValue++;
          }),
          icon: const Icon(
            Icons.add,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget bellModePicker() {
    return Column(
      children: [
        RadioBellMode(
          value: BellMode.onTime,
          groupValue: _returnValue,
          radioName: '정각 모드',
          radioCaption: '매 시 50분과 0분에 울려요.',
          onChanged: (int newValue) {
            setState(() {
              _returnValue = newValue;
            });
          },
        ),
        RadioBellMode(
          value: BellMode.byCustom,
          groupValue: _returnValue,
          radioName: '커스텀 모드',
          radioCaption: '시작한 순간부터 시간을 재요.',
          onChanged: (int newValue) {
            setState(() {
              _returnValue = newValue;
            });
          },
        ),
      ],
    );
  }

  Widget timeLengthPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EditableNumberPicker(
          value: _returnValue,
          minValue: widget.forClass! ? 10 : 5,
          maxValue: widget.forClass! ? 120 : 60,
          step: 1,
          itemHeight: 48,
          textStyle: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
          selectedTextStyle: SchoolBellTheme.mainTextTheme.headline2,
          haptics: true,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(),
              bottom: BorderSide(),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _returnValue = value;
            });
          },
        ),
        const SizedBox(width: 16),
        Text(
          '분',
          style: SchoolBellTheme.mainTextTheme.subtitle1,
        ),
      ],
    );
  }

  Widget bellTypePicker() {
    return Column(
      children: [
        const SizedBox(height: 8),
        for (int i = 1; i <= 8; i++)
          RadioListTile(
            contentPadding: const EdgeInsets.fromLTRB(32, 0, 16, 0),
            title: Text(
              '#$i',
              style: SchoolBellTheme.mainTextTheme.subtitle1,
            ),
            value: i,
            groupValue: _returnValue,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: SchoolBellColor.colorAccent,
            onChanged: (int? newValue) {
              _player.playSampleSound(i);
              setState(() {
                _returnValue = newValue!;
              });
            },
          ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            FilePickerResult? result =
                await FilePicker.platform.pickFiles(type: FileType.audio);
            if (result != null) {
              _extra = result.files.single.path;
              setState(() {
                _returnValue = 9;
                _tempCustomBell = result.files.single.name;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '기기에서 선택...',
                  style: SchoolBellTheme.mainTextTheme.subtitle1,
                ),
                Text(
                  _tempCustomBell ?? '',
                  style: SchoolBellTheme.mainTextTheme.subtitle2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
