
import 'package:flutter/material.dart';
import 'package:flutter_wordle/utils/enums.dart';
import 'package:flutter_wordle/utils/values.dart';
import 'package:flutter_wordle/widgets/keyboard_box.dart';

class ScreenKeyboard extends StatelessWidget {
  const ScreenKeyboard({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Wrap(
          direction: Axis.horizontal,
          children: keyboardKeys.sublist(0, 10).map((letter) => KeyboardBox(
            letter,
            KeyType.letter,
            const Size(52, 72),
          )).toList(),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: keyboardKeys.sublist(10, 21).map((letter) => KeyboardBox(
            letter,
            KeyType.letter,
            const Size(44, 72),
          )).toList(),
        ),
        Wrap(
          direction: Axis.horizontal,
          children: keyboardKeys.sublist(21).map((letter){

            KeyType type = KeyType.letter;
            Size size = const Size(42,72);

            if(letter.compareTo('Backspace') == 0){
              type = KeyType.backspace;
              size = const Size(72, 72);
            }
            else if(letter.compareTo('Enter') == 0){
              type = KeyType.enter;
              size = const Size(72, 72);
            }
            else{
              // do nothing
            }

            return KeyboardBox(
              letter,
              type,
              size
            );
          }).toList(),
        ),
      ],
    );
  }
}