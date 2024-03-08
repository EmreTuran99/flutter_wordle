
import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordle/services/theme_service.dart';
import 'package:flutter_wordle/utils/enums.dart';
import 'package:flutter_wordle/utils/providers.dart';
import 'package:flutter_wordle/utils/values.dart';
import 'package:flutter_wordle/widgets/game_area/letter_input_row.dart';
import 'package:flutter_wordle/widgets/game_dialog.dart';
import 'package:flutter_wordle/widgets/general/vertical_space.dart';
import 'package:flutter_wordle/widgets/keyboard/screen_keyboard.dart';

class WordleScreen extends ConsumerStatefulWidget {
  const WordleScreen({super.key});

  @override
  ConsumerState<WordleScreen> createState() => _WordleScreenState();
}

class _WordleScreenState extends ConsumerState<WordleScreen> {

  late Size screenSize;

  @override
  void initState() {
    super.initState();
    ThemeService.instance.setServiceContext(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      resetGame();
    });
  }

  void resetGame(){

    int wordIndex = Random().nextInt(availableWords.length);
    ref.read(wordProvider.notifier).update((state) => state = availableWords[wordIndex]);
    ref.read(guessCountProvider.notifier).update((state) => state = 0);
    ref.read(guessesProvider.notifier).update((state) => state = []);
    ref.read(gameOverProvider.notifier).update((state) => state = GameStatus.continues);
    ref.read(screenKeyboardTapProvider.notifier).clearScreenKey();
    ref.read(letterColorMapProvider.notifier).clearLetterColorMap();
  }

  void startNewGame(){

    resetGame();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const WordleScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
  }

  void showGameDialog() async {

    await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)
        ),
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        content: Builder(
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            child: GameDialog(startNewGame),
          )
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    String theWord = ref.watch(wordProvider);
    int guessCounter = ref.watch(guessCountProvider);
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "WORDLE",
          style: TextStyle(
            fontFamily: TextFonts.kanit.value,
            fontWeight: FontWeight.w900,
            fontSize: 36
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: IconButton(
              onPressed: () => showGameDialog(),
              icon: const Icon(
                Icons.question_mark_rounded,
                size: 24,
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Switch(
              value: ThemeService.instance.themeMode.isDark,
              thumbIcon: MaterialStateProperty.resolveWith<Icon?>((states){
                if (states.contains(MaterialState.selected)) {
                  return const Icon(Icons.dark_mode_rounded);
                }
                return const Icon(Icons.light_mode_rounded);
              }),
              onChanged: (value) {
                if(value){
                  ThemeService.instance.setTheme(AdaptiveThemeMode.dark);
                }
                else {
                  ThemeService.instance.setTheme(AdaptiveThemeMode.light);
                }
              },
            ),
          )
        ],
      ),
      body: theWord.isEmpty ? const Center(child: CircularProgressIndicator()) : SizedBox(
        width: screenSize.width,
        child: Column(
          children: [
            const Divider(),
            const VerticalSpace(24),
            ...List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: LetterInputRow(index, theWord.length, index == guessCounter, showGameDialog),
              ),
            ),
            const VerticalSpace(24),
            const SizedBox(
              width: 720,
              child: ScreenKeyboard()
            )
          ],
        ),
      )
    );
  }
}