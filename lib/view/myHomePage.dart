import 'package:flutter/material.dart';
import 'aboutPage.dart';
import 'settingPage.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          HomePagePush(context, '新規作成', const AboutPage()),
          HomePagePush(context, '採点リスト', const AboutPage()),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pagepush),
                );
              },
              child: Text(title),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20.0)),
              ),
            ),
          ),
        );
}
