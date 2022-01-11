import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/models.dart';

import 'counting_screen.dart';
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
    CountingScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (context, appStateManager, child) {
        return Scaffold(
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: pages,
          ),
          extendBody: true,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    icon: const Icon(Icons.access_time),
                    color: const Color.fromRGBO(255, 193, 7, 1),
                    onPressed: () {
                      _tabController.animateTo(0);
                    }),
                const SizedBox(width: 40), // 40 == FAB diameter
                IconButton(
                    icon: const Icon(Icons.settings),
                    color: const Color.fromRGBO(255, 193, 7, 1),
                    onPressed: () {
                      _tabController.animateTo(1);
                    }),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(255, 193, 7, 1),
              child: Icon(Icons.notifications),
              onPressed: () {
                Fluttertoast.showToast(
                  msg: "FAB pressed",
                );
              }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }
}
