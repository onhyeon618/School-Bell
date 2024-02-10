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

  String? get version => json['version'];

  String? get description => json['description'];

  String? get licenseText => json['license'];

  String? get homepage => json['homepage'];

  String? _bodyText() {
    return licenseText?.split('\n').map((line) {
      if (line.startsWith('//')) line = line.substring(2);
      line = line.trim();
      return line;
    }).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name ${version ?? ''}')),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: ListView(
          children: <Widget>[
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                child: Text(
                  description!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            if (homepage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                child: InkWell(
                  child: Text(
                    homepage!,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Colors.blue, decoration: TextDecoration.underline),
                  ),
                  onTap: () => launchUrl(Uri.parse(homepage!)),
                ),
              ),
            if (description != null || homepage != null) const Divider(),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
              child: Text(
                _bodyText() ?? '',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
