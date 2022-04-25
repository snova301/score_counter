import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_counter/main.dart';

class StateCulcClass1 {
  void addTestList() {
    // final a = ref.watch(testListProvider);
  }
}

class HomeView extends ConsumerStatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  @override
  void initState() {
    super.initState();
    ref.watch(testListProvider);
  }

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}

class StateCulcClass extends ConsumerWidget {
  const StateCulcClass({Key? key}) : super(key: key);
  void bbb() {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void aaa() {
      final _questionList = ref.watch(questionListProvider);
      print(_questionList);
    }

    // final
    return const Scaffold();
  }
}
