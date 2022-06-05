import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:score_counter/main.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/model/stateManager.dart';
import 'package:score_counter/view/testListPage.dart';
import 'package:score_counter/view/settingPage.dart';

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          HomePagePush(context, '採点リスト', const TestListPage()),
          HomePagePush(context, '設定', const SettingPage()),
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
            ],
          ),
        );
}

class InfoCard extends Card {
  InfoCard(BuildContext context, WidgetRef ref, String _title, String _num)
      : super(
          child: Container(
            // width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(_title),
                Text(_num),
              ],
            ),
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
