
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wordle/utils/enums.dart';

class LetterColorMapStateNotifier extends StateNotifier<Map<String, GuessLetterStatus>> {
  LetterColorMapStateNotifier() : super({});

  void setLetterColorMap(Map<String, GuessLetterStatus> colorMap){
    state = colorMap;
  }

  void clearLetterColorMap(){
    state = {};
  }
}