import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/navigation/app_state_manager.dart';
import 'package:school_bell/navigation/schoolbell_pages.dart';
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
  late ClassManager classManager;
  late bool _isCounting;
  late int _selectedTab;

  static List<Widget> pages = <Widget>[
    const ClassScreen(),
    const SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    classManager = Provider.of<ClassManager>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _isCounting = context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    _selectedTab = context.select<AppStateManager, int>((AppStateManager am) => am.selectedTab);
    return WillPopScope(
      onWillPop: () async {
        if (_selectedTab == 1) {
          context.read<AppStateManager>().goToClassTab();
        } else {
          // TODO: 해당 코드 필요 여부 확인 - 버전 이슈로 디펜던시 제거한 상태
          // MoveToBackground.moveTaskToBack();
        }
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: _selectedTab,
            children: pages,
          ),
        ),
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    context.read<AppStateManager>().goToClassTab();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.access_time),
                  ),
                ),
              ),
              const SizedBox(width: 40), // 40 == FAB diameter
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    context.read<AppStateManager>().goToSettingTab();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.settings),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: fabIcon(),
          onPressed: () async {
            if (!_isCounting) {
              startClass(context);
            } else {
              stopClass(context);
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget fabIcon() {
    if (!_isCounting) {
      return const Icon(Icons.notifications);
    } else {
      return const Icon(Icons.notifications_off_outlined);
    }
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
