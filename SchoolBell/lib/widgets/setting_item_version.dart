import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:in_app_update/in_app_update.dart';

class SettingItemVersion extends StatefulWidget {
  final Function onTap;

  const SettingItemVersion({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SettingItemVersion> createState() => _SettingItemVersionState();
}

class _SettingItemVersionState extends State<SettingItemVersion> {
  final String title = '어플리케이션 버전';
  bool isUpdateAvailable = false;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        isUpdateAvailable =
            info.updateAvailability == UpdateAvailability.updateAvailable;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

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
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const Spacer(),
                  Visibility(
                    child: Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 8.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                    visible: isUpdateAvailable,
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
