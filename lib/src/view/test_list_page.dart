import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/src/model/state_manager.dart';
import 'package:score_counter/src/view/common.dart';
import 'package:score_counter/src/view/member_set_page.dart';
import 'package:score_counter/src/view/create_page.dart';
import 'package:score_counter/src/view/question_set_page.dart';

class TestListPage extends ConsumerStatefulWidget {
  const TestListPage({Key? key}) : super(key: key);

  @override
  TestListPageState createState() => TestListPageState();
}

class TestListPageState extends ConsumerState<TestListPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 初期化
    final testMap = ref.watch(testMapProvider);
    const maxNumOfTest = 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text('テストリスト'),
      ),

      /// drawer
      drawer: const DrawerMenu(),
      body: Column(
        children: [
          /// テストリストの情報
          const Text('テストの数は$maxNumOfTestまで'),
          InfoCard(title: 'テスト数', num: '${testMap.length}  /  $maxNumOfTest'),

          /// テストのリストを表示
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
              // padding: const EdgeInsets.all(10),
              itemCount: testMap.length,
              itemBuilder: (context, index) {
                return _TestCard(context, ref, testMap, index);
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
          testMap.length < maxNumOfTest

              /// テストの数が規定値より小さい場合は作成可能
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreatePage(),
                  ),
                )

              /// テスト数が規定値より大きい場合はsnackbarで注意勧告
              : SnackBarAlert(context: context).snackbar('これ以上追加できません');
        },
      ),
    );
  }
}

/// テストの名前を表示するCard
class _TestCard extends Card {
  _TestCard(BuildContext context, WidgetRef ref, Map testlistMap, int index)
      : super(
          child: ListTile(
            /// テスト名を表示
            title: Text(testlistMap.values.elementAt(index)['name']),
            contentPadding: const EdgeInsets.all(8),
            onTap: () {
              /// どのテストを選択したかを格納
              ref.read(selectStrMapProvider).update(
                  'testID', (value) => testlistMap.keys.elementAt(index));

              /// メンバーの設定モードをfalseにする
              ref
                  .read(selectBoolMapProvider)
                  .update('memberSetMode', (value) => false);

              /// テスト作成ページへ移動
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemberSetPage(),
                ),
              );
            },

            /// ポップアップメニューの表示
            trailing: _TestCardPopup(context, ref, testlistMap, index),
          ),
        );
}

/// TestCardのポップアップに関するクラス
class _TestCardPopup extends PopupMenuButton<int> {
  _TestCardPopup(
      BuildContext context, WidgetRef ref, Map testlistMap, int index)
      : super(
          /// ポップアップメニューアイコン
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: 0,
              child: Row(
                children: const <Widget>[
                  Icon(Icons.people),
                  Text(' メンバー設定'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Row(
                children: const <Widget>[
                  Icon(Icons.note_alt_outlined),
                  Text(' 設問設定'),
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
            /// どのテストを選択したかの設定
            ref
                .read(selectStrMapProvider)
                .update('testID', (value) => testlistMap.keys.elementAt(index));

            /// 設問の設定
            if (val == 0) {
              /// 設定モードの変更
              ref
                  .read(selectBoolMapProvider)
                  .update('memberSetMode', (value) => true);
              ref
                  .read(selectBoolMapProvider)
                  .update('updateMemberSetMode', (value) => true);

              /// ページ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MemberSetPage(),
                ),
              );
            }

            /// メンバーの設定
            else if (val == 1) {
              /// 設定モードの変更
              ref
                  .read(selectBoolMapProvider)
                  .update('updateQuestionSetMode', (value) => true);

              /// ページ遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuestionSetPage(),
                ),
              );
            }

            /// テストを削除
            else if (val == 2) {
              /// IDを取得
              final deleteID = testlistMap.keys.elementAt(index);

              /// testMap, memberMap, questionMapから削除
              ref.read(testMapProvider.notifier).delete(deleteID);
              ref.read(memberMapProvider.notifier).deleteTest(deleteID);
              ref.read(questionMapProvider.notifier).deleteTest(deleteID);

              /// DBから削除
              ref.read(testDBProvider.notifier).deleteTest(deleteID);

              /// shared_preferencesに書き込み
              LocalSave().setData(ref);
            }
          },
        );
}
