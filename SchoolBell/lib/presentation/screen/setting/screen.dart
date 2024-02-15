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
    // TODO: 상태 관리 방식 변경
    final bool isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    final String bellModeValue = context.select<SettingManager, String>((SettingManager sm) => sm.bellModeName);
    final bool isOnTime = context.select<SettingManager, bool>((SettingManager sm) => sm.isOnTime);
    final String classLengthValue = context.select<SettingManager, String>((SettingManager sm) => sm.classLengthString);
    final String restLengthValue = context.select<SettingManager, String>((SettingManager sm) => sm.restLengthString);
    final String classBellValue =
        context.select<SettingManager, String>((SettingManager sm) => sm.customClassBell ?? sm.classBellString);
    final String restBellValue =
        context.select<SettingManager, String>((SettingManager sm) => sm.customRestBell ?? sm.restBellString);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),

          /// 기본 설정
          const SettingCategory(title: '기본 설정'),
          SettingItem(
            title: '종소리 모드',
            attribute: bellModeValue,
            isDisabled: isCounting,
            onTap: () async {
              // TODO: dialog 개편
              final result = await showDialog(
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
            },
          ),
          SettingItem(
            title: '한 교시 길이',
            attribute: classLengthValue,
            isDisabled: isOnTime || isCounting,
            onTap: () async {
              final result = await showDialog(
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
            },
          ),
          SettingItem(
            title: '쉬는 시간 길이',
            attribute: restLengthValue,
            isDisabled: isOnTime || isCounting,
            onTap: () async {
              final result = await showDialog(
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
            },
          ),
          const SizedBox(height: 8),

          /// 종소리 설정
          const SettingCategory(title: '종소리 설정'),
          SettingItem(
            title: '수업 시작 종',
            attribute: classBellValue,
            isDisabled: isCounting,
            onTap: () async {
              final result = await showDialog(
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
            },
          ),
          SettingItem(
            title: '수업 종료 종',
            attribute: restBellValue,
            isDisabled: isCounting,
            onTap: () async {
              final result = await showDialog(
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
            },
          ),
          const SizedBox(height: 8),

          /// 서비스 정보
          const SettingCategory(title: '서비스 정보'),
          // TODO: 내부 코드로 이식해오기
          SettingItemVersion(
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
          ),
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
}
