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

  /// Map型に変換
  Map toJson() => {
        'testname': testname,
        'question': question,
        'member': member,
        'point': point,
        'score': score,
      };

  /// JSONオブジェクトを代入
  TestDataModel.fromJson(Map json)
      : testname = json['testname'],
        question = json['question'],
        member = json['member'],
        point = json['point'],
        score = json['score'];
}
