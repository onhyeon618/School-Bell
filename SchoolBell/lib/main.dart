import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/domain/app_update_checker.dart';
import 'package:school_bell/domain/class_manager.dart';
import 'package:school_bell/domain/setting_manager.dart';
import 'package:school_bell/navigation/app_router.dart';
import 'package:school_bell/navigation/app_state_manager.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/service/alarm.dart';
import 'package:school_bell/service/notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AlarmService.instance.initializeIsolate();
  AndroidAlarmManager.initialize();

  await NotificationService.instance.initialize();

  runApp(const SchoolBell());
}

class SchoolBell extends StatefulWidget {
  const SchoolBell({super.key});

  @override
  State<SchoolBell> createState() => _SchoolBellState();
}

class _SchoolBellState extends State<SchoolBell> {
  late final AppLifecycleListener _listener;

  final _appStateManager = AppStateManager();
  final _classManager = ClassManager();
  final _settingManager = SettingManager();
  final _appUpdateChecker = AppUpdateChecker();

  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();

    _listener = AppLifecycleListener(
      onResume: _onResume,
    );

    _settingManager.initialize();
    _classManager.initialize();
    _appUpdateChecker.checkForUpdate();

    _appRouter = AppRouter(
      appStateManager: _appStateManager,
    );

    port.listen((_) async => await _classManager.fetch());
  }

  void _onResume() {
    _appUpdateChecker.checkForUpdate();
    _classManager.fetch();
  }

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
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
