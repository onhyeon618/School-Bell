import 'dart:async';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/app_update_checker.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/domain/setting_manager.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/presentation/screen/home.dart';
import 'package:school_bell/service/alarm.dart';
import 'package:school_bell/service/foreground.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterForegroundTask.initCommunicationPort();
  ForegroundService.instance.initialize();

  AlarmService.instance.initializeIsolate();
  await AndroidAlarmManager.initialize();

  runApp(const SchoolBell());
}

class SchoolBell extends StatefulWidget {
  const SchoolBell({super.key});

  @override
  State<SchoolBell> createState() => _SchoolBellState();
}

class _SchoolBellState extends State<SchoolBell> {
  late final AppLifecycleListener listener;

  final classManager = ClassManager();
  final settingManager = SettingManager();
  final appUpdateChecker = AppUpdateChecker();

  @override
  void initState() {
    super.initState();

    listener = AppLifecycleListener(
      onResume: onResume,
    );

    unawaited(settingManager.initialize());
    unawaited(classManager.initialize());
    unawaited(appUpdateChecker.checkForUpdate());

    port.listen((_) async => await classManager.fetch());
  }

  void onResume() {
    unawaited(appUpdateChecker.checkForUpdate());
    unawaited(classManager.fetch());
  }

  @override
  void dispose() {
    listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = SchoolBellTheme.mainTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => classManager,
        ),
        ChangeNotifierProvider(
          create: (_) => settingManager,
        ),
        ChangeNotifierProvider(
          create: (_) => appUpdateChecker,
        ),
      ],
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: MaterialApp(
          title: 'SchoolBell',
          theme: theme,
          home: const Home(),
        ),
      ),
    );
  }
}
