import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:score_counter/model/stateManager.dart';
import 'package:score_counter/view/myHomePage.dart';

class ScoreSetPage extends ConsumerStatefulWidget {
  const ScoreSetPage({Key? key}) : super(key: key);

  @override
  ScoreSetPageState createState() => ScoreSetPageState();
}

class ScoreSetPageState extends ConsumerState<ScoreSetPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 初期化
    final questionMap = ref.watch(scoreSetMapProvider);
    final pointSum = ref.watch(scoreSetPointSumProvider);
    final scoreSum = ref.watch(scoreSetScoreSumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('採点中'),
      ),
      body: Column(
        children: [
          /// 情報
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InfoCard('問題数', questionMap.length.toString()),
              InfoCard('得点  /  全体点', '$scoreSum  /  $pointSum'),
            ],
          ),

          /// リスト
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: questionMap.length,
              itemBuilder: (context, index) {
                return _QuestionCard(context, ref, questionMap, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// questionCard
class _QuestionCard extends Card {
  _QuestionCard(BuildContext context, WidgetRef ref, Map questionMap, int index)
      : super(
          /// ListTileとRowの相性が悪いので、RowとColumnを使い自前で作成
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /// 設問名と配点表示
              Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                    // margin: const EdgeInsets.fromLTRB(10, 10, 0, 5),
                    child: Text(
                      questionMap.values.elementAt(index)['name'],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                    // margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                    child: Text(
                      '配点 : ${questionMap.values.elementAt(index)['point']}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  /// 正解ボタン
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          questionMap.values.elementAt(index)['score'] == true
                              ? Colors.red
                              : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(10),
                      icon: const Icon(
                        Icons.check_circle_outline,
                        // size: 30,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        /// データ取得
                        final testID =
                            ref.watch(selectStrMapProvider)['testID']!;
                        final memberID =
                            ref.watch(selectStrMapProvider)['memberID']!;
                        final questionID = questionMap.keys.elementAt(index);

                        /// DBに書込み
                        ref
                            .read(testDBProvider.notifier)
                            .updateScore(testID, memberID, questionID, true);

                        /// shared_preferencesに書き込み
                        LocalSave().setData(ref);
                      },
                    ),
                  ),

                  /// ミスボタン
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          questionMap.values.elementAt(index)['score'] == false
                              ? Colors.blue
                              : Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      padding: const EdgeInsets.all(10),
                      icon: const Icon(
                        Icons.clear_rounded,
                        // size: 30,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        /// データ取得
                        final testID =
                            ref.watch(selectStrMapProvider)['testID']!;
                        final memberID =
                            ref.watch(selectStrMapProvider)['memberID']!;
                        final questionID = questionMap.keys.elementAt(index);

                        /// DBに書込み
                        ref
                            .read(testDBProvider.notifier)
                            .updateScore(testID, memberID, questionID, false);

                        /// shared_preferencesに書き込み
                        LocalSave().setData(ref);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
}
