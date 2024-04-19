import 'package:flutter/material.dart';
import 'package:school_bell/navigation/schoolbell_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class LicenseDetail extends StatelessWidget {
  static MaterialPage page({
    Key? key,
    required String name,
    required Map<String, dynamic> json,
  }) {
    return MaterialPage(
      name: SchoolbellPages.licenseDetailPath,
      key: ValueKey(SchoolbellPages.licenseDetailPath),
      child: LicenseDetail(
        name: name,
        json: json,
      ),
    );
  }

  final String name;
  final Map<String, dynamic> json;

  const LicenseDetail({
    super.key,
    required this.name,
    required this.json,
  });

  String _parseLicenseText(String? text) {
    if (text == null) return '';

    return text.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      line = line.trim();
      return line;
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final String version = json['version'] ?? '';
    final String? description = json['description'];
    final String? licenseText = json['license'];
    final String? homepage = json['homepage'];

    return Scaffold(
      appBar: AppBar(title: Text('$name $version')),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
          child: Column(
            children: [
              if (description != null) ...[
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
              ],
              if (homepage != null) ...[
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () => launchUrl(Uri.parse(homepage)),
                  child: Text(
                    homepage,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (description != null || homepage != null) const Divider(),
              Text(
                _parseLicenseText(licenseText),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
