import 'package:flutter/material.dart';
import 'package:score_counter/main.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateManagerClass {
  /// initiallize provider for setteings
  final darkmodeStateProvider = StateProvider((ref) => true);

  /// initiallize provider for textcontroller
  final testNameControllerStateProvider = StateProvider((ref) {
    return TextEditingController(text: '');
  });
  final memberNameControllerStateProvider = StateProvider((ref) {
    return TextEditingController(text: '');
  });
  final questionNameControllerStateProvider = StateProvider((ref) {
    return TextEditingController(text: '');
  });

  /// initiallize provider for list
  final testListStateProvider = StateProvider((ref) => ['asd']);
  final questionListStateProvider = StateProvider((ref) => []);
  final memberListStateProvider = StateProvider((ref) => []);
  final pointListStateProvider = StateProvider((ref) => []);
  final scoreListStateProvider = StateProvider((ref) => []);

  /// initiallize provider for select
  final selectTestNameStateProvider = StateProvider((ref) => '');
  final selectQuestionStateProvider = StateProvider((ref) => '');
  final selectMemberStateProvider = StateProvider((ref) => '');

  /// initiallize provider for setmode
  final isUpdateQuestionStateProvider = StateProvider((ref) => false);
  final isMemberSetModeStateProvider = StateProvider((ref) => true);
  final aaaaStateProvider = StateProvider((ref) => [false]);

  /// initiallize provider for data
  final testDataStoreProvider = StateProvider((ref) => <TestDataModel>[]);
  final pointSumStateProvider = StateProvider((ref) => 0);

  /// ダークモード状態をshared_preferencesで取得
  void getDarkmodeVal(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ref.watch(darkmodeProvider.state).state = prefs.getBool('darkmode') ?? true;
  }

  /// ダークモード状態をshared_preferencesに書き込み
  void setDarkmodeVal(WidgetRef ref) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkmode', ref.read(darkmodeProvider));
  }
}
