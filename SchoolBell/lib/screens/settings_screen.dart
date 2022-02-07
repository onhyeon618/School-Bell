import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/screens/custom_dialog.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingManager settingManager = Provider.of<SettingManager>(context);
    ClassManager classManager = Provider.of<ClassManager>(context);

    final AdWidget nativeAdWidget = AdWidget(ad: SbNativeAd.customNativeAd);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            height: 80,
            child: nativeAdWidget,
          ),
          const SettingCategory(title: '기본 설정'),
          SettingItem(
            title: '종소리 모드',
            attribute: settingManager.bellModeName,
            isDisabled: classManager.isCounting,
            onTap: () async {
              if (!classManager.isCounting) {
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
                if (result != null && result['returnValue'] > -1) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setBellMode(result['returnValue']);
                }
              }
            },
          ),
          SettingItem(
            title: '한 교시 길이',
            attribute: settingManager.classLengthString,
            isDisabled: settingManager.isOnTime || classManager.isCounting,
            onTap: () async {
              if (!settingManager.isOnTime && !classManager.isCounting) {
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
                if (result != null && result['returnValue'] > -1) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setClassLength(result['returnValue']);
                }
              }
            },
          ),
          SettingItem(
            title: '쉬는 시간 길이',
            attribute: settingManager.restLengthString,
            isDisabled: settingManager.isOnTime || classManager.isCounting,
            onTap: () async {
              if (!settingManager.isOnTime && !classManager.isCounting) {
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
                if (result != null && result['returnValue'] > -1) {
                  Provider.of<SettingManager>(context, listen: false)
                      .setRestLength(result['returnValue']);
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
            isDisabled: classManager.isCounting,
            onTap: () async {
              if (!classManager.isCounting) {
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
                  if (result['returnValue'] > -1 && result['returnValue'] < 9) {
                    Provider.of<SettingManager>(context, listen: false)
                        .setClassBell(result['returnValue']);
                    Provider.of<SettingManager>(context, listen: false)
                        .setCustomClassBell(null);
                  } else if (result['returnValue'] == 9) {
                    Provider.of<SettingManager>(context, listen: false)
                        .setClassBell(9);
                    Provider.of<SettingManager>(context, listen: false)
                        .setCustomClassBell(result['extra']);
                  }
                }
              }
            },
          ),
          SettingItem(
            title: '수업 종료 종',
            attribute:
                settingManager.customRestBell ?? settingManager.restBellString,
            isDisabled: classManager.isCounting,
            onTap: () async {
              if (!classManager.isCounting) {
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
                  if (result['returnValue'] > -1 && result['returnValue'] < 9) {
                    Provider.of<SettingManager>(context, listen: false)
                        .setRestBell(result['returnValue']);
                    Provider.of<SettingManager>(context, listen: false)
                        .setCustomRestBell(null);
                  } else if (result['returnValue'] == 9) {
                    Provider.of<SettingManager>(context, listen: false)
                        .setRestBell(9);
                    Provider.of<SettingManager>(context, listen: false)
                        .setCustomRestBell(result['extra']);
                  }
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
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .openLicensesPage();
            },
          ),
        ],
      ),
    );
  }
}
