import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:score_counter/src/view/about_page.dart';
import 'package:score_counter/src/view/my_homepage.dart';
import 'package:score_counter/src/view/setting_page.dart';
import 'package:score_counter/src/view/test_list_page.dart';
import 'package:url_launcher/url_launcher.dart';

/// ドロワーのメニュー
class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
}

/// 情報カード
class InfoCard extends StatelessWidget {
  final String title;
  final String num;

  const InfoCard({
    Key? key,
    required this.title,
    required this.num,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
}

/// snackbarで注意喚起を行うWidget
class SnackBarAlert {
  final BuildContext context;
  SnackBarAlert({Key? key, required this.context}) : super();

  void snackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }
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

/// URLを開く
void openUrl(urlname) async {
  final Uri url = Uri.parse(urlname);
  try {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    throw 'Could not launch $url';
  }
  // if (!await launchUrl(url, mode: LaunchMode.externalApplication))
  //   throw 'Could not launch $url';
}
