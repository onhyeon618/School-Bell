import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/app_update_checker.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/domain/setting_manager.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:school_bell/enum/dialog_type.dart';
import 'package:school_bell/navigation/app_state_manager.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/presentation/screen/setting/widget/category.dart';
import 'package:school_bell/presentation/screen/setting/widget/setting_item.dart';
import 'package:school_bell/presentation/screen/setting/widget/app_version_item.dart';
import 'package:school_bell/presentation/widget/sb_dialog.dart';

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
    final classState = context.select<ClassManager, ClassState>((ClassManager cm) => cm.currentState);
    final String bellModeValue = context.select<SettingManager, String>((SettingManager sm) => sm.bellModeName);
    final bool isOnTime = context.select<SettingManager, bool>((SettingManager sm) => sm.isOnTime);
    final String classLengthValue = context.select<SettingManager, String>((SettingManager sm) => sm.classLengthString);
    final String restLengthValue = context.select<SettingManager, String>((SettingManager sm) => sm.restLengthString);
    final String classBellValue =
        context.select<SettingManager, String>((SettingManager sm) => sm.customClassBell ?? sm.classBellString);
    final String restBellValue =
        context.select<SettingManager, String>((SettingManager sm) => sm.customRestBell ?? sm.restBellString);

    final bool isCounting = classState != ClassState.idle;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 64,
            alignment: Alignment.center,
            child: Text(
              '설정',
              style: SchoolBellTheme.mainTextTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 6),

          /// 기본 설정
          const SettingCategory(title: '기본 설정'),
          SettingItem(
            title: '종소리 모드',
            attribute: bellModeValue,
            isDisabled: isCounting,
            onTap: () async {
              final int? result = await SBDialog.showTyped(
                title: '종소리 모드',
                context: context,
                type: DialogType.setBellMode,
                initialValue: settingManager.bellMode,
                padding: const EdgeInsets.only(top: 28, bottom: 24, left: 10, right: 10),
              );

              if (result != null) settingManager.setBellMode(result);
            },
          ),
          SettingItem(
            title: '한 교시 길이',
            attribute: classLengthValue,
            isDisabled: isOnTime || isCounting,
            onTap: () async {
              final int? result = await SBDialog.showTyped(
                context: context,
                type: DialogType.setTimeLength,
                initialValue: settingManager.classLength,
                maxValue: 120,
                minValue: 10,
              );

              if (result != null) settingManager.setClassLength(result);
            },
          ),
          SettingItem(
            title: '쉬는 시간 길이',
            attribute: restLengthValue,
            isDisabled: isOnTime || isCounting,
            onTap: () async {
              final int? result = await SBDialog.showTyped(
                context: context,
                type: DialogType.setTimeLength,
                initialValue: settingManager.restLength,
                maxValue: 60,
                minValue: 5,
              );

              if (result != null) settingManager.setRestLength(result);
            },
          ),
          _buildDivider(8),

          /// 종소리 설정
          const SettingCategory(title: '종소리 설정'),
          SettingItem(
            title: '수업 시작 종',
            attribute: classBellValue,
            isDisabled: isCounting,
            onTap: () async {
              final initialValue = settingManager.customClassBell ?? settingManager.classBell;

              final result = await SBDialog.showTyped(
                context: context,
                type: DialogType.setBellSound,
                initialValue: initialValue,
                padding: EdgeInsets.zero,
              );

              // TODO: 사운드 플레이 종료

              if (result == null) return;

              if (result is int) {
                settingManager.setClassBell(result);
                settingManager.setCustomClassBell(null);
              } else {
                settingManager.setCustomClassBell(result);
              }
            },
          ),
          SettingItem(
            title: '수업 종료 종',
            attribute: restBellValue,
            isDisabled: isCounting,
            onTap: () async {
              final initialValue = settingManager.customRestBell ?? settingManager.restBell;

              final result = await SBDialog.showTyped(
                context: context,
                type: DialogType.setBellSound,
                initialValue: initialValue,
                padding: EdgeInsets.zero,
              );

              // TODO: 사운드 플레이 종료

              if (result == null) return;

              if (result is int) {
                settingManager.setRestBell(result);
                settingManager.setCustomRestBell(null);
              } else {
                settingManager.setCustomRestBell(result);
              }
            },
          ),
          _buildDivider(8),

          /// 서비스 정보
          const SettingCategory(title: '서비스 정보'),
          AppVersionItem(
            isUpdateAvailable: appUpdateChecker.isUpdateAvailable,
            onTap: () async {
              if (appUpdateChecker.isUpdateAvailable) {
                SBDialog.showText(
                  context: context,
                  title: '업데이트가 가능합니다',
                  content: '어플의 새 버전이 출시되었어요.\n지금 바로 업데이트 하러 가시겠어요?',
                  positive: '스토어 가기',
                  negative: '나중에',
                  onPositive: (dialogContext) {
                    // TODO
                    // appUpdateChecker.redirectToStore();
                  },
                );
              } else {
                Fluttertoast.showToast(
                  msg: '현재 최신 버전이에요.',
                  toastLength: Toast.LENGTH_SHORT,
                );
              }
            },
          ),
          SettingItem(
            title: '오픈소스 라이선스',
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false).openLicensesPage();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(double height) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ColoredBox(
        color: SchoolBellColor.colorSplash,
        child: SizedBox(height: height, width: double.infinity),
      ),
    );
  }
}
