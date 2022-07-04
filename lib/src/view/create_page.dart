import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:score_counter/src/model/state_manager.dart';
import 'package:score_counter/src/view/member_set_page.dart';

class CreatePage extends ConsumerWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 初期化
    final textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規作成'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: <Widget>[
          /// 入力フォームwidget
          _TextFieldContainer(context, textController),

          /// 次へボタン
          _NextButton(context, ref, textController),
        ],
      ),
    );
  }
}

/// 入力フォームwidget
class _TextFieldContainer extends Container {
  _TextFieldContainer(BuildContext context, controller)
      : super(
            child: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'テスト名',
          ),
        ));
}

/// 次へボタン
class _NextButton extends Align {
  _NextButton(
      BuildContext context, WidgetRef ref, TextEditingController controller)
      : super(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              child: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.all(6),
                child: const Text('次  へ'),
              ),
              onPressed: () {
                /// IDと名前の取得
                String testID = const Uuid().v4();
                String testName = controller.text;

                /// 選択Mapへの保存
                ref.read(selectStrMapProvider.state).state['testID'] = testID;

                /// テストリストにデータを渡す
                ref.read(testMapProvider.notifier).create(testID, testName);

                /// メンバー設定モードをtrue、メンバー設定更新モードをfalse
                ref
                    .read(selectBoolMapProvider)
                    .update('memberSetMode', (value) => true);
                ref
                    .read(selectBoolMapProvider)
                    .update('updateMemberSetMode', (value) => false);

                /// shared_preferencesに書き込み
                LocalSave().setData(ref);

                /// 画面遷移
                /// providerのautodisposeのため、前画面に一度戻って進む
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemberSetPage(),
                  ),
                );
              },
            ),
          ),
        );
}
