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
  /// 前回までのリストをクリアし、重複を防ぐ
  @override
  void initState() {
    super.initState();
    ref.read(memberListProvider).clear();
  }

  @override
  Widget build(BuildContext context) {
    final _memberList = InitListClass().mSelectMList(ref);
    final _maxNumOfMember = 50;

    return Scaffold(
      appBar: AppBar(
        title: ref.watch(isMemberSetModeProvider)
            ? const Text('メンバー設定')
            : const Text('メンバー選択'),
      ),
      body: Column(
        children: [
          Text('メンバーは' + _maxNumOfMember.toString() + '人まで設定できます。'),
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
                RunClassMemberSet().addMember(ref, _maxNumOfMember);
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
            contentPadding: const EdgeInsets.all(8),
            trailing: ref.watch(isMemberSetModeProvider)
                ? _MemberCardPopup(context, ref, _memberList, _index)
                : null,
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
          ),
        );
}

class _MemberCardPopup extends PopupMenuButton<int> {
  _MemberCardPopup(
      BuildContext context, WidgetRef ref, List _memberList, int _index)
      : super(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (BuildContext context) => [
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
            if (val == 0) {
              RunClassMemberSet().removeMember(ref, _memberList, _index);
            }
          },
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
                    child: const Text('テストリストへ'),
                    onPressed: () {
                      ref.read(isUpdateQuestionProvider)
                          ? null
                          : RunClassWhole().addClearTestName(ref);
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
