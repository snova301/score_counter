import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends ConsumerState<AboutPage> {
  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          _LinkCard(context, '利用規約',
              'https://snova301.github.io/AppService/common/terms.html'),
          _LinkCard(context, 'プライバイシーポリシー',
              'https://snova301.github.io/AppService/common/privacypolicy.html'),
        ],
      ),
    );
  }
}

class _LinkCard extends Card {
  _LinkCard(BuildContext context, String urlTitle, String urlName)
      : super(
          child: ListTile(
            title: Text(urlTitle),
            subtitle: Text('タップすると、' + urlTitle + 'のwebページへ移動します。'),
            contentPadding: const EdgeInsets.all(10),
            onTap: () => _launchUrl(urlName),
            trailing: const Icon(Icons.open_in_browser),
          ),
        );
}

void _launchUrl(urlname) async {
  final Uri _url = Uri.parse(urlname);
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication))
    throw 'Could not launch $_url';
}
