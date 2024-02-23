
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_wordle/utils/enums.dart';

class GuessLetter {

  int index;
  String letter;
  GuessLetterStatus status;

  GuessLetter({
    required this.index,
    required this.letter,
    required this.status,
  });
}
