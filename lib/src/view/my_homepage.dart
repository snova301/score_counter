import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/src/view/common.dart';
import 'package:score_counter/src/view/test_list_page.dart';
import 'package:score_counter/src/view/setting_page.dart';
import 'package:score_counter/src/view/about_page.dart';

/// 最初のページ
class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('採点カウンター SCCO'),
      ),
      drawer: const DrawerMenu(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(30),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: Image.asset('assets/images/image.png',
                        width: 100, height: 100),
                  ),
                ),
                const _HomePagePush(title: '採点リスト', pagepush: TestListPage()),
                const _HomePagePush(title: '設定', pagepush: SettingPage()),
                const _HomePagePush(title: 'About', pagepush: AboutPage()),
              ],
            ),
          ),
          const _AgreementContainer()
        ],
      ),
    );
  }
}

/// ページのプッシュ
class _HomePagePush extends StatelessWidget {
  final String title;
  final dynamic pagepush;

  const _HomePagePush({
    Key? key,
    required this.title,
    required this.pagepush,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () {
            AnalyticsService().logPage(title);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => pagepush),
            );
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(const EdgeInsets.all(20.0)),
          ),
          child: Text(title),
        ),
      ),
    );
  }
}

/// 同意文のwidget
class _AgreementContainer extends ConsumerWidget {
  const _AgreementContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10),

      //  Container(
      //   padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'ご利用は',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              openUrl(
                  'https://snova301.github.io/AppService/common/terms.html');
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
            child: const Text(
              '利用規約',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.blue),
            ),
          ),
          const Text(
            'と',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
          TextButton(
            onPressed: () {
              openUrl(
                  'https://snova301.github.io/AppService/common/privacypolicy.html');
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all(Size.zero),
            ),
            child: const Text(
              'プライバシーポリシー',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.blue),
            ),
          ),
          const Text(
            'に同意したものとします。',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
