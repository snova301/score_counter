import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/src/view/common.dart';
import 'package:uuid/uuid.dart';
import 'package:score_counter/src/model/state_manager.dart';

class QuestionSetPage extends ConsumerStatefulWidget {
  const QuestionSetPage({Key? key}) : super(key: key);

  @override
  QuestionSetPageState createState() => QuestionSetPageState();
}

class QuestionSetPageState extends ConsumerState<QuestionSetPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 初期化
    final questionMap = ref.watch(questionsListMapProvider);
    final pointSum = ref.watch(questionSetPointSumProvider);
    final isUpdateSetMode =
        ref.watch(selectBoolMapProvider)['updateQuestionSetMode']!;

    /// 設問の最大数の決定
    const maxNumOfQuestion = 100;

    /// 点数入力用TextEditingControllerの初期化
    TextEditingController controller = TextEditingController(text: '1');

    return Scaffold(
      appBar: AppBar(
        title: const Text('設問設定'),
      ),
      body: Column(
        children: [
          /// 注意喚起
          const Text('設問は $maxNumOfQuestion 問まで'),

          /// 情報
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InfoCard(
                  title: '問題数',
                  num: '${questionMap.length}  /  $maxNumOfQuestion'),
              InfoCard(title: '合計点', num: '$pointSum'),
            ],
          ),

          /// リスト
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
              // padding: const EdgeInsets.all(8),
              itemCount: questionMap.length,
              itemBuilder: (context, index) {
                return _QuestionCard(context, ref, questionMap, index);
              },
            ),
          ),

          /// 設定モードのとき、次へボタンを表示
          /// 将来的に Container() を削除したい
          isUpdateSetMode ? Container() : _NextButton(context, ref),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: '設問追加',
        child: const Icon(Icons.add),
        onPressed: () {
          /// 最大数以下の場合
          if (questionMap.length < maxNumOfQuestion) {
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => _AddDialog(
                    context, ref, maxNumOfQuestion, controller, questionMap));
          }

          /// 最大数を超える場合、snackbarで注意
          else {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBarAlert('これ以上追加できません。'),
            // );
            SnackBarAlert(context: context).snackbar('これ以上追加できません');
          }
        },
      ),
    );
  }
}

/// QuestionCardの作成
class _QuestionCard extends Card {
  _QuestionCard(BuildContext context, WidgetRef ref, Map questionMap, int index)
      : super(
          child: ListTile(
            /// 設問名を表示
            title: Text(questionMap.values.elementAt(index)['name']),
            subtitle:
                Text('配点 : ${questionMap.values.elementAt(index)['point']}'),
            // subtitle: Text('ID : ${questionMap.keys.elementAt(index)}'),
            contentPadding: const EdgeInsets.all(8),

            /// ポップアップメニュー
            trailing: _QuestionCardPopup(context, ref, questionMap, index),
          ),
        );
}

/// Question Cardのポップアップ
class _QuestionCardPopup extends PopupMenuButton<int> {
  _QuestionCardPopup(
      BuildContext context, WidgetRef ref, Map questionMap, int index)
      : super(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              /// 設問の削除
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
            /// 設問の削除
            if (val == 0) {
              /// データ取得
              final testID = ref.read(selectStrMapProvider)['testID']!;
              final memberMap = ref.read(memberMapProvider);
              final questionID = questionMap.keys.elementAt(index);

              /// questionMapから削除
              ref.read(questionMapProvider.notifier).delete(questionID);

              /// DBから削除
              ref
                  .read(testDBProvider.notifier)
                  .deleteQuestion(testID, memberMap, questionID);

              /// shared_preferencesに書き込み
              LocalSave().setData(ref);
            }
          },
        );
}

/// 次へボタン
class _NextButton extends Align {
  _NextButton(BuildContext context, WidgetRef ref)
      : super(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('ページリストへ'),
              onPressed: () {
                /// ページ遷移
                Navigator.pop(context);
              },
            ),
          ),
        );
}

/// 追加ボタンを押したときのダイアログ
class _AddDialog extends AlertDialog {
  _AddDialog(BuildContext context, WidgetRef ref, int maxNumOfQuestion,
      TextEditingController controller, Map questionMap)
      : super(
          title: const Text('新規質問の配点(整数のみ)'),
          scrollable: true,

          /// 点数入力
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '配点を入力',
            ),
          ),

          /// ボタン
          actions: <Widget>[
            /// キャンセル
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),

            /// OKボタン
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                /// データ取得
                String testID = ref.watch(selectStrMapProvider)['testID']!;
                Map memberMap = ref.read(memberMapProvider);
                String questionID = const Uuid().v4();

                /// 質問名の決定
                String questionName = '質問 ${questionMap.length + 1}';

                /// TexteditingControllerに不正な文字が入力されたらエラーを出す
                try {
                  /// 数値読込
                  int point = int.parse(controller.text);

                  /// questionMapへの書込み
                  ref
                      .read(questionMapProvider.notifier)
                      .create(testID, questionID, questionName, point);

                  /// DBへ書込み
                  ref
                      .read(testDBProvider.notifier)
                      .createQuestion(testID, memberMap, questionID);

                  /// shared_preferencesに書き込み
                  LocalSave().setData(ref);

                  /// もとの画面に戻る
                  Navigator.pop(context);
                } catch (e) {
                  /// snackbarで警告
                  SnackBarAlert(context: context).snackbar('有効な数値を入力してください');
                }
              },
            ),
          ],
        );
}
