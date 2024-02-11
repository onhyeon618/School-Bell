import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/app_update_checker.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/domain/setting_manager.dart';
import 'package:school_bell/navigation/app_state_manager.dart';
import 'package:school_bell/presentation/screen/setting/widget/category.dart';
import 'package:school_bell/presentation/screen/setting/widget/item.dart';
import 'package:school_bell/presentation/screen/setting/widget/item_version.dart';
import 'package:school_bell/presentation/widget/custom_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingManager settingManager;
  late AppUpdateChecker appUpdateChecker;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    settingManager = Provider.of<SettingManager>(context, listen: false);
    appUpdateChecker = Provider.of<AppUpdateChecker>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          const SettingCategory(title: '기본 설정'),
          buildBellModeItem(context),
          buildClassLengthItem(context),
          buildRestLengthItem(context),
          const SizedBox(height: 8),
          const SettingCategory(title: '종소리 설정'),
          buildClassBellItem(context),
          buildRestBellItem(context),
          const SizedBox(height: 8),
          const SettingCategory(title: '어플리케이션'),
          buildAppVersionItem(context),
          SettingItem(
            title: '오픈소스 라이선스',
            attribute: '',
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false).openLicensesPage();
            },
          ),
        ],
      ),
    );
  }

  Widget buildBellModeItem(BuildContext context) {
    final bool isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final String bellModeValue = context.select<SettingManager, String>((SettingManager sm) => sm.bellModeName);

    return SettingItem(
      title: '종소리 모드',
      attribute: bellModeValue,
      isDisabled: isCounting,
      onTap: () async {
        if (!isCounting) {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                dialogType: CustomDialogType.setBellMode,
                title: '종소리 모드',
                positive: '설정하기',
                negative: '취소',
              );
            },
          );
          if (result != null && result['returnValue'] > -1) {
            settingManager.setBellMode(result['returnValue']);
          }
        }
      },
    );
  }

  Widget buildClassLengthItem(BuildContext context) {
    final bool isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final bool isOnTime = context.select<SettingManager, bool>((SettingManager sm) => sm.isOnTime);
    final String classLengthValue = context.select<SettingManager, String>((SettingManager sm) => sm.classLengthString);

    return SettingItem(
      title: '한 교시 길이',
      attribute: classLengthValue,
      isDisabled: isOnTime || isCounting,
      onTap: () async {
        if (!isOnTime && !isCounting) {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                dialogType: CustomDialogType.setTimeLength,
                positive: '설정하기',
                negative: '취소',
                forClass: true,
              );
            },
          );
          if (result != null && result['returnValue'] > -1) {
            settingManager.setClassLength(result['returnValue']);
          }
        }
      },
    );
  }

  Widget buildRestLengthItem(BuildContext context) {
    final bool isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final bool isOnTime = context.select<SettingManager, bool>((SettingManager sm) => sm.isOnTime);
    final String restLengthValue = context.select<SettingManager, String>((SettingManager sm) => sm.restLengthString);

    return SettingItem(
      title: '쉬는 시간 길이',
      attribute: restLengthValue,
      isDisabled: isOnTime || isCounting,
      onTap: () async {
        if (!isOnTime && !isCounting) {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                dialogType: CustomDialogType.setTimeLength,
                positive: '설정하기',
                negative: '취소',
                forClass: false,
              );
            },
          );
          if (result != null && result['returnValue'] > -1) {
            settingManager.setRestLength(result['returnValue']);
          }
        }
      },
    );
  }

  Widget buildClassBellItem(BuildContext context) {
    final bool isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final String classBellValue =
        context.select<SettingManager, String>((SettingManager sm) => sm.customClassBell ?? sm.classBellString);

    return SettingItem(
      title: '수업 시작 종',
      attribute: classBellValue,
      isDisabled: isCounting,
      onTap: () async {
        if (!isCounting) {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                dialogType: CustomDialogType.setBellType,
                positive: '설정하기',
                negative: '취소',
                forClass: true,
              );
            },
          );
          if (result != null && result['returnValue'] > -1) {
            if (result['returnValue'] < 9) {
              settingManager.setClassBell(result['returnValue']);
              settingManager.setCustomClassBell(null);
            } else {
              settingManager.setClassBell(9);
              settingManager.setCustomClassBell(result['extra']);
            }
          }
        }
      },
    );
  }

  Widget buildRestBellItem(BuildContext context) {
    final bool isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final String restBellValue =
        context.select<SettingManager, String>((SettingManager sm) => sm.customRestBell ?? sm.restBellString);

    return SettingItem(
      title: '수업 종료 종',
      attribute: restBellValue,
      isDisabled: isCounting,
      onTap: () async {
        if (!isCounting) {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                dialogType: CustomDialogType.setBellType,
                positive: '설정하기',
                negative: '취소',
                forClass: false,
              );
            },
          );
          if (result != null && result['returnValue'] > -1) {
            if (result['returnValue'] < 9) {
              settingManager.setRestBell(result['returnValue']);
              settingManager.setCustomRestBell(null);
            } else if (result['returnValue'] == 9) {
              settingManager.setRestBell(9);
              settingManager.setCustomRestBell(result['extra']);
            }
          }
        }
      },
    );
  }

  Widget buildAppVersionItem(BuildContext context) {
    return SettingItemVersion(
      onTap: () async {
        if (appUpdateChecker.isUpdateAvailable) {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const CustomDialog(
                dialogType: CustomDialogType.normalDialog,
                title: '업데이트가 가능합니다',
                content: '어플의 새 버전이 출시되었어요.\n지금 바로 업데이트 하러 가시겠어요?',
                positive: '스토어 가기',
                negative: '나중에',
              );
            },
          );
          if (result != null && result['returnValue'] > -1) {
            // TODO
            // appUpdateChecker.redirectToStore();
          }
        } else {
          Fluttertoast.showToast(
            msg: '현재 최신 버전이에요.',
            toastLength: Toast.LENGTH_SHORT,
          );
        }
      },
      isUpdateAvailable: appUpdateChecker.isUpdateAvailable,
    );
  }
}
