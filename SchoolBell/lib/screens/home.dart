import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:move_to_background/move_to_background.dart';

import '../models/models.dart';
import 'screens.dart';

class Home extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: SchoolbellPages.home,
      key: ValueKey(SchoolbellPages.home),
      child: const Home(),
    );
  }

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ClassManager classManager;
  late bool _isCounting;
  late int _selectedTab;

  static List<Widget> pages = <Widget>[
    ClassScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    classManager = Provider.of<ClassManager>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    _isCounting =
        context.select<ClassManager, bool>((ClassManager cm) => cm.isCounting);
    _selectedTab = context
        .select<AppStateManager, int>((AppStateManager am) => am.selectedTab);
    return WillPopScope(
      onWillPop: () async {
        if (_selectedTab == 1) {
          context.read<AppStateManager>().goToClassTab();
        } else {
          MoveToBackground.moveTaskToBack();
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
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomDialog(
            dialogType: CustomDialogType.startClass,
            title: '?????? ????????? ??? ???????',
            positive: '??????',
            negative: '??????',
          );
        });
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
            title: '?????? ????????? ????????????????',
            content: classManager.currentState == CurrentState.inClass
                ? '?????? ${classManager.totalClass - classManager.currentClass + 1}?????? ???????????????!'
                : '?????? ${classManager.totalClass - classManager.currentClass}?????? ???????????????!',
            positive: '????????????',
            negative: '?????? ??????',
          );
        });
    if (result['returnValue'] == -1) {
      classManager.stopClass();
    }
  }
}
