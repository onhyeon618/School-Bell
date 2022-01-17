import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingItemVersion extends StatelessWidget {
  final String title = '어플리케이션 버전';
  final Function onTap;

  const SettingItemVersion({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String versionName = snapshot.data?.version ?? '';
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Text(
                    versionName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ));
        } else {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline5,
            ),
          );
        }
      },
    );
  }
}
