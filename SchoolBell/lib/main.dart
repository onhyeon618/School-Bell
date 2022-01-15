import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/models.dart';
import 'navigation/app_router.dart';
import 'schoolbell_theme.dart';

void main() {
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

  late AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      classManager: _classManager,
    );
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
