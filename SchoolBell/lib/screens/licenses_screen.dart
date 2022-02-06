import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../oss_licenses.dart';

class LicensesScreen extends StatelessWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: SchoolbellPages.licensesPath,
      key: ValueKey(SchoolbellPages.licensesPath),
      child: const LicensesScreen(),
    );
  }

  const LicensesScreen({Key? key}) : super(key: key);

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
                  padding: const EdgeInsets.all(0),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final key = snapshot.data![index];
                    final licenseJson = ossLicenses[key];
                    final version = licenseJson['version'];
                    final desc = licenseJson['description'];
                    return ListTile(
                        title: Text('$key ${version ?? ''}'),
                        subtitle: desc != null ? Text(desc) : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Provider.of<AppStateManager>(context, listen: false)
                              .openLicenseDetail(key, licenseJson);
                        });
                  },
                  separatorBuilder: (context, index) => const Divider());
            }));
  }
}
