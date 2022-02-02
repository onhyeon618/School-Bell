import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/models.dart';
import 'navigation/app_router.dart';
import 'schoolbell_theme.dart';

const String isolateName = 'SchoolBellIsolate';

final ReceivePort port = ReceivePort();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AndroidAlarmManager.initialize();

  runApp(const SchoolBell());
}

class SchoolBell extends StatefulWidget {
  const SchoolBell({Key? key}) : super(key: key);

  @override
  _SchoolBellState createState() => _SchoolBellState();
}

class _SchoolBellState extends State<SchoolBell> {
  final _appStateManager = AppStateManager();
  final _classManager = ClassManager();
  final _settingManager = SettingManager();

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

    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      classManager: _classManager,
    );

    port.listen((_) async => await _changeMainImage());
  }

  Future<void> _changeMainImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
      ],
      child: MaterialApp(
        title: 'SchoolBell',
        theme: SchoolBellTheme.mainTheme(),
        home: Router(
          routerDelegate: _appRouter,
          backButtonDispatcher: RootBackButtonDispatcher(), // 물리버튼 처리
        ),
      ),
    );
  }
}
