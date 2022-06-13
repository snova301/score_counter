import 'package:flutter/material.dart';

/// データモデルの定義。
/// imuutableで不変化
@immutable
class TestDB {
  final String testID; // テスト名
  final String memberID; // メンバー
  final String questionID; // 設問
  final bool? score; // 得点

  const TestDB(
    this.testID,
    this.memberID,
    this.questionID,
    this.score,
  );

  /// Map型に変換
  Map toFullMap() => {
        testID: {
          memberID: {
            questionID: {
              'score': score,
            },
          },
        }
      };

  /// Map型に変換
  Map<String, Map<String, Map<String, bool?>>> toMemberMap() => {
        memberID: {
          questionID: {
            'score': score,
          },
        }
      };

  /// Map型に変換
  Map<String, Map<String, bool?>> toQuestionMap() => {
        questionID: {
          'score': score,
        },
      };

  /// JSONオブジェクトを代入
  TestDB.fromJson(Map json)
      : testID = json['testname'],
        memberID = json['member'],
        questionID = json['question'],
        score = json['score'];

  TestDB copyWith(
      {String? testID, String? memberID, String? questionID, bool? score}) {
    return TestDB(
      testID ?? this.testID,
      memberID ?? this.memberID,
      questionID ?? this.questionID,
      score ?? this.score,
    );
  }
}

/// テストリストクラス
@immutable
class TestData {
  final String testID; // テストID
  final String testName; // テスト名

  const TestData(
    this.testID,
    this.testName,
  );

  Map toMap() => {
        testID: {
          'name': testName,
        },
      };

  TestData copyWith({String? testID, String? testName}) {
    return TestData(
      testID ?? this.testID,
      testName ?? this.testName,
    );
  }
}

/// メンバークラス
@immutable
class MemberData {
  final String testID; // テストID
  final String memberID; // メンバーID
  final String memberName; // メンバー名

  const MemberData(
    this.testID,
    this.memberID,
    this.memberName,
  );

  Map toMap() => {
        memberID: {
          'name': memberName,
          'testID': testID,
        },
      };

  MemberData copyWith({String? testID, String? memberID, String? memberName}) {
    return MemberData(
      testID ?? this.testID,
      memberID ?? this.memberID,
      memberName ?? this.memberName,
    );
  }
}

/// 質問クラス
@immutable
class QuestionData {
  final String testID;
  final String questionID; // 質問ID
  final String questionName; // 質問名
  final int point; // 配点

  const QuestionData(
    this.testID,
    this.questionID,
    this.questionName,
    this.point,
  );

  Map toMap() => {
        questionID: {
          'name': questionName,
          'point': point,
          'testID': testID,
        },
      };

  QuestionData copyWith(
      {String? testID, String? questionID, String? questionName, int? point}) {
    return QuestionData(
      testID ?? this.testID,
      questionID ?? this.questionID,
      questionName ?? this.questionName,
      point ?? this.point,
    );
  }
}
