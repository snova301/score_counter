import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:score_counter/model/testc_dataModel.dart';

class LocalSave {
  /// 設定をshared_preferencesに保存
  void setPref(WidgetRef ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final settingMap = json.encode(ref.watch(settingProvider));
    prefs.setString('setting', settingMap);
  }

  /// 設定をshared_preferencesで取得
  void getPref(WidgetRef ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('setting')) {
      final settingMap = prefs.getString('setting');
      if (settingMap != null) {
        ref.read(settingProvider.state).state = json.decode(settingMap);
      }
    }
  }

  /// データをshared_preferencesで保存
  void setData(WidgetRef ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final testDB = json.encode(ref.watch(testDBProvider));
    final testMap = json.encode(ref.watch(testMapProvider));
    final memberMap = json.encode(ref.watch(memberMapProvider));
    final questionMap = json.encode(ref.watch(questionMapProvider));
    prefs.setString('testDB', testDB);
    prefs.setString('testMap', testMap);
    prefs.setString('memberMap', memberMap);
    prefs.setString('questionMap', questionMap);
  }

  /// データをshared_preferencesで取得
  void getData(WidgetRef ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('testDB') &&
        prefs.containsKey('testMap') &&
        prefs.containsKey('memberMap') &&
        prefs.containsKey('questionMap')) {
      final testDB = prefs.getString('testDB');
      final testMap = prefs.getString('testMap');
      final memberMap = prefs.getString('memberMap');
      final questionMap = prefs.getString('questionMap');

      if (testDB != null) {
        ref.read(testDBProvider.notifier).loadData(json.decode(testDB));
      }

      if (testMap != null) {
        ref.read(testMapProvider.notifier).loadData(json.decode(testMap));
      }
      if (memberMap != null) {
        ref.read(memberMapProvider.notifier).loadData(json.decode(memberMap));
      }
      if (questionMap != null) {
        ref
            .read(questionMapProvider.notifier)
            .loadData(json.decode(questionMap));
      }
    }
  }

  /// shared_preferenceのデータを削除
  void deleteData(WidgetRef ref) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('testDB');
    prefs.remove('testMap');
    prefs.remove('memberMap');
    prefs.remove('questionMap');
  }
}

/// Riverpod StateProvider for setteing
final settingProvider = StateProvider<Map<String, dynamic>>((ref) => {
      'darkmode': false,
    });

/// 何を選択したかをまとめたProvider
final selectStrMapProvider = StateProvider<Map<String, String>>((ref) => {
      'testID': '',
      'memberID': '',
      'questionID': '',
    });
final selectBoolMapProvider = StateProvider<Map<String, bool>>((ref) => {
      'memberSetMode': false,
      'updateMemberSetMode': false,
      'updateQuestionSetMode': false,
    });

/// テスト採点データを格納するProvider
final testDBProvider =
    StateNotifierProvider<TestDBNotifier, Map>((ref) => TestDBNotifier());

/// テスト採点データを格納するNotifier
class TestDBNotifier extends StateNotifier<Map> {
  TestDBNotifier() : super({});

  /// shared_preferenceで読み込んだ値で初期化
  void loadData(Map data) {
    var temp = state;
    temp = data;
    state = {...temp};
  }

  /// テスト採点データのメンバーを作成
  void createMember(String testID, String memberID, Map questionMap) {
    /// 初期化
    late Map addMemberMap;
    late Map addQuestionMap;

    /// 設問リストをループさせ、DBの作成または更新を行う
    questionMap.forEach((questionID, value) {
      if (value['testID'] == testID) {
        // print('testID, memberID, questionID : $testID, $memberID, $questionID');

        /// 最初の導入
        if (!state.containsKey(testID) && questionMap.isNotEmpty) {
          state.addAll(TestDB(testID, memberID, questionID, null).toFullMap());
        }

        /// そのテストにまだ追加したいメンバーがいない場合、メンバー追加を行う
        else if (state.isNotEmpty && !state[testID].containsKey(memberID)) {
          addMemberMap =
              TestDB(testID, memberID, questionID, null).toMemberMap();

          state[testID].addAll(addMemberMap);
        }

        /// 追加したメンバーに対し、設問を追加する
        /// (2回目以降のループで使用)
        else if (!state[testID][memberID].containsKey(questionID)) {
          addQuestionMap =
              TestDB(testID, memberID, questionID, null).toQuestionMap();
          state[testID][memberID].addAll(addQuestionMap);
        }

        /// その他
        else {
          // print('Error');
        }
      }
    });
  }

