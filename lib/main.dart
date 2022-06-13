import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:score_counter/firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:score_counter/view/my_homepage.dart';
import 'package:score_counter/model/state_manager.dart';

/// プラットフォームの確認
final isAndroid =
    defaultTargetPlatform == TargetPlatform.android ? true : false;
final isIOS = defaultTargetPlatform == TargetPlatform.iOS ? true : false;

/// メイン
void main() async {
  /// クラッシュハンドラ
  runZonedGuarded<Future<void>>(
    () async {
      /// Firebaseの初期化
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp(
        // name: isAndroid || isIOS ? 'scco' : null,
        options: DefaultFirebaseOptions.currentPlatform,
      );

      /// クラッシュハンドラ(Flutterフレームワーク内でスローされたすべてのエラー)
      if (isAndroid || isIOS) {
        FlutterError.onError =
            FirebaseCrashlytics.instance.recordFlutterFatalError;
      }

      /// runApp w/ Riverpod
      runApp(const ProviderScope(child: MyApp()));
    },

    /// クラッシュハンドラ(Flutterフレームワーク内でキャッチされないエラー)

    (error, stack) => {
      if (isAndroid || isIOS)
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true)
    },
  );
}

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

    /// shared_prefのデータを取得
    LocalSave().getPref(ref);
    LocalSave().getData(ref);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkmode = ref.watch(settingProvider)['darkmode'];

    return MaterialApp(
      title: '採点カウンター SCCO',
      home: const MyHomePage(),
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDarkmode ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.blue,
        // primarySwatch: Colors.blue,
        fontFamily: 'NotoSansJP',
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', ''),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
