
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordle/model/letter_color_map_state_notifier.dart';
import 'package:flutter_wordle/model/screen_key.dart';
import 'package:flutter_wordle/utils/enums.dart';

final wordProvider = StateProvider<String>((ref) => "");

final guessCountProvider = StateProvider<int>((ref) => 0);

final guessesProvider = StateProvider<List<String>>((ref) => []);

final gameOverProvider = StateProvider<GameStatus>((ref) => GameStatus.continues);

final screenKeyboardTapProvider = StateNotifierProvider<ScreenKeyNotifier, ScreenKey?>((ref){
  return ScreenKeyNotifier();
});

final letterColorMapProvider = StateNotifierProvider<LetterColorMapStateNotifier, Map<String, GuessLetterStatus>>((ref){
  return LetterColorMapStateNotifier();
});