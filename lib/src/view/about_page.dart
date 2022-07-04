import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/src/view/common.dart';

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
          _LinkCard(context, '使用方法',
              'https://snova301.github.io/AppService/score_counter/home.html#使い方'),
          _LinkCard(context, '利用規約',
              'https://snova301.github.io/AppService/common/terms.html'),
          _LinkCard(context, 'プライバイシーポリシー',
              'https://snova301.github.io/AppService/common/privacypolicy.html'),

          /// お問い合わせフォーム
          Card(
            child: ListTile(
              title: const Text('お問い合わせ'),
              contentPadding: const EdgeInsets.all(10),
              onTap: () => openUrl('https://forms.gle/yBGDikXqZzWjco7z8'),
              trailing: const Icon(Icons.open_in_browser),
            ),
          ),

          /// オープンソースライセンスの表示
          Card(
            child: ListTile(
              title: const Text('オープンソースライセンス'),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ),
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
            subtitle: Text('タップすると、$urlTitleのwebページへ移動します。'),
            contentPadding: const EdgeInsets.all(10),
            onTap: () => openUrl(urlName),
            trailing: const Icon(Icons.open_in_browser),
          ),
        );
}
