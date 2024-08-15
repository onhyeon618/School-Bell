import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:school_bell/oss_licenses.dart';
import 'package:school_bell/presentation/schoolbell_theme.dart';
import 'package:school_bell/presentation/screen/license/detail_screen.dart';

class LicensesScreen extends StatelessWidget {
  const LicensesScreen({super.key});

  // TODO: 로직 확인
  static Future<List<String>> loadLicenses() async {
    final ossKeys = ossLicenses.keys.toList();
    final lm = <String, List<String>>{};
    await for (var l in LicenseRegistry.licenses) {
      for (var p in l.packages) {
        if (!ossKeys.contains(p)) {
          final lp = lm.putIfAbsent(p, () => []);
          lp.addAll(l.paragraphs.map((p) => p.text));
          ossKeys.add(p);
        }
      }
    }
    for (var key in lm.keys) {
      ossLicenses[key] = {'license': lm[key]?.join('\n')};
    }
    return ossKeys..sort();
  }

  static final _licenses = loadLicenses();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('오픈소스 라이선스'),
      ),
      body: FutureBuilder<List<String>>(
        future: _licenses,
        builder: (context, snapshot) {
          return ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final key = snapshot.data![index];
              final licenseJson = ossLicenses[key];
              final version = licenseJson['version'];
              return ListTile(
                title: Text(
                  '$key ${version ?? ''}',
                  style: SchoolBellTheme.mainTextTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LicenseDetail(
                        name: key,
                        json: licenseJson,
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
        },
      ),
    );
  }
}
