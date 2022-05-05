import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:score_counter/view/myHomePage.dart';
import 'package:score_counter/model/stateManager.dart';

/// main function
void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

/// Riverpod StateProvider for setteing
final StateManager = StateManagerClass();
final darkmodeProvider = StateManager.darkmodeStateProvider;

/// Riverpod StateProvider for textcontroller
final testNameControllerProvider = StateManager.testNameControllerStateProvider;
final memberNameControllerProvider =
    StateManager.memberNameControllerStateProvider;
final questionNameControllerProvider =
    StateManager.questionNameControllerStateProvider;

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
      title: '採点カウンター',
      theme: ThemeData(
          brightness: isDarkmode ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.green),
      home: const MyHomePage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
    );
  }
}
