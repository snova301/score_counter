import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/main.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/view/MemberSetPage.dart';
import 'package:score_counter/view/myHomePage.dart';
import 'package:score_counter/view/questionSetPage.dart';

class TestListPage extends ConsumerWidget {
  const TestListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _testList = ref.watch(testListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('テストリスト'),
      ),
      drawer: DrawerMenu(context),
      body: Column(
        children: [
          InfoCard(context, ref, 'テスト数', _testList.length.toString()),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _testList.length,
              itemBuilder: (context, index) {
                return _QuestionCard(context, ref, _testList, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends Card {
  _QuestionCard(BuildContext context, WidgetRef ref, List _testList, int _index)
      : super(
          child: ListTile(
            title: Text(_testList[_index]),
            subtitle: Text(_testList[_index] + _index.toString()),
            onTap: () {
              ref.read(selectTestNameProvider.state).state = _testList[_index];
              ref.read(isMemberSetModeProvider.state).state = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemberSetPage(),
                ),
              );
            },
            trailing: _QuestionCardPopup(context, ref, _testList, _index),
          ),
        );
}

class _QuestionCardPopup extends PopupMenuButton<int> {
  _QuestionCardPopup(
      BuildContext context, WidgetRef ref, List _testList, int _index)
      : super(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: const <Widget>[
                  Icon(Icons.note_alt_outlined),
                  Text(' 設問設定'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: const <Widget>[
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  Text(
                    ' テストを削除',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (int val) {
            if (val == 0) {
              ref.read(selectTestNameProvider.state).state = _testList[_index];
              ref.read(isUpdateQuestionProvider.state).state = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuestionSetPage(),
                ),
              );
            } else if (val == 1) {
              RunClass().removeTestListCard(ref, _testList, _index);
            }
          },
        );
}
