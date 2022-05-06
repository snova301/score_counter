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
    final _maxNumOfQuestion = 100;
    final _pointController = TextEditingController(text: '1');

    return Scaffold(
      appBar: AppBar(
        title: const Text('設問設定'),
      ),
      drawer: DrawerMenu(context),
      body: Column(
        children: [
          Text('設問は' + _maxNumOfQuestion.toString() + '問まで設定できます。'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InfoCard(context, ref, '問題数', _questionList.length.toString()),
              InfoCard(
                  context, ref, '合計配点', RunClassQuestionSet().sumPoint(ref)),
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
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => _addAction(
                  context, ref, _maxNumOfQuestion, _pointController));
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
                  ? RunClassQuestionSet()
                      .updateRemoveQuestion(ref, _questionList, _index)
                  : RunClassQuestionSet()
                      .removeQuestion(ref, _questionList, _index);
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

class _addAction extends AlertDialog {
  _addAction(BuildContext context, WidgetRef ref, int _maxNumOfQuestion,
      TextEditingController _pointController)
      : super(
          title: const Text('新規質問の配点'),
          content: _TextFieldContainer(context, ref, _pointController),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                ref.read(isUpdateQuestionProvider)
                    ? RunClassQuestionSet().updateAddQuestion(ref,
                        _maxNumOfQuestion, int.parse(_pointController.text))
                    : RunClassQuestionSet().addQuestion(ref, _maxNumOfQuestion,
                        int.parse(_pointController.text));
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
}

class _TextFieldContainer extends Container {
  _TextFieldContainer(BuildContext context, WidgetRef ref,
      TextEditingController _pointController)
      : super(
          child: TextField(controller: _pointController),
        );
}
