import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingItemVersion extends StatelessWidget {
  final String title = '어플리케이션 버전';
  final Function onTap;
  final bool isUpdateAvailable;

  const SettingItemVersion({
    super.key,
    required this.onTap,
    required this.isUpdateAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: (context, AsyncSnapshot<PackageInfo> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          String versionName = snapshot.data?.version ?? '';
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => onTap(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Spacer(),
                  Visibility(
                    visible: isUpdateAvailable,
                    child: Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 8.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Text(
                    versionName,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        }
      },
    );
  }
}
