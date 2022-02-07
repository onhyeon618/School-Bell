import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_bell/schoolbell_colors.dart';
import '../models/models.dart';

class SplashScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: SchoolbellPages.splashPath,
      key: ValueKey(SchoolbellPages.splashPath),
      child: const SplashScreen(),
    );
  }

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<AppStateManager>(context, listen: false).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 5.0,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(SchoolBellColor.colorMain),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              "학교 가는 중...",
              style: Theme.of(context).textTheme.headline5,
            ),
          ],
        ),
      ),
    );
  }
}
