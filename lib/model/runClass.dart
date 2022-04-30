import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/main.dart';

/// 実行用メソッドを集めたクラス
class RunClass {
  void createSelectTestName(WidgetRef ref) {
    ref.read(selectTestNameProvider.state).state =
        ref.read(testNameControllerProvider).text;
  }

  /// QuestionSetPageの保存ボタンの動作
  void questionSetRun(WidgetRef ref) {
    ref.read(testListProvider).add(ref.read(testNameControllerProvider).text);
    ref.read(testNameControllerProvider).clear();
  }

  /// CreatePageでテスト名が重複していないか確認。
  /// 重複していたらtrue、重複していなければfalseを返す。
  bool isTestNameDuplicate(WidgetRef ref) {
    return ref
        .read(testListProvider)
        .contains(ref.read(testNameControllerProvider));
  }

  /// QuestionSetPageでメンバーが重複していないか確認。
  /// 重複していたらtrue、重複していなければfalseを返す。
  bool isQuestionDuplicate(WidgetRef ref) {
    return ref
        .read(testListProvider)
        .contains(ref.read(testNameControllerProvider));
  }

  /// MemberSetPageでメンバーが重複していないか確認。
  /// 重複していたらtrue、重複していなければfalseを返す。
  bool isMemberDuplicate(WidgetRef ref) {
    return ref
        .read(testListProvider)
        .contains(ref.read(testNameControllerProvider));
  }

  /// ScoreSetPageで採点実施
  void scoreSetRun(
      WidgetRef ref, List _questionList, int _index, bool _answer) {
    /// 読込
    final _testDataStore = ref.read(testDataStoreProvider);
    final _testName = ref.read(selectTestNameProvider);
    final _member = ref.read(selectMemberProvider);

    /// データ変更
    _testDataStore.forEach((val) {
      if (val.testname == _testName &&
          val.member == _member &&
          val.question == _questionList[_index]) {
        val.score = _answer;
      }
    });

    /// 表示リスト変更
    ref.read(scoreListProvider)[_index] = _answer;
    ref.read(scoreListProvider.state).state = [...ref.read(scoreListProvider)];

    _testDataStore.forEach((val) {
      print(val.testname +
          ' / ' +
          val.question +
          ' / ' +
          val.member +
          ' / ' +
          val.score.toString());
    });
  }

  String sumPoint(WidgetRef ref) {
    final _pointList = ref.watch(pointListProvider);

    return _pointList.isEmpty
        ? '0'
        : _pointList.reduce((val, ele) => val + ele).toString();
  }

  /// 得点を計算
  Map sumScore(WidgetRef ref) {
    /// 読込
    final _testDataStore = ref.read(testDataStoreProvider);
    final _selectTestName = ref.read(selectTestNameProvider);
    final _selectMember = ref.read(selectMemberProvider);

    /// データ抽出
    List _scoreList = [];
    List _pointList = [];
    _testDataStore.forEach((val) {
      if (val.testname == _selectTestName && val.member == _selectMember) {
        _scoreList.add(val.score);
        _pointList.add(val.point);
      }
    });

    /// データ
    List _sumCountList = [];
    for (var _i = 0; _i < _scoreList.length; _i++) {
      if (_scoreList[_i]) {
        _sumCountList.add(_pointList[_i]);
      }
    }

    int _correctPoint = 0;
    if (_sumCountList.isNotEmpty) {
      _correctPoint = _sumCountList.reduce((val, ele) => val + ele);
    }
    print(_correctPoint);

    /// 合計点
    final _totalPoint = _pointList.reduce((val, ele) => val + ele);

    final Map<String, int> _sumScoreMap = {
      'Correct': _correctPoint,
      'Total': _totalPoint
    };

    return _sumScoreMap;
  }

  /// QuestionSetPageで設問を追加
  void addQuestion(WidgetRef ref) {
    /// 読込
    final _questionList = ref.read(questionListProvider);
    final _pointList = ref.read(pointListProvider);

    /// 表示用設問リストへの追加
    /// _questionListがemptyなら'QUESTION - 1'を書き込む
    /// elseなら、番号が小さい順に設問を確認し、リストに追加
    String _newQuestionName = 'QUESTION - 1';
    int _newPoint = 2;
    if (_questionList.isEmpty) {
      _questionList.add(_newQuestionName);
      _pointList.add(_newPoint);
    } else {
      for (int _i = 1; _i <= 100; _i++) {
        String _newQuestionName = 'QUESTION - ' + _i.toString();
        if (!_questionList.contains(_newQuestionName)) {
          _questionList.add(_newQuestionName);
          _pointList.add(_newPoint);
          break;
        }
      }
    }

    /// 表示用リストの更新
    ref.read(questionListProvider.state).state = [..._questionList];
    ref.read(pointListProvider.state).state = [..._pointList];
  }

