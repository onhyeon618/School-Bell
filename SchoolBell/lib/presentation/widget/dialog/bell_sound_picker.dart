import 'dart:async';

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
  int selected = 0;
  String? customBellName;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
    customBellName = widget.customBell;
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
            groupValue: selected,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: SchoolBellColor.colorAccent,
            onChanged: (newValue) async {
              if (newValue == null) return;

              unawaited(BellSoundPlayer.instance.playAssetSource(newValue));
              widget.onSelected.call(newValue);

              setState(() {
                selected = newValue;
              });
            },
          ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () async {
            await BellSoundPlayer.instance.stopPlaying();

            final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
            if (result != null) {
              final path = result.files.single.path;
              if (path == null) return;

              unawaited(BellSoundPlayer.instance.playDeviceFile(path));
              widget.onSelected.call(path);

              setState(() {
                selected = 8;
                customBellName = result.files.single.name;
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
                    customBellName ?? '',
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
