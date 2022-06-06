import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:score_counter/main.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/view/questionSetPage.dart';

class CreatePage extends ConsumerWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textController = ref.watch(testNameControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('新規作成'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(30),
        children: <Widget>[
          _TextFieldContainer(context, ref, textController),
          _NextButton(context, ref, textController),
        ],
      ),
    );
  }
}

class _TextFieldContainer extends Container {
  _TextFieldContainer(BuildContext context, ref, _controller)
      : super(
            child: TextField(
          controller: _controller,
          autofocus: true,
        ));
}

class _NextButton extends Align {
  _NextButton(
      BuildContext context, WidgetRef ref, TextEditingController _controller)
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
                // テスト名が空欄の場合や重複の場合にAlertを出力
                (_controller.text == '' ||
                        RunClassWhole().isTestNameDuplicate(ref))
                    ? showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _NextButtonDialog(context);
                        },
                      )
                    : {
                        RunClassWhole().createSelectTestName(ref),
                        ref.read(isUpdateQuestionProvider.state).state = false,
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QuestionSetPage(),
                          ),
                        ),
                      };
              },
            ),
          ),
        );
}

class _NextButtonDialog extends AlertDialog {
  _NextButtonDialog(BuildContext context)
      : super(
          title: const Text('注意'),
          content: const Text('テスト名が空欄または重複しています。\n入力内容を確認してください。'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        );
}
