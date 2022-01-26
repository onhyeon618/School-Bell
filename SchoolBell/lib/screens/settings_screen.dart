import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/screens/custom_dialog.dart';

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
            attribute: settingManager.bellModeName,
            onTap: () async {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      dialogType: CustomDialogType.setBellMode,
                      title: '종소리 모드',
                      positive: '설정하기',
                      negative: '취소',
                    );
                  });
              if (result != null && result > -1) {
                Provider.of<SettingManager>(context, listen: false)
                    .setBellMode(result);
              }
            },
          ),
          SettingItem(
            title: '한 교시 길이',
            attribute: settingManager.classLengthString,
            stateOnTime: settingManager.isOnTime,
            onTap: () async {
              if (!settingManager.isOnTime) {
                var result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CustomDialog(
                        dialogType: CustomDialogType.setTimeLength,
                        positive: '설정하기',
                        negative: '취소',
                        forClass: true,
                      );
                    });
                if (result != null && result > -1) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setClassLength(result);
                }
              }
            },
          ),
          SettingItem(
            title: '쉬는 시간 길이',
            attribute: settingManager.restLengthString,
            stateOnTime: settingManager.isOnTime,
            onTap: () async {
              if (!settingManager.isOnTime) {
                var result = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const CustomDialog(
                        dialogType: CustomDialogType.setTimeLength,
                        positive: '설정하기',
                        negative: '취소',
                        forClass: false,
                      );
                    });
                if (result != null && result > -1) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setRestLength(result);
                }
              }
            },
          ),
          const SizedBox(height: 8),
          const SettingCategory(title: '종소리 설정'),
          SettingItem(
            title: '수업 시작 종',
            attribute: settingManager.customClassBell ??
                settingManager.classBellString,
            onTap: () async {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      dialogType: CustomDialogType.setBellType,
                      positive: '설정하기',
                      negative: '취소',
                      forClass: true,
                    );
                  });
              if (result != null) {
                Provider.of<SettingManager>(context, listen: false)
                    .setClassBell(result);
                if (result > -1 && result < 9) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setClassBell(result);
                  Provider.of<SettingManager>(context, listen: false)
                      .setCustomClassBell(null);
                } else if (result == 9) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setCustomClassBell('커스텀 종소리');
                }
              }
            },
          ),
          SettingItem(
            title: '수업 종료 종',
            attribute:
                settingManager.customRestBell ?? settingManager.restBellString,
            onTap: () async {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      dialogType: CustomDialogType.setBellType,
                      positive: '설정하기',
                      negative: '취소',
                      forClass: false,
                    );
                  });
              if (result != null) {
                Provider.of<SettingManager>(context, listen: false)
                    .setClassBell(result);
                if (result > -1 && result < 9) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setClassBell(result);
                  Provider.of<SettingManager>(context, listen: false)
                      .setCustomClassBell(null);
                } else if (result == 9) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setCustomClassBell('커스텀 종소리');
                }
              }
            },
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
