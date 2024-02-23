
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordle/wordle_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdaptiveThemeMode initialThemeMode = await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
  runApp(
    ProviderScope(
      child: WordleApp(initialThemeMode)
    )
  );
}