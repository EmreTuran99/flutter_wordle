
import 'package:flutter/material.dart';

enum TextFonts {
  
  kanit("Kanit");

  final String value;
  const TextFonts(this.value);
}

enum RequestStatus {

  notRequested,
  loading,
  success,
  failed
}

enum KeyType {
  letter,
  enter,
  backspace
}

enum GuessLetterStatus {

  notGuessed(Color.fromRGBO(221, 225, 236, 1)),
  nonMatch(Color.fromRGBO(111, 111, 111, 1)),
  falsePlace(Color.fromRGBO(235, 196, 84, 1)),
  match(Color.fromRGBO(135, 182, 94, 1));

  final Color color;
  const GuessLetterStatus(this.color);
}

enum GameStatus {

  continues,
  lost,
  won
}

enum GameLanguage {
  turkish
}