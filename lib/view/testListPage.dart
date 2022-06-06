import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:score_counter/main.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/view/MemberSetPage.dart';
import 'package:score_counter/view/createPage.dart';
import 'package:score_counter/view/myHomePage.dart';
import 'package:score_counter/view/questionSetPage.dart';

class TestListPage extends ConsumerWidget {
  const TestListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _testList = InitListClass().testPageTestlist(ref);
    final _maxNumOfTest = 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('テストリスト'),
      ),

      /// drawer
      drawer: DrawerMenu(context),
      body: Column(
        children: [
          Text('テストの数は$_maxNumOfTestまで'),
          InfoCard('テスト数', '${_testList.length}  /  $_maxNumOfTest'),

          /// テストのリストを表示
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _testList.length,
              itemBuilder: (context, index) {
                return _TestCard(context, ref, _testList, index);
              },
            ),
          ),
        ],
      ),

      /// 追加ボタン
      floatingActionButton: FloatingActionButton(
        tooltip: 'テスト追加',
        child: const Icon(Icons.add),
        onPressed: () {
          /// テストの数を制限
          _testList.length < _maxNumOfTest
              ? Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CreatePage()))
              : showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _addActionPopup(context, _maxNumOfTest);
                  },
                );
        },
      ),
    );
  }
}

class _TestCard extends Card {
  _TestCard(BuildContext context, WidgetRef ref, List _testList, int _index)
      : super(
          child: ListTile(
            title: Text(_testList[_index]),
            contentPadding: const EdgeInsets.all(8),
            // subtitle: Text(_testList[_index] + _index.toString()),
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
            trailing: _TestCardPopup(context, ref, _testList, _index),
          ),
        );
}

class _TestCardPopup extends PopupMenuButton<int> {
  _TestCardPopup(
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
            PopupMenuItem(
              value: 1,
              child: Row(
                children: const <Widget>[
                  Icon(Icons.people),
                  Text(' メンバー設定'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 2,
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
              ref.read(selectTestNameProvider.state).state = _testList[_index];
              ref.read(isMemberSetModeProvider.state).state = true;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemberSetPage(),
                ),
              );
            } else if (val == 2) {
              RunClassTestList().removeTestListCard(ref, _testList, _index);
            }
          },
        );
}

class _addActionPopup extends AlertDialog {
  _addActionPopup(BuildContext context, int _maxNumOfTest)
      : super(
          title: const Text('注意'),
          content: Text('テスト数は' + _maxNumOfTest.toString() + 'までです。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
}
