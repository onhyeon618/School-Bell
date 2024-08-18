import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/app_update_checker.dart';
import 'package:school_bell/bell_sound_player.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/domain/setting_manager.dart';
import 'package:school_bell/enum/bell_mode.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:school_bell/enum/dialog_type.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/presentation/screen/license/screen.dart';
import 'package:school_bell/presentation/screen/setting/widget/category.dart';
import 'package:school_bell/presentation/screen/setting/widget/setting_item.dart';
import 'package:school_bell/presentation/screen/setting/widget/app_version_item.dart';
import 'package:school_bell/presentation/widget/sb_dialog.dart';
import 'package:store_redirect/store_redirect.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingManager = context.read<SettingManager>();

    final classState = context.select<ClassManager, ClassState>((ClassManager cm) => cm.currentState);
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
          Selector<SettingManager, BellMode>(
            selector: (_, state) => state.bellMode,
            builder: (_, bellMode, __) {
              return SettingItem(
                title: '종소리 모드',
                attribute: bellMode.name,
                isDisabled: isCounting,
                onTap: () async {
                  final int? result = await SBDialog.showTyped(
                    title: '종소리 모드',
                    context: context,
                    type: DialogType.setBellMode,
                    initialValue: bellMode.index,
                    padding: const EdgeInsets.only(top: 28, bottom: 24, left: 10, right: 10),
                  );

                  if (result != null) settingManager.setBellMode(result);
                },
              );
            },
          ),
          Selector<SettingManager, ({bool isOnTime, int classLength})>(
            selector: (_, state) => (isOnTime: state.isOnTime, classLength: state.classLength),
            builder: (_, data, __) {
              return SettingItem(
                title: '한 교시 길이',
                attribute: '${data.classLength}분',
                isDisabled: data.isOnTime || isCounting,
                onTap: () async {
                  final int? result = await SBDialog.showTyped(
                    context: context,
                    type: DialogType.setTimeLength,
                    initialValue: settingManager.classLength,
                    maxValue: 120,
                    minValue: 10,
                    padding: EdgeInsets.zero,
                  );

                  if (result != null) settingManager.setClassLength(result);
                },
              );
            },
          ),
          Selector<SettingManager, ({bool isOnTime, int restLength})>(
            selector: (_, state) => (isOnTime: state.isOnTime, restLength: state.restLength),
            builder: (_, data, __) {
              return SettingItem(
                title: '쉬는 시간 길이',
                attribute: '${data.restLength}분',
                isDisabled: data.isOnTime || isCounting,
                onTap: () async {
                  final int? result = await SBDialog.showTyped(
                    context: context,
                    type: DialogType.setTimeLength,
                    initialValue: settingManager.restLength,
                    maxValue: 60,
                    minValue: 5,
                    padding: EdgeInsets.zero,
                  );

                  if (result != null) settingManager.setRestLength(result);
                },
              );
            },
          ),
          _buildDivider(8),

          /// 종소리 설정
          const SettingCategory(title: '종소리 설정'),
          Selector<SettingManager, String>(
            selector: (_, state) => state.classBellName,
            builder: (_, name, __) {
              return SettingItem(
                title: '수업 시작 종',
                attribute: name,
                isDisabled: isCounting,
                onTap: () async {
                  final result = await SBDialog.showTyped(
                    context: context,
                    type: DialogType.setBellSound,
                    initialValue: settingManager.classBell,
                    additional: settingManager.customClassBell,
                    padding: EdgeInsets.zero,
                  );

                  BellSoundPlayer.instance.stopPlaying();

                  if (result != null) settingManager.setClassBell(result);
                },
              );
            },
          ),
          Selector<SettingManager, String>(
            selector: (_, state) => state.restBellName,
            builder: (_, name, __) {
              return SettingItem(
                title: '수업 종료 종',
                attribute: name,
                isDisabled: isCounting,
                onTap: () async {
                  final result = await SBDialog.showTyped(
                    context: context,
                    type: DialogType.setBellSound,
                    initialValue: settingManager.restBell,
                    additional: settingManager.customRestBell,
                    padding: EdgeInsets.zero,
                  );

                  BellSoundPlayer.instance.stopPlaying();

                  if (result != null) settingManager.setRestBell(result);
                },
              );
            },
          ),
          _buildDivider(8),

          /// 서비스 정보
          const SettingCategory(title: '서비스 정보'),
          Consumer<AppUpdateChecker>(
            builder: (_, checker, __) {
              return AppVersionItem(
                isUpdateAvailable: checker.isUpdateAvailable,
                onTap: () async {
                  if (checker.isUpdateAvailable) {
                    SBDialog.showText(
                      context: context,
                      title: '업데이트가 가능합니다',
                      content: '어플의 새 버전이 출시되었어요.\n지금 바로 업데이트 하러 가시겠어요?',
                      positive: '스토어 가기',
                      negative: '나중에',
                      onPositive: (dialogContext) {
                        StoreRedirect.redirect();
                        Navigator.of(dialogContext).pop();
                      },
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: '현재 최신 버전이에요.',
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                },
              );
            },
          ),
          SettingItem(
            title: '오픈소스 라이선스',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const LicensesScreen(),
                ),
              );
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
