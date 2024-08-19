import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/channel/move_task_back.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:school_bell/enum/dialog_type.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/screens.dart';
import 'package:school_bell/presentation/widget/sb_dialog.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final classManager = context.watch<ClassManager>();
    final isCounting = classManager.currentState != ClassState.idle;

    return PopScope(
      canPop: !isCounting && selectedTab == 0,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (selectedTab == 1) {
          setState(() {
            selectedTab = 0;
          });
        } else {
          unawaited(MoveTaskBack.moveTaskToBack());
        }
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          height: 64.0,
          backgroundColor: Colors.white,
          elevation: 8.0,
          shadowColor: SchoolBellColor.colorMain,
          surfaceTintColor: SchoolBellColor.colorSub,
          indicatorColor: Colors.transparent,
          selectedIndex: selectedTab,
          destinations: const [
            Padding(
              padding: EdgeInsets.only(right: 36.0),
              child: NavigationDestination(
                selectedIcon: Icon(
                  Icons.access_time,
                  color: SchoolBellColor.colorMain,
                  size: 32,
                ),
                icon: Icon(
                  Icons.access_time,
                  color: SchoolBellColor.colorDarkGray,
                  size: 32,
                ),
                label: '홈',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 36.0),
              child: NavigationDestination(
                selectedIcon: Icon(
                  Icons.settings,
                  color: SchoolBellColor.colorMain,
                  size: 32,
                ),
                icon: Icon(
                  Icons.settings,
                  color: SchoolBellColor.colorDarkGray,
                  size: 32,
                ),
                label: '설정',
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: [
            ClassScreen(
              currentState: classManager.currentState,
              currentPeriod: classManager.currentPeriod,
            ),
            const SettingsScreen(),
          ][selectedTab],
        ),
        floatingActionButton: SizedBox(
          height: 72,
          width: 72,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () async {
                if (!isCounting) {
                  await startClass(context);
                } else {
                  await stopClass(context);
                }
              },
              shape: const CircleBorder(),
              child: Icon(isCounting ? Icons.notifications_off_outlined : Icons.notifications),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        resizeToAvoidBottomInset: false,
      ),
    );
  }

  Future<void> startClass(BuildContext context) async {
    final permission = await checkPermission(context);
    if (!context.mounted) return;

    if (!permission) {
      await SBDialog.showConfirm(
        context: context,
        content: '권한이 없어 수업을 시작할 수 없습니다.',
      );
      return;
    }

    final int? result = await SBDialog.showTyped(
      title: '오늘 수업은 몇 교시?',
      context: context,
      type: DialogType.setClassSize,
      initialValue: 1,
    );
    if (!context.mounted || result == null) return;
    await context.read<ClassManager>().startClass(result);
  }

  Future<void> stopClass(BuildContext context) async {
    await SBDialog.showText(
      context: context,
      title: '오늘 수업을 종료할까요?',
      content: '아직 ${context.read<ClassManager>().remainingPeriod}교시 남아있어요!',
      positive: '계속하기',
      negative: '수업 종료',
      onNegative: (dialogContext) {
        context.read<ClassManager>().stopClass();
        Navigator.of(dialogContext).pop();
      },
    );
  }

  Future<bool> checkPermission(BuildContext context) async {
    final isGranted = await Permission.notification.isGranted &&
        await Permission.scheduleExactAlarm.isGranted &&
        await Permission.ignoreBatteryOptimizations.isGranted;
    if (isGranted) return true;

    if (!context.mounted) return false;

    final result = await SBDialog.showText(
      context: context,
      title: '권한이 필요합니다',
      content: '알림: 앱 실행 상태 표시\n알람 및 리마인더: 종소리 재생\n배터리 최적화 제외: 정확한 시각에 동작',
      positive: '허용하기',
      onPositive: (dialogContext) async {
        // 순차적으로 진행, 하나라도 거부할 경우 요청 프로세스 종료
        final notification = await Permission.notification.request();
        if (!dialogContext.mounted) return;
        if (!notification.isGranted) {
          Navigator.of(dialogContext).pop(false);
          return;
        }

        final alarm = await Permission.scheduleExactAlarm.request();
        if (!dialogContext.mounted) return;
        if (!alarm.isGranted) {
          Navigator.of(dialogContext).pop(false);
          return;
        }

        final battery = await Permission.ignoreBatteryOptimizations.request();
        if (!dialogContext.mounted) return;
        Navigator.of(dialogContext).pop(battery.isGranted);
      },
    );
    return result ?? false;
  }
}