  /// MemberSetPageでメンバーを追加
  /// メンバー追加でデータモデルを構築
  void addMember(WidgetRef ref) {
    /// 読込
    final _memberList = ref.read(memberListProvider);

    /// 表示用設問リストへの追加
    /// _memberListがemptyなら'MEMBER - 1'を書き込む
    /// elseなら、番号が小さい順に設問を確認し、リストに追加
    String _memberName = 'MEMBER - 1';
    if (_memberList.isEmpty) {
      _memberList.add(_memberName);
    } else {
      for (int _i = 1; _i <= 100; _i++) {
        String _newMemberName = 'MEMBER - ' + _i.toString();
        if (!_memberList.contains(_newMemberName)) {
          _memberList.add(_newMemberName);
          _memberName = _newMemberName;
          break;
        }
      }
    }

    /// 表示用メンバーリストへ追加
    ref.read(memberListProvider.state).state = [..._memberList];

    /// データモデルへの追加
    final _testDataStore = ref.read(testDataStoreProvider);
    final _selectTestName = ref.read(selectTestNameProvider);
    final _questionList = ref.read(questionListProvider).toSet().toList();
    final _pointList = ref.read(pointListProvider);

    for (var _i = 0; _i < _questionList.length; _i++) {
      _testDataStore.add(TestDataModel(
        _selectTestName,
        _questionList[_i],
        _memberName,
        _pointList[_i],
        false,
      ));
    }
  }

  /// AddQuestionのupdate対応
  void updateAddQuestion(WidgetRef ref) {
    /// 読込
    final _questionList = ref.read(questionListProvider);
    final _pointList = ref.read(pointListProvider);

    /// 表示用設問リストへの追加
    String _newQuestionName = '';
    int _newPoint = 2;
    if (_questionList.isEmpty) {
      _questionList.add('QUESTION - 1');
      _pointList.add(_newPoint);
    } else {
      for (int _i = 1; _i <= 100; _i++) {
        _newQuestionName = 'QUESTION - ' + _i.toString();
        if (!_questionList.contains(_newQuestionName)) {
          _questionList.add(_newQuestionName);
          _pointList.add(_newPoint);
          break;
        }
      }
    }

    /// 表示用リストの更新
    ref.read(questionListProvider.state).state = [..._questionList];
    ref.read(pointListProvider.state).state = [..._pointList];

    /// データ追加
    /// 読込
    final _selectTestName = ref.read(selectTestNameProvider);
    final _testDataStore = ref.read(testDataStoreProvider);

    /// データ確認
    List _memberList = [];
    _testDataStore.forEach((_val) {
      if (_val.testname == _selectTestName) {
        _memberList.add(_val.member);
      }
    });

    /// 重複確認とデータ追加
    _memberList = _memberList.toSet().toList();
    for (var _member in _memberList) {
      _testDataStore.add(TestDataModel(
          _selectTestName, _newQuestionName, _member, _newPoint, false));
    }
  }

  /// RemoveQuestion
  void removeQuestion(WidgetRef ref, List _list, int _index) {
    /// PointList読込
    final _pointList = ref.read(pointListProvider);

    /// questionlistのremove
    _list.removeAt(_index);
    _pointList.removeAt(_index);

    /// データの更新
    ref.read(questionListProvider.state).state = [..._list];
    ref.read(pointListProvider.state).state = [..._pointList];
  }

