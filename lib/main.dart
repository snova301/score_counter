import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'view/myHomePage.dart';
import 'model/stateManager.dart';

/// main function
void main() {
  // runApp(const MyApp());
  runApp(const ProviderScope(child: MyApp()));
}

/// for riverpod
var darkmodeProvider = StateManagerClass().darkmodeProvider;

/// App settings
class MyApp extends ConsumerWidget {
// class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Widget build(BuildContext context) {

    final isDarkmode = ref.watch(darkmodeProvider.state).state;

    return MaterialApp(
      title: '採点カウンター',
      theme: isDarkmode
          ? ThemeData.dark()
          : ThemeData(
              primarySwatch: Colors.green,
            ),
      home: const MyHomePage(),
    );
  }
}
