import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/view/myHomePage.dart';
import 'package:score_counter/main.dart';
import 'package:score_counter/view/scoreSetPage.dart';
import 'package:score_counter/view/testListPage.dart';

class MemberSetPage extends ConsumerStatefulWidget {
  const MemberSetPage({Key? key}) : super(key: key);

  @override
  MemberSetPageState createState() => MemberSetPageState();
}

class MemberSetPageState extends ConsumerState<MemberSetPage> {
  @override
  void initState() {
    super.initState();
    ref.read(memberListProvider).clear();
  }

  @override
  Widget build(BuildContext context) {
    final _memberList = InitListClass().mSelectMList(ref);

    return Scaffold(
      appBar: AppBar(
        title: const Text('メンバー設定'),
      ),
      body: Column(
        children: [
          InfoCard(context, ref, '人数', _memberList.length.toString()),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _memberList.length,
              itemBuilder: (context, index) {
                return _MemberCard(context, ref, _memberList, index);
              },
            ),
          ),
          _BackButton(context, ref),
        ],
      ),
      floatingActionButton: ref.watch(isMemberSetModeProvider)
          ? FloatingActionButton(
              onPressed: () {
                RunClass().addMember(ref);
              },
              tooltip: 'メンバー追加',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

class _MemberCard extends Card {
  _MemberCard(BuildContext context, WidgetRef ref, List _memberList, int _index)
      : super(
          child: ListTile(
            title: Text(_memberList[_index]),
            // subtitle: const Text('得点 / 配点 = 80 / 100'),
            // trailing: const Icon(Icons.all_inclusive_outlined),
            onTap: () {
              ref.watch(isMemberSetModeProvider)
                  ? null // Set Mode
                  : ref.read(selectMemberProvider.state).state =
                      _memberList[_index]; // Select Mode
              ref.watch(isMemberSetModeProvider)
                  ? null // Set Mode
                  : InitListClass().scoreSelectList(ref); // Select Mode
              ref.watch(isMemberSetModeProvider)
                  ? null // Set Mode
                  : Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ScoreSetPage()),
                    ); // Select Mode
            },
            onLongPress: () {
              ref.watch(isMemberSetModeProvider)
                  ? RunClass()
                      .removeMember(ref, _memberList, _index) // Set Mode
                  : null; // Select Mode
            },
          ),
        );
}

class _BackButton extends Align {
  _BackButton(BuildContext context, WidgetRef ref)
      : super(
          child: ref.watch(isMemberSetModeProvider)
              ? Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    child: const Text('テストリスト一覧へ'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TestListPage()),
                      );
                    },
                  ),
                )
              : null,
        );
}
