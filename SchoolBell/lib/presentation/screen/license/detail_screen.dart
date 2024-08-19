import 'package:flutter/material.dart';
import 'package:school_bell/oss_licenses.dart';
import 'package:url_launcher/url_launcher.dart';

class LicenseDetail extends StatelessWidget {
  final Package package;

  const LicenseDetail({
    super.key,
    required this.package,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${package.name} ${package.version}')),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                if (package.homepage != null) ...[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async => launchUrl(Uri.parse(package.homepage!)),
                    child: Text(
                      package.homepage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (package.license != null) ...[
                  const Divider(),
                  Text(
                    package.license!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
