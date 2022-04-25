import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/model/stateCulcClass.dart';
import 'package:score_counter/view/detailMemberPage.dart';
import 'package:score_counter/main.dart';

class QuestionSetPage extends ConsumerWidget {
  const QuestionSetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _questionList = ref.watch(questionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('設問設定'),
      ),
      body: Column(
        children: [
          const Text("👇ここからリスト👇"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _InfoCard(context, ref, '問題数'),
              _InfoCard(context, ref, '合計配点'),
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
          _NextButton(context, ref)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _questionList
              .add('NEW QUESTION  /  ' + Random().nextInt(100).toString());
          ref.read(questionListProvider.state).state = [..._questionList];
        },
        tooltip: '設問追加',
        child: const Icon(Icons.add),
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
    List questionList,
    int index,
  ) : super(
          child: ListTile(
            title: Text(questionList[index]),
            subtitle: Text(questionList[index] + index.toString()),
            onLongPress: () {
              questionList.removeAt(index);
              ref.read(questionListProvider.state).state = [...questionList];
            },
            trailing: const Icon(Icons.open_in_browser),
          ),
        );
}

class _NextButton extends Align {
  _NextButton(BuildContext context, WidgetRef ref)
      : super(
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DetailMemberPage()),
                );
                const StateCulcClass().bbb();
              },
              child: const Text('作成'),
            ),
          ),
        );
}

// class _InfoCard extends Card {
//   _InfoCard(BuildContext context, urlTitle, urlName)
//       : super(
//           child: ListTile(
//             title: Text(urlTitle),
//             subtitle: Text('タップすると、' + urlTitle + 'のwebページへ移動します。'),
//             onTap: () => _launchUrl(urlName),
//             trailing: const Icon(Icons.open_in_browser),
//           ),
//         );
// }