import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/main.dart';
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
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          textController.text == ''
              ? null
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QuestionSetPage()),
                );
        },
        tooltip: '次のページ',
        label: const Text('次へ'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _TextFieldContainer extends Container {
  _TextFieldContainer(BuildContext context, ref, _controller)
      : super(
            child: TextField(
          controller: _controller,
        ));
}
