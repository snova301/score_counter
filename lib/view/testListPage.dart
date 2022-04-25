import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/main.dart';

class TestListPage extends ConsumerWidget {
  const TestListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _testList = ref.watch(testListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('テストリスト'),
      ),
      body: Column(
        children: [
          const Text("👇ここからリスト👇"),
          _InfoCard(context, ref, '問題数'),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _testList.length,
              itemBuilder: (context, index) {
                return _QuestionCard(context, ref, _testList, index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends Card {
  _InfoCard(BuildContext context, WidgetRef ref, String title)
      : super(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(title),
                Text('タップすると、' + title + 'webページへ移動します。'),
              ],
            ),
          ),
        );
}

class _QuestionCard extends Card {
  _QuestionCard(
    BuildContext context,
    WidgetRef ref,
    List _testList,
    int index,
  ) : super(
          child: ListTile(
            title: Text(_testList[index]),
            subtitle: Text(_testList[index] + index.toString()),
            // onLongPress: () {
            //   _testList.removeAt(index);
            //   ref.read(questionListProvider.state).state = [..._testList];
            // },
            trailing: const Icon(Icons.open_in_browser),
          ),
        );
}
