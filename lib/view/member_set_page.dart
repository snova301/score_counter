import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:score_counter/model/state_manager.dart';
import 'package:score_counter/view/my_homepage.dart';
import 'package:score_counter/view/question_set_page.dart';
import 'package:score_counter/view/score_set_page.dart';

class MemberSetPage extends ConsumerStatefulWidget {
  const MemberSetPage({Key? key}) : super(key: key);

  @override
  MemberSetPageState createState() => MemberSetPageState();
}

class MemberSetPageState extends ConsumerState<MemberSetPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 初期化
    final memberMap = ref.watch(membersListMapProvider);
    final isSetMode = ref.watch(selectBoolMapProvider)['memberSetMode']!;
    final isUpdateSetMode =
        ref.watch(selectBoolMapProvider)['updateMemberSetMode']!;

    /// メンバーの最大数の決定
    const maxNumOfMember = 50;

    return Scaffold(
      appBar: AppBar(
        title: isSetMode ? const Text('メンバー設定') : const Text('メンバー選択'),
      ),
      body: Column(
        children: [
          /// 情報
          Text('メンバーは $maxNumOfMember 人まで'),
          InfoCard('人数', '${memberMap.length}  /  $maxNumOfMember'),

          /// リスト
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 30),
              // padding: const EdgeInsets.all(8),
              itemCount: memberMap.length,
              itemBuilder: (context, index) {
                return _MemberCard(context, ref, memberMap, index, isSetMode);
              },
            ),
          ),

          /// 設定モードのとき、次へボタンを表示
          /// 将来的に Container() を削除したい
          isSetMode && !isUpdateSetMode
              ? _NextButton(context, ref)
              : Container(),
        ],
      ),

      /// メンバー追加ボタン
      floatingActionButton: isSetMode
          ? FloatingActionButton(
              onPressed: () {
                /// メンバーが最大数以下の場合
                if (memberMap.length < maxNumOfMember) {
                  /// データの取得とIDの取得
                  String testID = ref.watch(selectStrMapProvider)['testID']!;
                  String memberID = const Uuid().v4();
                  Map _questionMap = ref.read(questionMapProvider);

                  /// メンバーの名前
                  String memberName = 'メンバー ${memberMap.length + 1}';

                  /// memberMapに登録
                  ref
                      .read(memberMapProvider.notifier)
                      .create(testID, memberID, memberName);

                  /// DBに登録
                  ref
                      .read(testDBProvider.notifier)
                      .createMember(testID, memberID, _questionMap);

                  /// shared_preferencesに書き込み
                  LocalSave().setData(ref);
                }

                /// メンバーが最大数を超えているとき
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarAlert('これ以上追加できません。'),
                  );
                }
              },
              tooltip: 'メンバー追加',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

/// メンバーを表示するためのwidget
class _MemberCard extends Card {
  _MemberCard(BuildContext context, WidgetRef ref, Map memberMap, int index,
      bool isSetMode)
      : super(
          child: ListTile(
            /// Cardにはメンバーの名前を表示
            title: Text(memberMap.values.elementAt(index)['name']),
            // subtitle: Text('ID : ${memberMap.keys.elementAt(index)}'),
            contentPadding: const EdgeInsets.all(8),

            /// ポップアップメニュー
            trailing: isSetMode
                ? _MemberCardPopup(context, ref, memberMap, index)
                : null,
            onTap: () {
              isSetMode
                  ? null
                  : {
                      /// タップされたメンバーのIDを取得
                      ref.read(selectStrMapProvider.state).state['memberID'] =
                          memberMap.keys.elementAt(index),

                      /// ページ遷移
                      /// 下から遷移するアニメーション
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return const ScoreSetPage();
                          },
                          // transitionDuration: Duration(milliseconds: 500),
                          // reverseTransitionDuration:
                          //     Duration(milliseconds: 500),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(0.0, 1.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      ),
                    };
            },
          ),
        );
}

/// メンバーCardのポップアップメニュー
class _MemberCardPopup extends PopupMenuButton<int> {
  _MemberCardPopup(
      BuildContext context, WidgetRef ref, Map memberMap, int index)
      : super(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
            /// メンバー削除
            PopupMenuItem(
              value: 0,
              child: Row(
                children: const <Widget>[
                  Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  Text(
                    ' メンバーを削除',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ],
          onSelected: (int val) {
            /// メンバー削除
            if (val == 0) {
              /// データ取得
              final testID = ref.watch(selectStrMapProvider)['testID']!;
              final memberID = memberMap.keys.elementAt(index);

              /// memberMapから削除
              ref.read(memberMapProvider.notifier).delete(memberID);

              /// DBから削除
              ref.read(testDBProvider.notifier).deleteMember(testID, memberID);

              /// shared_preferencesに書き込み
              LocalSave().setData(ref);
            }
          },
        );
}

/// 次へボタン
/// メンバー設定モードのときのみ使用可能
class _NextButton extends Align {
  _NextButton(BuildContext context, WidgetRef ref)
      : super(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              child: const Text('設問設定へ'),
              onPressed: () {
                /// 設定モードの変更
                ref
                    .read(selectBoolMapProvider)
                    .update('updateQuestionSetMode', (value) => false);

                /// 画面遷移
                /// providerのautodisposeのため、前画面に一度戻って進む
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuestionSetPage()),
                );
              },
            ),
          ),
        );
}
