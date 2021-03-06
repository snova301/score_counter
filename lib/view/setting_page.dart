import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:score_counter/model/state_manager.dart';

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
          _DataRemoveCard(context, ref),
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
            value: ref.watch(settingProvider)['darkmode'],
            contentPadding: const EdgeInsets.all(10),
            secondary: const Icon(Icons.dark_mode_outlined),
            onChanged: (bool value) {
              Map temp = ref.read(settingProvider);
              temp['darkmode'] = value;
              ref.read(settingProvider.state).state = {...temp};
              LocalSave().setPref(ref);
            },
          ),
        );
}

class _DataRemoveCard extends Card {
  _DataRemoveCard(BuildContext context, WidgetRef ref)
      : super(
          child: ListTile(
            title: const Text('採点データを削除'),
            textColor: Colors.red,
            iconColor: Colors.red,
            contentPadding: const EdgeInsets.all(10),
            leading: const Icon(Icons.delete_outline),
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      _DataRemoveDialog(context, ref));
            },
          ),
        );
}

class _DataRemoveDialog extends AlertDialog {
  _DataRemoveDialog(BuildContext context, WidgetRef ref)
      : super(
          title: const Text('注意'),
          content: const Text('すべての採点データが削除されます'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                /// providerのデータ削除
                ref.read(testDBProvider.notifier).deleteAll();
                ref.read(testMapProvider.notifier).deleteAll();
                ref.read(memberMapProvider.notifier).deleteAll();
                ref.read(questionMapProvider.notifier).deleteAll();

                /// shared_prefのデータを削除
                LocalSave().deleteData(ref);

                /// 戻る
                Navigator.pop(context);
              },
            ),
          ],
        );
}
