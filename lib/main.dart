import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
// final aaaaProvider = StateManager.aaaaStateProvider;

/// Riverpod StateProvider for data
final isUpdateQuestionProvider = StateManager.isUpdateQuestionStateProvider;
final isMemberSetModeProvider = StateManager.isMemberSetModeStateProvider;

/// Riverpod StateProvider for data
final testDataStoreProvider = StateManager.testDataStoreProvider;
final pointSumProvider = StateManager.pointSumStateProvider;

/// App settings
class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StateManagerClass().getDarkmodeVal(ref);
    final isDarkmode = ref.watch(darkmodeProvider);

    return MaterialApp(
      title: '採点カウンター',
      theme: ThemeData(
          brightness: isDarkmode ? Brightness.dark : Brightness.light,
          primarySwatch: Colors.green),
      home: const MyHomePage(),
    );
  }
}