  /// RemoveQuestionのupdate対応
  void updateRemoveQuestion(WidgetRef ref, List _list, int _index) {
    /// データ読込
    final List<TestDataModel> _testDataStore = ref.read(testDataStoreProvider);
    final _removeTestName = ref.read(selectTestNameProvider);
    final _removeQuestionName = _list[_index];
    final _pointList = ref.read(pointListProvider);

    /// questionlistとpointlistのremove
    _list.removeAt(_index);
    _pointList.removeAt(_index);

    /// データの更新
    ref.read(questionListProvider.state).state = [..._list];
    ref.read(pointListProvider.state).state = [..._pointList];

    /// 選択
    List _removeList = [];
    _testDataStore.forEach((_val) {
      if (_val.testname == _removeTestName &&
          _val.question == _removeQuestionName) {
        _removeList.add(_val);
      }
    });

    /// データから削除
    _removeList.forEach((_var) {
      _testDataStore.remove(_var);
    });
  }

  /// TestListPageのCardを削除
  void removeTestListCard(WidgetRef ref, List _testList, int _index) {
    /// データ読込
    final List<TestDataModel> _testDataStore = ref.watch(testDataStoreProvider);
    final _removeTestName = _testList[_index];

    /// 表示から削除
    _testList.removeAt(_index);
    ref.read(testListProvider.state).state = [..._testList];

    /// 選択
    List _removeList = [];
    _testDataStore.forEach((_val) {
      if (_val.testname == _removeTestName) {
        _removeList.add(_val);
      }
    });

    /// データから削除
    _removeList.forEach((_var) {
      _testDataStore.remove(_var);
    });
  }

  void removeMember(WidgetRef ref, List _list, int _index) {
    /// データ読込
    final List<TestDataModel> _testDataStore = ref.watch(testDataStoreProvider);
    final _removeTestName = ref.read(selectTestNameProvider);
    final _removeMemberName = _list[_index];

    /// 表示から削除
    _list.removeAt(_index);
    ref.read(memberListProvider.state).state = [..._list];

    /// 選択
    List _removeList = [];
    _testDataStore.forEach((_val) {
      if (_val.testname == _removeTestName &&
          _val.member == _removeMemberName) {
        _removeList.add(_val);
      }
    });

    /// データから削除
    _removeList.forEach((_var) {
      _testDataStore.remove(_var);
    });
  }
}

/// 各ページの表示に必要なListを初期化
class InitListClass {
  /// For QuestionSetPage
  List qSelectQList(WidgetRef ref) {
    /// データ読込
    final List<TestDataModel> _testDataStore = ref.watch(testDataStoreProvider);
    final _questionList = ref.watch(questionListProvider);

    /// 選別
    _testDataStore.forEach((_val) {
      if (_val.testname == ref.watch(selectTestNameProvider)) {
        _questionList.add(_val.question);
      }
    });

    /// 重複がある場合は除外してreturnする
    return _questionList.toSet().toList();
  }

  /// For MemberSetPage
  List mSelectMList(WidgetRef ref) {
    /// データ読込
    final List<TestDataModel> _testDataStore = ref.watch(testDataStoreProvider);
    final _memberList = ref.watch(memberListProvider);

    /// 選別
    _testDataStore.forEach((_val) {
      if (_val.testname == ref.watch(selectTestNameProvider)) {
        _memberList.add(_val.member);
      }
    });

    /// 重複がある場合は除外してreturnする
    return _memberList.toSet().toList();
  }

  /// For PointSelectPage
  List sSelectQList(WidgetRef ref) {
    final List<TestDataModel> _testDataStore = ref.watch(testDataStoreProvider);
    List _questionList = [];

    _testDataStore.forEach((_val) {
      if (_val.testname == ref.watch(selectTestNameProvider) &&
          _val.member == ref.watch(selectMemberProvider)) {
        _questionList.add(_val.question);
      }
    });

    return _questionList;
  }

  void scoreSelectList(WidgetRef ref) {
    /// 読込
    final _testDataStore = ref.read(testDataStoreProvider);
    final _testName = ref.read(selectTestNameProvider);
    final _member = ref.read(selectMemberProvider);

    List _scoreList = [];
    _testDataStore.forEach((val) {
      if (val.testname == _testName && val.member == _member) {
        _scoreList.add(val.score);
      }
    });

    ref.read(scoreListProvider.state).state = [..._scoreList];
  }
}

/// データモデルの定義
class TestDataModel {
  String testname; // テスト名
  String question; // 設問
  String member; // メンバー

  int point; // 設問の配点
  bool score; // 得点

  TestDataModel(
    this.testname,
    this.question,
    this.member,
    this.point,
    this.score,
  );
}