  /// テスト採点データのメンバーを作成
  void createQuestion(String testID, Map memberMap, String questionID) {
    /// 初期化
    late Map addMemberMap;
    late Map addQuestionMap;

    /// 設問リストをループさせ、DBの作成または更新を行う
    memberMap.forEach((memberID, value) {
      if (value['testID'] == testID) {
        // print('testID, memberID, questionID : $testID, $memberID, $questionID');

        /// 最初の導入
        if (!state.containsKey(testID) && memberMap.isNotEmpty) {
          state.addAll(TestDB(testID, memberID, questionID, null).toFullMap());
        }

        /// そのテストにまだ追加したいメンバーがいない場合、メンバー追加を行う
        else if (state.isNotEmpty && !state[testID].containsKey(memberID)) {
          addMemberMap =
              TestDB(testID, memberID, questionID, null).toMemberMap();

          state[testID].addAll(addMemberMap);
        }

        /// メンバーが存在している場合は設問を追加する
        else if (!state[testID][memberID].containsKey(questionID)) {
          addQuestionMap =
              TestDB(testID, memberID, questionID, null).toQuestionMap();
          state[testID][memberID].addAll(addQuestionMap);
        }

        /// その他
        else {
          // print('Error');
        }
      }
    });
  }

  /// scoreの値を変更
  void updateScore(
      String testID, String memberID, String questionID, bool score) {
    Map temp = state;
    temp[testID][memberID][questionID]['score'] = score;
    state = {...temp};
  }

  /// テストを削除
  void deleteTest(String testID) {
    Map temp = state;
    temp.remove(testID);
    state = {...temp};
  }

  /// メンバーを削除
  void deleteMember(String testID, String memberID) {
    Map temp = state;
    if (state.isNotEmpty) {
      Map membertemp = temp[testID];
      membertemp.remove(memberID);
      temp[testID] = {...membertemp};
    }
    state = {...temp};
  }

  /// 設問を削除
  void deleteQuestion(String testID, Map memberMap, String questionID) {
    Map temp = state;
    if (state.isNotEmpty) {
      Map membertemp = temp[testID];
      late Map questiontemp;
      memberMap.forEach((memberID, value) {
        questiontemp = temp[testID][memberID];
        questiontemp.remove(questionID);
        membertemp[memberID] = questiontemp;
      });
      temp[testID] = {...membertemp};
    }
    state = {...temp};
  }

  /// すべて削除
  void deleteAll() {
    Map temp = state;
    temp = {};
    state = {...temp};
  }
}

/// テストリストデータを格納するProvider
final testMapProvider =
    StateNotifierProvider<TestMapNotifier, Map>((ref) => TestMapNotifier());

/// テストリストデータを格納するNotifier
/// DBにはtestIDが格納されるが、このMapにはテスト名などの詳細が格納される
class TestMapNotifier extends StateNotifier<Map> {
  TestMapNotifier() : super({});

  /// shared_preferenceで読み込んだ値で初期化
  void loadData(Map data) {
    var temp = state;
    temp = data;
    state = {...temp};
  }

  /// テストリストの作成
  void create(String testID, String testname) {
    try {
      var temp = state;
      temp.addAll(TestData(testID, testname).toMap());
      state = {...temp};
    } catch (e) {
      // print(e);
    }
  }

  /// テストリストの更新
  void update(TestData data) {
    try {
      var temp = state;
      temp.update(data.testID, (value) => data.toMap().values.first);
      state = {...temp};
    } catch (e) {
      // print(e);
    }
  }

  /// テストリストの削除
  void delete(String testID) {
    try {
      var temp = state;
      state.remove(testID);
      state = {...temp};
    } catch (e) {
      // print(e);
    }
  }

  /// すべて削除
  void deleteAll() {
    Map temp = state;
    temp = {};
    state = {...temp};
  }
}

/// メンバーデータを格納するProvider
final memberMapProvider =
    StateNotifierProvider<MemberMapNotifier, Map>((ref) => MemberMapNotifier());

/// メンバーデータを格納するNotifier
/// DBにはmemberIDが格納されるが、このMapにはメンバー名などの詳細が格納される
class MemberMapNotifier extends StateNotifier<Map> {
  MemberMapNotifier() : super({});

  /// shared_preferenceで読み込んだ値で初期化
  void loadData(Map data) {
    var temp = state;
    temp = data;
    state = {...temp};
  }

  /// メンバーの追加
  void create(String testID, String memberID, String memberName) {
    try {
      var temp = state;
      temp.addAll(MemberData(testID, memberID, memberName).toMap());
      state = {...temp};
    } catch (e) {
      // print(e);
    }
  }

