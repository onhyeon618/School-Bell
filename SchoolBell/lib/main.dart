import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/app_update_checker.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/domain/setting_manager.dart';
import 'package:school_bell/navigation/app_state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'navigation/app_router.dart';
import 'presentation/schoolbell_theme.dart';

late SharedPreferences prefs;

const String isolateName = 'SchoolBellIsolate';
final ReceivePort port = ReceivePort();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  AndroidAlarmManager.initialize();
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(android: AndroidInitializationSettings('sb_notice_icon')),
  );

  prefs = await SharedPreferences.getInstance();

  runApp(const SchoolBell());
}

class SchoolBell extends StatefulWidget {
  const SchoolBell({super.key});

  @override
  State<SchoolBell> createState() => _SchoolBellState();
}

class _SchoolBellState extends State<SchoolBell> {
  final _appStateManager = AppStateManager();
  final _classManager = ClassManager();
  final _settingManager = SettingManager();
  final _appUpdateChecker = AppUpdateChecker();

  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    if (IsolateNameServer.lookupPortByName(isolateName) != null) {
      IsolateNameServer.removePortNameMapping(isolateName);
    }
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      isolateName,
    );

    _settingManager.initialize();
    _classManager.initialize();
    _appUpdateChecker.checkForUpdate();

    _appRouter = AppRouter(
      appStateManager: _appStateManager,
    );

    port.listen((_) async => await _changeMainImage());
  }

  Future<void> _changeMainImage() async {
    await prefs.reload();
    final currentState = prefs.getInt('currentState');

    if (currentState == CurrentState.inClass) {
      _classManager.classTimeImage();
    } else if (currentState == CurrentState.restTime) {
      _classManager.restTimeImage();
    } else {
      _classManager.waitingTimeImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = SchoolBellTheme.mainTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _appStateManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _classManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _settingManager,
        ),
        ChangeNotifierProvider(
          create: (context) => _appUpdateChecker,
        ),
      ],
      child: MaterialApp(
        title: 'SchoolBell',
        theme: theme,
        home: Router(
          routerDelegate: _appRouter,
          backButtonDispatcher: RootBackButtonDispatcher(), // 물리버튼 처리
        ),
      ),
    );
  }
}
