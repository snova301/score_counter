import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:score_counter/view/test_list_page.dart';
import 'package:score_counter/view/setting_page.dart';
import 'package:score_counter/view/about_page.dart';

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
        title: const Text('採点カウンター SCCO (β)'),
      ),
      drawer: DrawerMenu(context),
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
                    child: Image.asset('images/image.png',
                        width: 100, height: 100),
                  ),
                ),
                HomePagePush(context, '採点リスト', const TestListPage()),
                HomePagePush(context, '設定', const SettingPage()),
                HomePagePush(context, 'About', const AboutPage()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: const Text(
              'ご利用は利用規約とプライバシーポリシーに同意したものとします。',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePagePush extends Align {
  HomePagePush(BuildContext context, String title, pagepush)
      : super(
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
              child: Text(title),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(20.0)),
              ),
            ),
          ),
        );
}

class DrawerMenu extends Drawer {
  DrawerMenu(BuildContext context)
      : super(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Text('メニュー'),
              ),
              ListTile(
                title: const Text('トップページ'),
                onTap: () {
                  AnalyticsService().logPage('トップページ');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('テストリスト'),
                onTap: () {
                  AnalyticsService().logPage('テストリスト');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TestListPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('設定'),
                onTap: () {
                  AnalyticsService().logPage('設定');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  AnalyticsService().logPage('About');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
}

class InfoCard extends Card {
  InfoCard(String title, String num)
      : super(
          elevation: 3,
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(),
                ),
                Text(
                  num,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        );
}

class SnackBarAlert extends SnackBar {
  SnackBarAlert(String title)
      : super(
          content: Text(title),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        );
}

class AnalyticsService {
  /// ページ遷移のログ
  Future<void> logPage(String screenName) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': screenName,
      },
    );
  }
}
