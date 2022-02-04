import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:move_to_background/move_to_background.dart';

import '../models/models.dart';
import 'screens.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ClassManager classManager;

  late AndroidNotificationDetails _androidPlatformChannelSpecifics;
  late NotificationDetails _platformChannelSpecifics;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    classManager = Provider.of<ClassManager>(context, listen: false);
    classManager.initialize();

    _androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'school-bell-channel',
      'school-bell-channel',
      channelDescription: 'notification channel for school bell app',
      importance: Importance.low,
      priority: Priority.low,
      playSound: false,
      enableVibration: false,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
    );
    _platformChannelSpecifics =
        NotificationDetails(android: _androidPlatformChannelSpecifics);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  static List<Widget> pages = <Widget>[
    ClassScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: pages,
          ),
        ),
        extendBody: true,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () {
                    _tabController.animateTo(0);
                  }),
              const SizedBox(width: 40), // 40 == FAB diameter
              IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    _tabController.animateTo(1);
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Provider.of<ClassManager>(context).isCounting
              ? Icons.notifications_off_outlined
              : Icons.notifications),
          onPressed: () async {
            if (!classManager.isCounting) {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const CustomDialog(
                      dialogType: CustomDialogType.startClass,
                      title: '오늘 수업은 몇 교시?',
                      positive: '시작',
                      negative: '취소',
                    );
                  });
              if (result != null && result > 0) {
                await flutterLocalNotificationsPlugin.show(
                  Random().nextInt(pow(2, 31) as int),
                  null,
                  '열심히 수업 중~! 오늘도 힘내봐요!',
                  _platformChannelSpecifics,
                );
                classManager.startClass(result);
              }
            } else {
              var result = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      dialogType: CustomDialogType.endClass,
                      title: '오늘 수업을 종료할까요?',
                      content:
                          '아직 ${classManager.totalClass - classManager.currentClass + 1}교시 남아있어요!',
                      positive: '계속하기',
                      negative: '수업 종료',
                    );
                  });
              if (result == -1) {
                await flutterLocalNotificationsPlugin.cancelAll();
                classManager.stopClass();
              }
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
