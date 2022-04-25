import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '/main.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("設定"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: <Widget>[
          _DarkmodeCard(context, ref),
          _LinkCard(context, '使い方', 'https://snova301.hatenablog.com/'),
          _LinkCard(context, '利用規約', 'https://snova301.hatenablog.com/'),
          _LinkCard(context, 'プライバイシーポリシー', 'https://snova301.hatenablog.com/'),
        ],
      ),
    );
  }
}

class _DarkmodeCard extends Card {
  _DarkmodeCard(BuildContext context, ref)
      : super(
          child: SwitchListTile(
            title: const Text('ダークモード'),
            value: ref.watch(darkmodeProvider),
            onChanged: (bool value) {
              ref.read(darkmodeProvider.state).state = value;
            },
            secondary: const Icon(Icons.lightbulb_outline),
          ),
        );
}

class _LinkCard extends Card {
  _LinkCard(BuildContext context, urlTitle, urlName)
      : super(
          child: ListTile(
            title: Text(urlTitle),
            subtitle: Text('タップすると、' + urlTitle + 'のwebページへ移動します。'),
            onTap: () => _launchUrl(urlName),
            trailing: const Icon(Icons.open_in_browser),
          ),
        );
}

void _launchUrl(urlname) async {
  final Uri _url = Uri.parse(urlname);
  if (!await launchUrl(_url)) throw 'Could not launch $_url';
}
