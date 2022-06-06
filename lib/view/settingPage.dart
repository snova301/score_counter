import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/model/stateManager.dart';
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
          _darkmodeCard(context, ref),
          _dataRemoveCard(context, ref),
        ],
      ),
    );
  }
}

class _darkmodeCard extends Card {
  _darkmodeCard(BuildContext context, WidgetRef ref)
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

class _dataRemoveCard extends Card {
  _dataRemoveCard(BuildContext context, WidgetRef ref)
      : super(
          child: ListTile(
            title: const Text('採点データを削除'),
            textColor: Colors.red,
            iconColor: Colors.red,
            contentPadding: EdgeInsets.all(10),
            leading: const Icon(Icons.delete_outline),
            onTap: () {
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      _dataRemoveDialog(context, ref));
            },
          ),
        );
}

class _dataRemoveDialog extends AlertDialog {
  _dataRemoveDialog(BuildContext context, WidgetRef ref)
      : super(
          title: const Text('注意'),
          content: const Text('すべての採点データが削除されます。\n(すでにエクスポートされたデータは削除されません。)'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                /// shared_prefのデータを削除
                StateManagerClass().removeTestModel(ref);

                /// Listデータの削除
                ref.read(testDataStoreProvider).clear();
                ref.read(testListProvider).clear();

                /// 戻る
                Navigator.pop(context);
              },
            ),
          ],
        );
}
