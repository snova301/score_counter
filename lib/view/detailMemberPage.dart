import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/view/pointSetPage.dart';
import 'package:score_counter/main.dart';

class DetailMemberPage extends ConsumerWidget {
  const DetailMemberPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _memberList = ref.watch(memberListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メンバー登録'),
      ),
      body: Column(
        children: [
          const Text("👇ここからリスト👇"),
          _InfoCard(context, ref, '点数 / 配点 = '),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _memberList.length,
              itemBuilder: (context, index) {
                return _MemberCard(context, ref, _memberList, index);
              },
            ),
          ),
          _SaveButton(context, ref),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _memberList.add('NEW MEMBER  /  ' + Random().nextInt(100).toString());
          ref.read(memberListProvider.state).state = [..._memberList];
        },
        tooltip: 'メンバー追加',
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// _Infocard shows point information.
/// This is a private class.
class _InfoCard extends Card {
  _InfoCard(BuildContext context, WidgetRef ref, _title)
      : super(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(_title),
                Text('タップすると、' + _title + 'webページへ移動します。'),
              ],
            ),
          ),
        );
}

class _MemberCard extends Card {
  _MemberCard(BuildContext context, WidgetRef ref, List _memberList, int _index)
      : super(
          child: ListTile(
            title: Text(_memberList[_index]),
            subtitle: Text(_memberList[_index] + 'と' + _index.toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PointSetPage()),
              );
            },
            onLongPress: () {
              _memberList.removeAt(_index);
              ref.read(memberListProvider.state).state = [..._memberList];
            },
            trailing: const Icon(Icons.open_in_browser),
          ),
        );
}

class _SaveButton extends Align {
  _SaveButton(BuildContext context, WidgetRef ref)
      : super(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('保存しました'),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK', textAlign: TextAlign.center),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('保存'),
            ),
          ),
        );
}
