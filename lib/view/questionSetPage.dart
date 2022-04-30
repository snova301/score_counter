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
    ref.read(questionListProvider).clear();
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
          const Text("👇ここからリスト👇"),
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
            subtitle: Text(_questionList[_index]),
            trailing: const Icon(Icons.open_in_browser),
            onLongPress: () {
              ref.read(isUpdateQuestionProvider)
                  ? RunClass().updateRemoveQuestion(ref, _questionList, _index)
                  : RunClass().removeQuestion(ref, _questionList, _index);
            },
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
              child: const Text('メンバー設定へ'),
              onPressed: () {
                ref.read(isMemberSetModeProvider.state).state = true;
                ref.read(isUpdateQuestionProvider)
                    ? null
                    : RunClass().questionSetRun(ref);
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
