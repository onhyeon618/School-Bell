import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:school_bell/domain/bell_sound_player.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';

class BellSoundPicker extends StatefulWidget {
  final int initialValue;
  final ValueChanged onSelected;

  const BellSoundPicker({
    super.key,
    required this.initialValue,
    required this.onSelected,
  });

  @override
  State<BellSoundPicker> createState() => _BellSoundPickerState();
}

class _BellSoundPickerState extends State<BellSoundPicker> {
  int _selected = 0;
  String? _customBellName;

  // TODO: static 플레이어 활용
  final BellSoundPlayer _player = BellSoundPlayer();

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        for (int index = 0; index < 8; index++)
          RadioListTile(
            contentPadding: const EdgeInsets.only(left: 32, right: 16),
            title: Text(
              '#${index + 1}',
              style: SchoolBellTheme.mainTextTheme.bodyMedium,
            ),
            value: index,
            groupValue: _selected,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: SchoolBellColor.colorAccent,
            onChanged: (newValue) {
              if (newValue == null) return;

              _player.playSampleSound(newValue);
              widget.onSelected.call(newValue);

              setState(() {
                _selected = newValue;
              });
            },
          ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            _player.stopSampleSound();
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
            if (result != null) {
              widget.onSelected.call(result.files.single.path);
              setState(() {
                _selected = 8;
                _customBellName = result.files.single.name;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: RichText(
              text: TextSpan(
                children: [
                  const TextSpan(text: '기기에서 선택... '),
                  TextSpan(
                    text: _customBellName ?? '',
                    style: SchoolBellTheme.mainTextTheme.bodySmall,
                  ),
                ],
                style: SchoolBellTheme.mainTextTheme.bodyMedium,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
