import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:school_bell/bell_sound_player.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';

class BellSoundPicker extends StatefulWidget {
  final int initialValue;
  final String? customBell;
  final ValueChanged onSelected;

  const BellSoundPicker({
    super.key,
    required this.initialValue,
    this.customBell,
    required this.onSelected,
  });

  @override
  State<BellSoundPicker> createState() => _BellSoundPickerState();
}

class _BellSoundPickerState extends State<BellSoundPicker> {
  int _selected = 0;
  String? _customBellName;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue;
    _customBellName = widget.customBell;
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

              BellSoundPlayer.instance.playAssetSource(newValue);
              widget.onSelected.call(newValue);

              setState(() {
                _selected = newValue;
              });
            },
          ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            BellSoundPlayer.instance.stopPlaying();
            FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
            if (result != null) {
              final path = result.files.single.path!;
              BellSoundPlayer.instance.playDeviceFile(path);
              widget.onSelected.call(path);
              setState(() {
                _selected = 8;
                _customBellName = result.files.single.name;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '기기에서 선택...  ',
                  style: SchoolBellTheme.mainTextTheme.bodyMedium,
                ),
                Flexible(
                  child: Text(
                    _customBellName ?? '',
                    style: SchoolBellTheme.mainTextTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
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
