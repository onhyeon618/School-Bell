import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/enum/class_state.dart';
import 'package:school_bell/enum/dialog_type.dart';
import 'package:school_bell/navigation/schoolbell_pages.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/screens.dart';
import 'package:school_bell/presentation/widget/sb_dialog.dart';

class Home extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: SchoolbellPages.home,
      key: ValueKey(SchoolbellPages.home),
      child: const Home(),
    );
  }

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final classManager = context.watch<ClassManager>();
    final isCounting = classManager.currentState != ClassState.idle;

    return PopScope(
      canPop: !isCounting,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (_selectedTab == 1) {
          setState(() {
            _selectedTab = 0;
          });
        } else {
          // TODO: 백그라운드 전환
        }
      },
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          onDestinationSelected: (index) {
            setState(() {
              _selectedTab = index;
            });
          },
          height: 64.0,
          backgroundColor: Colors.white,
          elevation: 8.0,
          shadowColor: SchoolBellColor.colorMain,
          surfaceTintColor: SchoolBellColor.colorSub,
          indicatorColor: Colors.transparent,
          selectedIndex: _selectedTab,
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
          ][_selectedTab],
        ),
        floatingActionButton: SizedBox(
          height: 72,
          width: 72,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                if (!isCounting) {
                  startClass(context);
                } else {
                  stopClass(context);
                }
              },
              shape: const CircleBorder(),
              child: Icon(isCounting ? Icons.notifications_off_outlined : Icons.notifications),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void startClass(BuildContext context) async {
    final permission = await checkPermission(context);
    if (!context.mounted) return;

    if (!permission) {
      // TODO: 일반 confirm 타입 다이얼로그 필요
      await SBDialog.showText(
        context: context,
        content: '권한이 없어 수업을 설정할 수 없습니다.',
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
    context.read<ClassManager>().startClass(result);
  }

  void stopClass(BuildContext context) async {
    SBDialog.showText(
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
    final status = await Permission.scheduleExactAlarm.status;
    if (!context.mounted) return false;

    if (status.isGranted) return true;

    final result = await SBDialog.showText(
      context: context,
      content: "수업종을 설정하려면 '알람 및 리마인더' 권한이 필요합니다.",
      positive: '허용하기',
      onPositive: (dialogContext) async {
        final result = await Permission.scheduleExactAlarm.request();
        if (dialogContext.mounted) Navigator.of(dialogContext).pop(result.isGranted);
      },
    );
    return result ?? false;
  }
}
