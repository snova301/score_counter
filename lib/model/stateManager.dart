import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:score_counter/main.dart';
import 'package:score_counter/model/runClass.dart';
import 'package:score_counter/model/testDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateManagerClass {
  /// initiallize provider for setteings
  final darkmodeStateProvider = StateProvider((ref) => true);

  /// initiallize provider for textcontroller
  final testNameControllerStateProvider = StateProvider((ref) {
    return TextEditingController(text: '');
  });

  /// initiallize provider for list
  final testListStateProvider = StateProvider((ref) => []);
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

  /// initiallize provider for data
  final testDataStoreStateProvider = StateProvider((ref) => <TestDataModel>[]);
  final pointSumStateProvider = StateProvider((ref) => 0);
  final aaaaStateProvider = StateProvider((ref) => []);

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

  /// Testmodelをshared_preferencesで取得
  Future<void> getTestModel(WidgetRef ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var _getData = prefs.getStringList('testmodel') ?? [];
    ref.watch(testDataStoreProvider.state).state =
        _getData.map((f) => TestDataModel.fromJson(json.decode(f))).toList();
  }

  /// Testmodelをshared_preferencesに書き込み
  void setTestModel(List _testDataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _testModel =
        _testDataList.map((f) => json.encode(f.toJson())).toList();
    prefs.setStringList('testmodel', _testModel);
  }

  /// Testmodelをshared_preferencesから削除
  void removeTestModel(WidgetRef ref) async {
    ref.read(testDataStoreProvider).clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('testmodel');
  }
}
