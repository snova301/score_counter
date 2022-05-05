import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/model/stateManager.dart';
import 'package:score_counter/view/aboutPage.dart';
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
        padding: const EdgeInsets.all(10),
        children: <Widget>[
          _DarkmodeCard(context, ref),
          _CacheClearCard(context, ref),
          _toAboutPage(context, ref),
        ],
      ),
    );
  }
}

class _DarkmodeCard extends Card {
  _DarkmodeCard(BuildContext context, WidgetRef ref)
      : super(
          child: SwitchListTile(
            title: const Text('ダークモード'),
            value: ref.watch(darkmodeProvider),
            contentPadding: EdgeInsets.all(10),
            secondary: const Icon(Icons.dark_mode_outlined),
            onChanged: (bool value) {
              ref.read(darkmodeProvider.state).state = value;
              StateManagerClass().setDarkmodeVal(ref);
            },
          ),
        );
}

class _CacheClearCard extends Card {
  _CacheClearCard(BuildContext context, WidgetRef ref)
      : super(
          child: ListTile(
            title: const Text('採点データを削除'),
            textColor: Colors.red,
            iconColor: Colors.red,
            contentPadding: EdgeInsets.all(10),
            leading: const Icon(Icons.delete_outline),
            onTap: () {
              /// shared_prefのデータを削除
              StateManagerClass().removeTestModel(ref);

              /// Listデータの削除
              ref.read(testDataStoreProvider).clear();
              ref.read(testListProvider).clear();
            },
          ),
        );
}

class _toAboutPage extends Card {
  _toAboutPage(BuildContext context, WidgetRef ref)
      : super(
          child: ListTile(
            title: const Text('About'),
            contentPadding: EdgeInsets.all(10),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
        );
}
