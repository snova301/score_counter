import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateManagerClass {
  // final darkmodeProvider = FutureProvider((ref) => _getBoolDarkmode());
  final darkmodeStateProvider = StateProvider((ref) => true);
  final testNameControllerStateProvider = StateProvider((ref) {
    return TextEditingController(text: '');
  });
  final questionListStateProvider = StateProvider((ref) => []);
  final memberListStateProvider = StateProvider((ref) => []);
  final testListStateProvider = StateProvider((ref) => ['sa', 'dkfjc']);
  final aListStateProvider = StateProvider((ref) {
    ['s4r2a', 'adyujkfjc'];
  });

  // final darkmodeProvider = StateProvider((ref) => _getBoolDarkmode());
  void main() {}
}

/// for Shared Preference
// Future<bool> _getBoolDarkmode() async {
// // Future<bool> _getBoolDarkmode() async {
//   final prefs = await SharedPreferences.getInstance();
//   // final prefs = await SharedPreferences.getInstance();
//   bool isDarkmode = prefs.getBool('isDarkmode') ?? true;
//   print(isDarkmode);
//   return isDarkmode;
// }
