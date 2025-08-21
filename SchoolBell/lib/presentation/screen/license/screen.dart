import 'package:flutter/material.dart';
import 'package:school_bell/oss_licenses.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/presentation/screen/license/detail_screen.dart';

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오픈소스 라이선스')),
      body: ListView.separated(
        itemCount: allDependencies.length,
        itemBuilder: (context, index) {
          final dependency = allDependencies[index];
          return ListTile(
            title: Text('${dependency.name} ${dependency.version}', style: SchoolBellTheme.mainTextTheme.bodySmall),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => LicenseDetail(package: dependency)));
            },
          );
        },
        separatorBuilder: (_, __) => const Divider(),
      ),
    );
  }
}
