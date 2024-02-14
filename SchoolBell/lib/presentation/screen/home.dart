import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/navigation/schoolbell_pages.dart';
import 'package:school_bell/presentation/schoolbell_colors.dart';
import 'package:school_bell/presentation/screens.dart';

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
  // TODO: state 다루는 방식 변경?
  late ClassManager classManager;

  bool _isCounting = false;

  int _selectedTab = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    classManager = Provider.of<ClassManager>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);

    return PopScope(
      canPop: !_isCounting,
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
            const ClassScreen(),
            const SettingsScreen(),
          ][_selectedTab],
        ),
        floatingActionButton: SizedBox(
          height: 72,
          width: 72,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                if (!_isCounting) {
                  startClass(context);
                } else {
                  stopClass(context);
                }
              },
              shape: const CircleBorder(),
              child: Icon(_isCounting ? Icons.notifications_off_outlined : Icons.notifications),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void startClass(BuildContext context) async {
    // TODO: SCHEDULE_EXACT_ALARM 권한 요청
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomDialog(
          dialogType: CustomDialogType.startClass,
          title: '오늘 수업은 몇 교시?',
          positive: '시작',
          negative: '취소',
        );
      },
    );
    if (result != null && result['returnValue'] > 0) {
      classManager.startClass(result['returnValue']);
    }
  }

  void stopClass(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          dialogType: CustomDialogType.endClass,
          title: '오늘 수업을 종료할까요?',
          content: classManager.currentState == CurrentState.inClass
              ? '아직 ${classManager.totalClass - classManager.currentClass + 1}교시 남아있어요!'
              : '아직 ${classManager.totalClass - classManager.currentClass}교시 남아있어요!',
          positive: '계속하기',
          negative: '수업 종료',
        );
      },
    );
    if (result['returnValue'] == -1) {
      classManager.stopClass();
    }
  }
}
