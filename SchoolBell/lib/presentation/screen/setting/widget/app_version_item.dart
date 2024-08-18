import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionItem extends StatelessWidget {
  final VoidCallback onTap;
  final bool isUpdateAvailable;

  const AppVersionItem({
    super.key,
    required this.onTap,
    required this.isUpdateAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            Text(
              '어플리케이션 버전',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Spacer(),
            Visibility(
              visible: isUpdateAvailable,
              child: Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.only(right: 4, bottom: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final String versionName = snapshot.data?.version ?? '';
                return Text(
                  versionName,
                  style: Theme.of(context).textTheme.bodyLarge,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
