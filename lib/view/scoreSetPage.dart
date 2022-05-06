import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/main.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/view/myHomePage.dart';

class ScoreSetPage extends ConsumerWidget {
  const ScoreSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _questionList = InitListClass().sSelectQList(ref);
    final _scoreInfo = RunClassScoreSet().sumScore(ref)['Correct'].toString() +
        '  /  ' +
        RunClassScoreSet().sumScore(ref)['Total'].toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('採点中'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InfoCard(context, ref, '問題数', _questionList.length.toString()),
              InfoCard(context, ref, '得点  /  全体点', _scoreInfo),
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
        ],
      ),
    );
  }
}

class _QuestionCard extends Card {
  _QuestionCard(
      BuildContext context, WidgetRef ref, List _questionList, int _index)
      : super(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: Text(_questionList[_index]),
                ),
              ),
              Card(
                color: ref.watch(scoreListProvider)[_index]
                    ? Colors.red
                    : Colors.grey,
                child: IconButton(
                  padding: const EdgeInsets.all(10),
                  icon: const Icon(Icons.check_circle_outline),
                  color: Colors.white,
                  onPressed: () {
                    RunClassScoreSet()
                        .scoreSetRun(ref, _questionList, _index, true);
                  },
                ),
              ),
              Card(
                color: ref.watch(scoreListProvider)[_index]
                    ? Colors.grey
                    : Colors.blue,
                child: IconButton(
                  padding: const EdgeInsets.all(10),
                  icon: const Icon(Icons.clear_rounded),
                  color: Colors.white,
                  onPressed: () {
                    RunClassScoreSet()
                        .scoreSetRun(ref, _questionList, _index, false);
                  },
                ),
              ),
            ],
          ),
        );
}
