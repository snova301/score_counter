import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/view/memberSetPage.dart';
import 'package:score_counter/main.dart';
import 'package:score_counter/view/myHomePage.dart';

class QuestionSetPage extends ConsumerStatefulWidget {
  const QuestionSetPage({Key? key}) : super(key: key);

  @override
  QuestionSetPageState createState() => QuestionSetPageState();
}

class QuestionSetPageState extends ConsumerState<QuestionSetPage> {
  /// 前回までのリストをクリアし、重複を防ぐ
  @override
  void initState() {
    super.initState();
    ref.read(questionListProvider).clear();
    ref.read(pointListProvider).clear();
  }

  @override
  Widget build(BuildContext context) {
    final _questionList = InitListClass().qSelectQList(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設問設定'),
      ),
      drawer: DrawerMenu(context),
      body: Column(
        children: [
          const Text('設問は100問まで設定できます。'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InfoCard(context, ref, '問題数', _questionList.length.toString()),
              InfoCard(context, ref, '合計配点', RunClass().sumPoint(ref)),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _questionList.length,
              itemBuilder: (context, index) {
                return _QuestionCard(context, ref, _questionList, index);
              },
            ),
          ),
          _SaveButton(context, ref)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '設問追加',
        child: const Icon(Icons.add),
        onPressed: () {
          ref.read(isUpdateQuestionProvider)
              ? RunClass().updateAddQuestion(ref)
              : RunClass().addQuestion(ref);
        },
      ),
    );
  }
}

class _QuestionCard extends Card {
  _QuestionCard(
      BuildContext context, WidgetRef ref, List _questionList, int _index)
      : super(
          child: ListTile(
            title: Text(_questionList[_index]),
            contentPadding: const EdgeInsets.all(8),
            // subtitle: Text(_questionList[_index]),
            trailing: _QuestionCardPopup(context, ref, _questionList, _index),
          ),
        );
}

class _QuestionCardPopup extends PopupMenuButton<int> {
  _QuestionCardPopup(
      BuildContext context, WidgetRef ref, List _questionList, int _index)
      : super(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: const <Widget>[
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  Text(
                    ' 設問を削除',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (int val) {
            if (val == 0) {
              ref.read(isUpdateQuestionProvider)
                  ? RunClass().updateRemoveQuestion(ref, _questionList, _index)
                  : RunClass().removeQuestion(ref, _questionList, _index);
            }
          },
        );
}

class _SaveButton extends Align {
  _SaveButton(BuildContext context, WidgetRef ref)
      : super(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: ref.read(isUpdateQuestionProvider)
                  ? const Text('保存してメンバー設定へ')
                  : const Text('メンバー設定へ'),
              onPressed: () {
                ref.read(isMemberSetModeProvider.state).state = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MemberSetPage()),
                );
              },
            ),
          ),
        );
}
