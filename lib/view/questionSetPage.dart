import 'package:flutter/cupertino.dart';
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
  @override
  void initState() {
    super.initState();

    /// 前回までのリストをクリアし、重複を防ぐ
    ref.read(questionListProvider).clear();
    ref.read(pointListProvider).clear();
  }

  @override
  Widget build(BuildContext context) {
    /// _questionListの作成
    final _questionList = InitListClass().qSelectQList(ref);

    /// 設問の最大数の決定
    final _maxNumOfQuestion = 100;

    /// picker用のリスト初期化
    List<int> _numsList =
        List.generate(_maxNumOfQuestion, (index) => index + 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設問設定'),
      ),
      // drawer: DrawerMenu(context),
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
          _SaveButton(context, ref),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '設問追加',
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) =>
                  _addAction(context, ref, _maxNumOfQuestion, _numsList));
          // context, ref, _maxNumOfQuestion, _pointController));
        },
      ),
    );
  }
}

/// _QuestionCardはCard Widgetをextendして作成
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
          child: ref.read(isUpdateQuestionProvider)
              ? null
              : Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    child: const Text('メンバー設定へ'),
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
      List _numsList)
      : super(
          title: const Text('新規質問の配点'),
          scrollable: true,
          content: _selectPointPicker(context, ref, _numsList),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                ref.read(isUpdateQuestionProvider)
                    ? RunClassQuestionSet()
                        .updateAddQuestion(ref, _maxNumOfQuestion)
                    : RunClassQuestionSet().addQuestion(ref, _maxNumOfQuestion);
                Navigator.pop(context);
              },
            ),
          ],
        );
}

/// 得点をpicker形式で選択できるようにする
class _selectPointPicker extends CupertinoPicker {
  _selectPointPicker(BuildContext context, WidgetRef ref, List _numsList)
      : super(
          itemExtent: 30,
          children: _numsList.map((num) => Text(num.toString())).toList(),
          onSelectedItemChanged: (index) {
            ref.read(selectPointProvider.state).state = _numsList[index];
          },
        );
}
