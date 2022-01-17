import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';
import '../schoolbell_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingManager settingManager = Provider.of<SettingManager>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            height: 72,
            color: SchoolBellColor.colorSub,
          ),
          const SettingCategory(title: '기본 설정'),
          SettingItem(
            title: '종소리 모드',
            attribute: settingManager.bellMode,
            onTap: () {},
          ),
          SettingItem(
            title: '한 교시 길이',
            attribute: settingManager.classLength,
            stateOnTime: settingManager.isOnTime,
            onTap: () {},
          ),
          SettingItem(
            title: '쉬는 시간 길이',
            attribute: settingManager.restLength,
            stateOnTime: settingManager.isOnTime,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          const SettingCategory(title: '종소리 설정'),
          SettingItem(
            title: '수업 시작 종',
            attribute: settingManager.classBell,
            onTap: () {},
          ),
          SettingItem(
            title: '수업 종료 종',
            attribute: settingManager.restBell,
            onTap: () {},
          ),
          const SizedBox(height: 8),
          const SettingCategory(title: '어플리케이션'),
          SettingItemVersion(
            onTap: () {},
          ),
          SettingItem(
            title: '오픈소스 라이선스',
            attribute: '',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
