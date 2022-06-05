import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:score_counter/firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:score_counter/view/myHomePage.dart';
import 'package:score_counter/model/stateManager.dart';

/// プラットフォームの確認
final isAndroid =
    defaultTargetPlatform == TargetPlatform.android ? true : false;
final isIOS = defaultTargetPlatform == TargetPlatform.iOS ? true : false;

/// メイン
void main() async {
  /// クラッシュハンドラ
  runZonedGuarded<Future<void>>(() async {
    /// Firebaseの初期化
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      name: isAndroid || isIOS ? 'scco' : null,
      options: DefaultFirebaseOptions.currentPlatform,
    );

    /// クラッシュハンドラ(Flutterフレームワーク内でスローされたすべてのエラー)
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    /// runApp w/ Riverpod
    runApp(const ProviderScope(child: MyApp()));
  },

      /// クラッシュハンドラ(Flutterフレームワーク内でキャッチされないエラー)
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

/// Riverpod StateProvider for setteing
final StateManager = StateManagerClass();
final darkmodeProvider = StateManager.darkmodeStateProvider;

/// Riverpod StateProvider for textcontroller
final testNameControllerProvider = StateManager.testNameControllerStateProvider;

/// Riverpod StateProvider for list
final testListProvider = StateManager.testListStateProvider;
final questionListProvider = StateManager.questionListStateProvider;
final memberListProvider = StateManager.memberListStateProvider;
final pointListProvider = StateManager.pointListStateProvider;
final scoreListProvider = StateManager.scoreListStateProvider;

/// Riverpod StateProvider for select
final selectTestNameProvider = StateManager.selectTestNameStateProvider;
final selectQuestionProvider = StateManager.selectQuestionStateProvider;
final selectMemberProvider = StateManager.selectMemberStateProvider;
final selectPointProvider = StateManager.selectPointStateProvider;

/// Riverpod StateProvider for data
final isUpdateQuestionProvider = StateManager.isUpdateQuestionStateProvider;
final isMemberSetModeProvider = StateManager.isMemberSetModeStateProvider;

/// Riverpod StateProvider for data
final testDataStoreProvider = StateManager.testDataStoreStateProvider;
final pointSumProvider = StateManager.pointSumStateProvider;

/// App settings
class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    StateManagerClass().getDarkmodeVal(ref);
    StateManagerClass().getTestModel(ref);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = ref.watch(darkmodeProvider);

    return MaterialApp(
      title: '採点カウンター SCCO (β)',
      home: const MyHomePage(),
      theme: ThemeData(
        brightness: isDarkmode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.teal,
        fontFamily: 'NotoSansJP',
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ja', ''),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
