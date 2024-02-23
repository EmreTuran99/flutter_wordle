
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/screen/screen_wordle.dart';

class WordleApp extends StatelessWidget {

  final AdaptiveThemeMode initialThemeMode;
  const WordleApp(this.initialThemeMode, {super.key});

  @override
  Widget build(BuildContext context) {

    return AdaptiveTheme(
      light: ThemeData.light(useMaterial3: true),
      dark: ThemeData.dark(useMaterial3: true),
      initial: initialThemeMode,
      builder: (light, dark) {
        
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          home: const WordleScreen()
        );
      }
    );
  }
}