  /// メンバーの削除
  void delete(String memberID) {
    try {
      var temp = state;
      state.remove(memberID);
      state = {...temp};
      // print(state);
    } catch (e) {
      // print(e);
    }
  }

  /// すべて削除
  void deleteAll() {
    Map temp = state;
    temp = {};
    state = {...temp};
  }
}

/// 質問データを格納するProvider
final questionMapProvider = StateNotifierProvider<QuestionMapNotifier, Map>(
    (ref) => QuestionMapNotifier());

/// 質問データを格納するNotifier
/// DBにはquestionIDが格納されるが、このMapには質問名などの詳細が格納される
class QuestionMapNotifier extends StateNotifier<Map> {
  QuestionMapNotifier() : super({});

  /// shared_preferenceで読み込んだ値で初期化
  void loadData(Map data) {
    var temp = state;
    temp = data;
    state = {...temp};
  }

  /// 設問を作成
  void create(
      String testID, String questionID, String questionName, int point) {
    try {
      var temp = state;
      temp.addAll(
          QuestionData(testID, questionID, questionName, point).toMap());
      state = {...temp};
    } catch (e) {
      // print(e);
    }
  }

  /// 設問の削除
  void delete(String questionID) {
    try {
      var temp = state;
      state.remove(questionID);
      state = {...temp};
    } catch (e) {
      // print(e);
    }
  }

  /// すべて削除
  void deleteAll() {
    Map temp = state;
    temp = {};
    state = {...temp};
  }
}

/// メンバーリストに表示するためのMap
final membersListMapProvider = StateProvider.autoDispose<Map>((ref) {
  /// 必要なデータを抜き出す
  Map temp = {};
  final memberMap = ref.watch(memberMapProvider);
  final testID = ref.watch(selectStrMapProvider)['testID'];

  /// valueのtestIDが一致しているデータを抜き出す
  try {
    memberMap.forEach((key, value) {
      if (value['testID'] == testID) {
        temp.addAll({key: value});
      }
    });
  } catch (e) {
    // print(e);
  }

  return temp;
});

/// questionSetPageの設問リストに表示するためのMap
final questionsListMapProvider = StateProvider.autoDispose<Map>((ref) {
  /// 必要なデータを抜き出す
  Map temp = {};
  final questionMap = ref.watch(questionMapProvider);
  final testID = ref.watch(selectStrMapProvider)['testID'];

  /// valueのtestIDが一致しているデータを抜き出す
  try {
    questionMap.forEach((key, value) {
      if (value['testID'] == testID) {
        temp.addAll({key: value});
      }
    });
  } catch (e) {
    // print(e);
  }

  return temp;
});

/// questionSetPageでの合計点計算
final questionSetPointSumProvider = StateProvider.autoDispose<int>((ref) {
  /// 初期化
  int temp = 0;
  final questionsList = ref.watch(questionsListMapProvider);

  /// ポイントのインクリメント
  questionsList.forEach((key, value) {
    temp += int.parse(value['point'].toString());
  });

  return temp;
});

/// 採点結果を表示するためのMap
final scoreSetMapProvider = StateProvider.autoDispose<Map>((ref) {
  /// データの読込
  final testDB = ref.watch(testDBProvider);
  final questionMap = ref.watch(questionMapProvider);
  final testID = ref.watch(selectStrMapProvider)['testID'];
  final memberID = ref.watch(selectStrMapProvider)['memberID'];

  /// DBに保存されたデータが更新されると自動的に採点ページの表示が変更されるように修正
  Map temp = {};
  Map extTestDB = testDB[testID][memberID];
  extTestDB.forEach((key, value) {
    final name = questionMap[key]['name'];
    final point = questionMap[key]['point'];
    final score = value['score'];

    temp.addAll({
      key: {
        'name': name,
        'point': point,
        'score': score,
      },
    });
  });
  return temp;
});

/// 採点結果の合計点表示
final scoreSetPointSumProvider = StateProvider.autoDispose<int>((ref) {
  /// データの読込
  int temp = 0;
  final scoreSetMap = ref.watch(scoreSetMapProvider);

  /// ポイントのインクリメント
  scoreSetMap.forEach((key, value) {
    temp += int.parse(value['point'].toString());
  });

  return temp;
});

/// 採点結果の得点表示
final scoreSetScoreSumProvider = StateProvider.autoDispose<int>((ref) {
  /// データの読込
  int temp = 0;
  final scoreSetMap = ref.watch(scoreSetMapProvider);

  /// ポイントのインクリメント
  scoreSetMap.forEach((key, value) {
    bool isScore = value['score'] ?? false;
    if (isScore) {
      temp += int.parse(value['point'].toString());
    }
  });

  return temp;
});
