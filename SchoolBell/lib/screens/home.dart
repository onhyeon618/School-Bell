import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

import 'class_screen.dart';
import 'settings_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    classManager = Provider.of<ClassManager>(context, listen: false);

    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: pages,
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
        child: Icon(classManager.isCounting? Icons.notifications_off_outlined : Icons.notifications),
        onPressed: () => setState(() {
          // 원래는 다이얼로그를 띄워야 하는 부분이나,
          // 테스트를 위해 임의로 작동하도록 코드를 작성하였음

          if (!classManager.isCounting) {
            classManager.startClass(2);
          }
          else {
            classManager.stopClass();
          } }),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }
}
